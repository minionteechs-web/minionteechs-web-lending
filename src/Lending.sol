// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/**
 * @title WebLending
 * @dev A decentralized lending protocol allowing users to deposit collateral, borrow assets, and earn interest.
 */
contract WebLending is Ownable, ReentrancyGuard {
    // ============ Events ============
    event Deposited(address indexed user, uint256 amount, address indexed token);
    event Withdrawn(address indexed user, uint256 amount, address indexed token);
    event Borrowed(address indexed user, uint256 amount, address indexed token);
    event Repaid(address indexed user, uint256 amount, address indexed token);
    event LiquidationPerformed(
        address indexed liquidator,
        address indexed borrower,
        uint256 collateralAmount,
        uint256 debtRepaid
    );
    event InterestAccrued(address indexed user, uint256 amount, address indexed token);

    // ============ State Variables ============
    struct UserData {
        uint256 collateral;
        uint256 borrowed;
        uint256 lastUpdate;
    }

    mapping(address => mapping(address => UserData)) public userData;
    mapping(address => uint256) public tokenInterestRate; // Interest rate per token (in basis points)
    mapping(address => uint256) public totalCollateral;
    mapping(address => uint256) public totalBorrowed;

    uint256 public constant COLLATERAL_RATIO = 150; // 150% collateralization required
    uint256 public constant LIQUIDATION_PENALTY = 10; // 10% penalty
    uint256 public constant BASIS_POINTS = 10000;
    uint256 public constant INTEREST_RATE_PRECISION = 1e18;

    // ============ Constructor ============
    constructor() {}

    // ============ Deposit Functions ============
    /**
     * @dev Deposit collateral tokens
     */
    function deposit(address token, uint256 amount) external nonReentrant {
        require(amount > 0, "Amount must be greater than 0");
        require(token != address(0), "Invalid token address");

        ERC20(token).transferFrom(msg.sender, address(this), amount);

        UserData storage user = userData[msg.sender][token];
        user.collateral += amount;
        user.lastUpdate = block.timestamp;
        totalCollateral[token] += amount;

        emit Deposited(msg.sender, amount, token);
    }

    /**
     * @dev Withdraw collateral tokens
     */
    function withdraw(address token, uint256 amount) external nonReentrant {
        require(amount > 0, "Amount must be greater than 0");

        UserData storage user = userData[msg.sender][token];
        require(user.collateral >= amount, "Insufficient collateral");

        // Accrue interest
        _accrueInterest(msg.sender, token);

        // Check if withdrawal would violate collateral ratio
        uint256 newCollateral = user.collateral - amount;
        require(
            _isHealthy(msg.sender, token, newCollateral, user.borrowed),
            "Withdrawal would violate collateral ratio"
        );

        user.collateral -= amount;
        user.lastUpdate = block.timestamp;
        totalCollateral[token] -= amount;

        ERC20(token).transfer(msg.sender, amount);

        emit Withdrawn(msg.sender, amount, token);
    }

    // ============ Borrow Functions ============
    /**
     * @dev Borrow tokens against collateral
     */
    function borrow(address collateralToken, address borrowToken, uint256 amount) external nonReentrant {
        require(amount > 0, "Amount must be greater than 0");
        require(collateralToken != borrowToken, "Cannot borrow same token as collateral");

        UserData storage collateral = userData[msg.sender][collateralToken];
        UserData storage debt = userData[msg.sender][borrowToken];

        // Accrue interest on existing debt
        _accrueInterest(msg.sender, borrowToken);

        uint256 newDebt = debt.borrowed + amount;
        require(
            _isHealthy(msg.sender, collateralToken, collateral.collateral, newDebt),
            "Insufficient collateral for borrow"
        );

        debt.borrowed += amount;
        debt.lastUpdate = block.timestamp;
        totalBorrowed[borrowToken] += amount;

        ERC20(borrowToken).transfer(msg.sender, amount);

        emit Borrowed(msg.sender, amount, borrowToken);
    }

    /**
     * @dev Repay borrowed tokens
     */
    function repay(address token, uint256 amount) external nonReentrant {
        require(amount > 0, "Amount must be greater than 0");

        UserData storage user = userData[msg.sender][token];
        _accrueInterest(msg.sender, token);

        require(user.borrowed >= amount, "Repay amount exceeds debt");

        ERC20(token).transferFrom(msg.sender, address(this), amount);

        user.borrowed -= amount;
        user.lastUpdate = block.timestamp;
        totalBorrowed[token] -= amount;

        emit Repaid(msg.sender, amount, token);
    }

    // ============ Liquidation Functions ============
    /**
     * @dev Liquidate an unhealthy position
     */
    function liquidate(address borrower, address collateralToken, address debtToken) external nonReentrant {
        UserData storage collateral = userData[borrower][collateralToken];
        UserData storage debt = userData[borrower][debtToken];

        _accrueInterest(borrower, debtToken);

        require(!_isHealthy(borrower, collateralToken, collateral.collateral, debt.borrowed), "Position is healthy");
        require(debt.borrowed > 0, "No debt to liquidate");

        uint256 repayAmount = (debt.borrowed * (BASIS_POINTS + LIQUIDATION_PENALTY)) / BASIS_POINTS;
        require(repayAmount <= debt.borrowed + (debt.borrowed / BASIS_POINTS) * LIQUIDATION_PENALTY, "Overflow");

        ERC20(debtToken).transferFrom(msg.sender, address(this), repayAmount);

        uint256 liquidationBonus = (collateral.collateral * LIQUIDATION_PENALTY) / BASIS_POINTS;
        uint256 collateralToTransfer = liquidationBonus;

        debt.borrowed = 0;
        collateral.collateral -= collateralToTransfer;
        totalBorrowed[debtToken] -= repayAmount;
        totalCollateral[collateralToken] -= collateralToTransfer;

        ERC20(collateralToken).transfer(msg.sender, collateralToTransfer);

        emit LiquidationPerformed(msg.sender, borrower, collateralToTransfer, repayAmount);
    }

    // ============ Interest Functions ============
    /**
     * @dev Set interest rate for a token
     */
    function setInterestRate(address token, uint256 ratePerSecond) external onlyOwner {
        require(ratePerSecond <= BASIS_POINTS, "Rate too high");
        tokenInterestRate[token] = ratePerSecond;
    }

    /**
     * @dev Accrue interest on user's debt
     */
    function _accrueInterest(address user, address token) internal {
        UserData storage userData_ = userData[user][token];
        if (userData_.borrowed == 0) return;

        uint256 timePassed = block.timestamp - userData_.lastUpdate;
        uint256 interestAccrued = (userData_.borrowed * tokenInterestRate[token] * timePassed) / INTEREST_RATE_PRECISION;

        userData_.borrowed += interestAccrued;
        userData_.lastUpdate = block.timestamp;

        if (interestAccrued > 0) {
            emit InterestAccrued(user, interestAccrued, token);
        }
    }

    // ============ View Functions ============
    /**
     * @dev Check if a position is healthy (meets collateral ratio)
     */
    function isHealthy(address user, address collateralToken, address debtToken) external view returns (bool) {
        UserData storage collateral = userData[user][collateralToken];
        UserData storage debt = userData[user][debtToken];
        return _isHealthy(user, collateralToken, collateral.collateral, debt.borrowed);
    }

    /**
     * @dev Internal function to check health
     */
    function _isHealthy(address user, address collateralToken, uint256 collateralAmount, uint256 debtAmount)
        internal
        view
        returns (bool)
    {
        if (debtAmount == 0) return true;
        return (collateralAmount * BASIS_POINTS) >= (debtAmount * COLLATERAL_RATIO);
    }

    /**
     * @dev Get user's total collateral value
     */
    function getUserCollateral(address user, address token) external view returns (uint256) {
        return userData[user][token].collateral;
    }

    /**
     * @dev Get user's total borrowed amount with accrued interest
     */
    function getUserDebt(address user, address token) external view returns (uint256) {
        UserData storage user_ = userData[user][token];
        uint256 timePassed = block.timestamp - user_.lastUpdate;
        uint256 interest = (user_.borrowed * tokenInterestRate[token] * timePassed) / INTEREST_RATE_PRECISION;
        return user_.borrowed + interest;
    }

    /**
     * @dev Get liquidation price for a position
     */
    function getLiquidationPrice(address user, address collateralToken, address debtToken)
        external
        view
        returns (uint256)
    {
        UserData storage debt = userData[user][debtToken];
        UserData storage collateral = userData[user][collateralToken];

        if (collateral.collateral == 0) return 0;

        return (debt.borrowed * COLLATERAL_RATIO) / collateral.collateral;
    }
}
