// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {WebLending} from "../src/Lending.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/ERC20Mock.sol";

contract LendingTest is Test {
    WebLending public lending;
    ERC20Mock public usdc;
    ERC20Mock public weth;

    address public alice = makeAddr("alice");
    address public bob = makeAddr("bob");
    address public charlie = makeAddr("charlie");

    uint256 public constant INITIAL_BALANCE = 1000 ether;
    uint256 public constant INTEREST_RATE = 317097920; // ~1% per year

    function setUp() public {
        lending = new WebLending();
        usdc = new ERC20Mock();
        weth = new ERC20Mock();

        // Mint tokens
        usdc.mint(alice, INITIAL_BALANCE);
        usdc.mint(bob, INITIAL_BALANCE);
        weth.mint(charlie, INITIAL_BALANCE);

        // Set interest rates
        vm.prank(address(lending.owner()));
        lending.setInterestRate(address(usdc), INTEREST_RATE);
    }

    // ============ Deposit Tests ============
    function test_Deposit_Success() public {
        uint256 depositAmount = 100 ether;

        vm.startPrank(alice);
        usdc.approve(address(lending), depositAmount);
        lending.deposit(address(usdc), depositAmount);
        vm.stopPrank();

        assertEq(lending.getUserCollateral(alice, address(usdc)), depositAmount);
        assertEq(usdc.balanceOf(address(lending)), depositAmount);
    }

    function test_Deposit_MultipleDeposits() public {
        uint256 amount1 = 50 ether;
        uint256 amount2 = 50 ether;

        vm.startPrank(alice);
        usdc.approve(address(lending), amount1 + amount2);
        lending.deposit(address(usdc), amount1);
        lending.deposit(address(usdc), amount2);
        vm.stopPrank();

        assertEq(lending.getUserCollateral(alice, address(usdc)), amount1 + amount2);
    }

    function test_Deposit_Fails_ZeroAmount() public {
        vm.prank(alice);
        vm.expectRevert("Amount must be greater than 0");
        lending.deposit(address(usdc), 0);
    }

    function test_Deposit_Fails_ZeroAddress() public {
        vm.prank(alice);
        vm.expectRevert("Invalid token address");
        lending.deposit(address(0), 100 ether);
    }

    // ============ Withdraw Tests ============
    function test_Withdraw_Success() public {
        uint256 depositAmount = 100 ether;
        uint256 withdrawAmount = 50 ether;

        vm.startPrank(alice);
        usdc.approve(address(lending), depositAmount);
        lending.deposit(address(usdc), depositAmount);
        lending.withdraw(address(usdc), withdrawAmount);
        vm.stopPrank();

        assertEq(lending.getUserCollateral(alice, address(usdc)), depositAmount - withdrawAmount);
    }

    function test_Withdraw_Fails_InsufficientCollateral() public {
        uint256 depositAmount = 100 ether;

        vm.startPrank(alice);
        usdc.approve(address(lending), depositAmount);
        lending.deposit(address(usdc), depositAmount);

        vm.expectRevert("Insufficient collateral");
        lending.withdraw(address(usdc), depositAmount + 1);
        vm.stopPrank();
    }

    // ============ Borrow Tests ============
    function test_Borrow_Success() public {
        uint256 collateralAmount = 100 ether;
        uint256 borrowAmount = 50 ether;

        vm.startPrank(alice);
        usdc.approve(address(lending), collateralAmount);
        lending.deposit(address(usdc), collateralAmount);
        vm.stopPrank();

        vm.startPrank(bob);
        weth.approve(address(lending), borrowAmount);
        weth.transfer(address(lending), borrowAmount);
        vm.stopPrank();

        vm.prank(alice);
        lending.borrow(address(usdc), address(weth), borrowAmount);

        assertEq(lending.getUserDebt(alice, address(weth)), borrowAmount);
    }

    function test_Borrow_Fails_InsufficientCollateral() public {
        uint256 collateralAmount = 10 ether;
        uint256 borrowAmount = 100 ether;

        vm.startPrank(alice);
        usdc.approve(address(lending), collateralAmount);
        lending.deposit(address(usdc), collateralAmount);

        vm.expectRevert("Insufficient collateral for borrow");
        lending.borrow(address(usdc), address(weth), borrowAmount);
        vm.stopPrank();
    }

    function test_Borrow_Fails_SameToken() public {
        uint256 collateralAmount = 100 ether;

        vm.startPrank(alice);
        usdc.approve(address(lending), collateralAmount);
        lending.deposit(address(usdc), collateralAmount);

        vm.expectRevert("Cannot borrow same token as collateral");
        lending.borrow(address(usdc), address(usdc), 50 ether);
        vm.stopPrank();
    }

    // ============ Repay Tests ============
    function test_Repay_Success() public {
        uint256 collateralAmount = 100 ether;
        uint256 borrowAmount = 50 ether;
        uint256 repayAmount = 25 ether;

        // Setup
        vm.startPrank(alice);
        usdc.approve(address(lending), collateralAmount);
        lending.deposit(address(usdc), collateralAmount);
        vm.stopPrank();

        vm.startPrank(bob);
        weth.approve(address(lending), borrowAmount);
        weth.transfer(address(lending), borrowAmount);
        vm.stopPrank();

        vm.prank(alice);
        lending.borrow(address(usdc), address(weth), borrowAmount);

        // Repay
        vm.startPrank(alice);
        weth.approve(address(lending), repayAmount);
        lending.repay(address(weth), repayAmount);
        vm.stopPrank();

        assertEq(lending.getUserDebt(alice, address(weth)), borrowAmount - repayAmount);
    }

    // ============ Interest Tests ============
    function test_Interest_Accrues() public {
        uint256 collateralAmount = 100 ether;
        uint256 borrowAmount = 50 ether;

        vm.startPrank(alice);
        usdc.approve(address(lending), collateralAmount);
        lending.deposit(address(usdc), collateralAmount);
        vm.stopPrank();

        vm.startPrank(bob);
        weth.approve(address(lending), borrowAmount);
        weth.transfer(address(lending), borrowAmount);
        vm.stopPrank();

        vm.prank(alice);
        lending.borrow(address(usdc), address(weth), borrowAmount);

        uint256 debtBefore = lending.getUserDebt(alice, address(weth));

        // Warp time
        vm.warp(block.timestamp + 365 days);

        uint256 debtAfter = lending.getUserDebt(alice, address(weth));

        assertGt(debtAfter, debtBefore);
    }

    // ============ Health Check Tests ============
    function test_IsHealthy_InitiallyTrue() public {
        uint256 collateralAmount = 100 ether;

        vm.startPrank(alice);
        usdc.approve(address(lending), collateralAmount);
        lending.deposit(address(usdc), collateralAmount);
        vm.stopPrank();

        assertTrue(lending.isHealthy(alice, address(usdc), address(weth)));
    }

    function test_IsHealthy_WithDebt() public {
        uint256 collateralAmount = 100 ether;
        uint256 borrowAmount = 50 ether;

        vm.startPrank(alice);
        usdc.approve(address(lending), collateralAmount);
        lending.deposit(address(usdc), collateralAmount);
        vm.stopPrank();

        vm.startPrank(bob);
        weth.approve(address(lending), borrowAmount);
        weth.transfer(address(lending), borrowAmount);
        vm.stopPrank();

        vm.prank(alice);
        lending.borrow(address(usdc), address(weth), borrowAmount);

        assertTrue(lending.isHealthy(alice, address(usdc), address(weth)));
    }

    // ============ Liquidation Tests ============
    function test_Liquidation_Success() public {
        uint256 collateralAmount = 100 ether;
        uint256 borrowAmount = 60 ether;

        // Setup alice's position
        vm.startPrank(alice);
        usdc.approve(address(lending), collateralAmount);
        lending.deposit(address(usdc), collateralAmount);
        vm.stopPrank();

        vm.startPrank(bob);
        weth.approve(address(lending), borrowAmount);
        weth.transfer(address(lending), borrowAmount);
        vm.stopPrank();

        vm.prank(alice);
        lending.borrow(address(usdc), address(weth), borrowAmount);

        // Simulate price drop by advancing time significantly
        vm.warp(block.timestamp + 365 days);

        // Charlie liquidates alice
        vm.startPrank(charlie);
        weth.approve(address(lending), borrowAmount + (borrowAmount * 10 / 100));
        lending.liquidate(alice, address(usdc), address(weth));
        vm.stopPrank();

        assertEq(lending.getUserDebt(alice, address(weth)), 0);
    }

    function test_Liquidation_Fails_HealthyPosition() public {
        uint256 collateralAmount = 100 ether;
        uint256 borrowAmount = 50 ether;

        vm.startPrank(alice);
        usdc.approve(address(lending), collateralAmount);
        lending.deposit(address(usdc), collateralAmount);
        vm.stopPrank();

        vm.startPrank(bob);
        weth.approve(address(lending), borrowAmount);
        weth.transfer(address(lending), borrowAmount);
        vm.stopPrank();

        vm.prank(alice);
        lending.borrow(address(usdc), address(weth), borrowAmount);

        vm.startPrank(charlie);
        vm.expectRevert("Position is healthy");
        lending.liquidate(alice, address(usdc), address(weth));
        vm.stopPrank();
    }
}
