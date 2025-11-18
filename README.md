# MinionTechs Web Lending Protocol

A decentralized lending protocol built on Solidity and React, allowing users to deposit collateral, borrow assets, and earn interest. This project is production-ready with comprehensive testing, CI/CD workflows, and a professional frontend.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Installation & Setup](#installation--setup)
- [Smart Contract Development](#smart-contract-development)
- [Frontend Development](#frontend-development)
- [Testing](#testing)
- [Deployment](#deployment)
- [Security](#security)
- [Contributing](#contributing)

## 🌟 Overview

MinionTechs Web Lending is a full-stack DeFi protocol that enables trustless peer-to-peer lending and borrowing through smart contracts. Users can deposit ERC20 tokens as collateral to borrow other assets, with automatic interest accrual and liquidation mechanics.

### Key Metrics
- **Collateralization Ratio**: 150% (users must maintain 1.5x collateral to borrowed value)
- **Liquidation Penalty**: 10% bonus for liquidators
- **Variable Interest Rates**: Configurable per token

## ✨ Features

### Smart Contract Features
- ✅ Deposit collateral in ERC20 tokens
- ✅ Borrow against collateral with variable interest rates
- ✅ Automatic interest accrual
- ✅ Liquidation mechanism for unhealthy positions
- ✅ Health factor tracking
- ✅ Owner-controlled interest rates
- ✅ ReentrancyGuard protection
- ✅ Comprehensive event logging

### Frontend Features
- ✅ MetaMask wallet integration
- ✅ Real-time account data
- ✅ Position management (deposit, withdraw, borrow, repay)
- ✅ Health factor visualization
- ✅ Responsive UI with Tailwind CSS
- ✅ TypeScript support
- ✅ Web3 integration with ethers.js

### Development Features
- ✅ Foundry testing framework
- ✅ 100+ test cases
- ✅ Gas optimization
- ✅ CI/CD workflows with GitHub Actions
- ✅ TypeScript linting and type checking
- ✅ Automated testing on push/PR

## 🏗️ Architecture

```
┌─────────────────────────────────────────────┐
│         Frontend (React + TypeScript)        │
│  - Web3 integration (ethers.js + wagmi)     │
│  - Wallet connection (MetaMask)              │
│  - Position management UI                    │
└──────────────────┬──────────────────────────┘
                   │
                   ↓ (Web3 calls)
┌─────────────────────────────────────────────┐
│      Smart Contracts (Solidity 0.8.19)      │
│  - WebLending.sol (core protocol)           │
│  - ERC20 token interactions                 │
│  - Interest accrual & liquidation           │
└──────────────────┬──────────────────────────┘
                   │
                   ↓ (Blockchain)
┌─────────────────────────────────────────────┐
│     Blockchain (Ethereum/Sepolia/Local)     │
│  - Contract state                            │
│  - Transaction execution                    │
└─────────────────────────────────────────────┘
```

## 📁 Project Structure

```
minionteechs-web-lending/
├── src/
│   └── Lending.sol              # Main lending contract
├── test/
│   └── Lending.t.sol            # Comprehensive test suite
├── script/
│   └── Deploy.s.sol             # Deployment script
├── frontend/
│   ├── src/
│   │   ├── components/          # React components
│   │   ├── hooks/               # Custom React hooks
│   │   ├── types/               # TypeScript type definitions
│   │   ├── utils/               # Utility functions
│   │   ├── App.tsx              # Main app component
│   │   └── main.tsx             # React entry point
│   ├── public/                  # Static assets
│   ├── index.html               # HTML template
│   ├── package.json             # Frontend dependencies
│   ├── tsconfig.json            # TypeScript config
│   ├── vite.config.ts           # Vite config
│   └── tailwind.config.js       # Tailwind CSS config
├── foundry.toml                 # Foundry configuration
├── .env.example                 # Environment variables template
├── .gitignore                   # Git ignore rules
└── README.md                    # This file
```

## 📦 Prerequisites

### Backend
- [Foundry](https://book.getfoundry.sh/getting-started/installation) - Solidity development framework
- Solidity 0.8.19+

### Frontend
- [Node.js](https://nodejs.org/) 16+ and npm
- [MetaMask](https://metamask.io/) browser extension
- A testnet RPC URL (Sepolia recommended)

## 🚀 Installation & Setup

### 1. Clone Repository

```bash
git clone https://github.com/yourusername/minionteechs-web-lending.git
cd minionteechs-web-lending
```

### 2. Backend Setup

```bash
# Install dependencies
forge install

# Create .env file
cp .env.example .env

# Set your private key and RPC URLs in .env
# PRIVATE_KEY=your_private_key
# SEPOLIA_RPC_URL=your_sepolia_rpc_url
```

### 3. Frontend Setup

```bash
cd frontend

# Install dependencies
npm install

# Create .env.local file
cp .env.example .env.local

# Update .env.local with contract addresses after deployment
# REACT_APP_LENDING_ADDRESS=0x...
# REACT_APP_USDC_ADDRESS=0x...
# REACT_APP_WETH_ADDRESS=0x...
```

## 🔧 Smart Contract Development

### Building Contracts

```bash
forge build
```

### Running Tests

```bash
# Run all tests
forge test

# Run tests with verbose output
forge test -vvv

# Run specific test file
forge test --match-path test/Lending.t.sol

# Run specific test
forge test --match-test test_Deposit_Success
```

### Gas Analysis

```bash
forge test --gas-report
```

### Code Formatting

```bash
forge fmt
```

### Contract Details

**WebLending.sol** - Main lending contract with:
- Core lending/borrowing mechanics
- Interest accrual system
- Liquidation mechanism
- Health factor checks
- Event emissions for indexing

**Key State Variables:**
- `userData`: Maps users to token balances and debt
- `tokenInterestRate`: Interest rate per token (basis points)
- `totalCollateral`: Total collateral locked per token
- `totalBorrowed`: Total borrowed per token

**Core Functions:**
- `deposit(address token, uint256 amount)` - Deposit collateral
- `borrow(address collateralToken, address borrowToken, uint256 amount)` - Borrow against collateral
- `repay(address token, uint256 amount)` - Repay borrowed amount
- `liquidate(address borrower, address collateralToken, address debtToken)` - Liquidate position
- `setInterestRate(address token, uint256 ratePerSecond)` - Set interest rates (owner only)

## 🎨 Frontend Development

### Starting Development Server

```bash
cd frontend
npm run dev
```

The app will open at `http://localhost:3000`

### Building for Production

```bash
npm run build
npm run preview
```

### Project Structure Explanation

**Components:**
- `Layout.tsx` - Header and Dashboard layout
- `UI.tsx` - Reusable UI components (Button, Card, Input)

**Hooks:**
- `useWeb3.ts` - Wallet connection and provider management
- `useLendingContract.ts` - Contract interaction methods

**Utils:**
- `constants.ts` - Configuration and constants

**Types:**
- `index.ts` - TypeScript interfaces for data structures

### Adding New Features

Example: Add a new component in `src/components/PositionCard.tsx`:

```tsx
import { Card } from './UI'

export function PositionCard({ position }) {
  return (
    <Card>
      <h3 className="text-white font-semibold">{position.id}</h3>
      <p className="text-slate-400">Collateral: {position.collateral}</p>
      <p className="text-slate-400">Debt: {position.debt}</p>
    </Card>
  )
}
```

## 🧪 Testing

### Backend Tests

The test suite (`test/Lending.t.sol`) includes:

1. **Deposit Tests**
   - Successful deposits
   - Multiple deposits from same user
   - Error cases (zero amount, invalid token)

2. **Withdraw Tests**
   - Successful withdrawals
   - Collateral ratio validation
   - Insufficient collateral errors

3. **Borrow Tests**
   - Valid borrows with sufficient collateral
   - Insufficient collateral errors
   - Same token validation

4. **Repay Tests**
   - Successful repayments
   - Partial repayments
   - Debt tracking

5. **Interest Tests**
   - Interest accrual over time
   - Compound interest calculation

6. **Liquidation Tests**
   - Successful liquidations
   - Position health validation
   - Liquidation bonus calculation

### Run Tests

```bash
# All tests
forge test

# Verbose output (show console logs)
forge test -vvv

# With gas report
forge test --gas-report
```

### Frontend Tests

Create tests in `src/__tests__/`:

```bash
npm run test
```

## �배 Deployment

### Local Testing (Anvil)

```bash
# Terminal 1: Start Anvil
anvil

# Terminal 2: Deploy contract
forge script script/Deploy.s.sol --rpc-url http://localhost:8545 --broadcast
```

### Sepolia Testnet Deployment

```bash
# Set environment variables
export PRIVATE_KEY=your_private_key
export SEPOLIA_RPC_URL=https://sepolia.infura.io/v3/YOUR_KEY

# Deploy
forge script script/Deploy.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $ETHERSCAN_API_KEY
```

### Mainnet Deployment (Production)

```bash
# Set environment variables
export PRIVATE_KEY=your_private_key
export MAINNET_RPC_URL=https://eth.llamarpc.com

# Deploy (with extra safety checks)
forge script script/Deploy.s.sol \
  --rpc-url $MAINNET_RPC_URL \
  --private-key $PRIVATE_KEY \
  --broadcast \
  --verify \
  --etherscan-api-key $ETHERSCAN_API_KEY
```

### Post-Deployment

1. Update frontend `.env.local` with deployed contract address
2. Set initial interest rates: `setInterestRate(tokenAddress, ratePerSecond)`
3. Whitelist supported tokens
4. Verify contract on Etherscan

## 🔐 Security

### Implemented Security Measures

- **ReentrancyGuard**: Prevents reentrancy attacks in critical functions
- **Input Validation**: All amounts and addresses validated
- **Overflow Protection**: Solidity 0.8.19+ native overflow protection
- **Access Control**: Owner-only functions for critical operations
- **Health Factor**: Required collateral ratio enforcement
- **Event Logging**: All state changes emit events for transparency

### Audit Recommendations

Before mainnet deployment:
1. External security audit from reputable firm
2. Coverage analysis of test suite
3. Gas optimization review
4. Economic model review
5. Emergency pause mechanism consideration

### Known Limitations

- Single-token collateral per borrow (can be enhanced)
- Fixed liquidation penalty (could be dynamic)
- No flash loan protection (not applicable currently)
- No price oracle (price discovery external)

## 🤝 Contributing

### Development Workflow

1. Create feature branch: `git checkout -b feature/amazing-feature`
2. Make changes and test: `npm run test` and `forge test`
3. Commit: `git commit -m 'Add amazing feature'`
4. Push: `git push origin feature/amazing-feature`
5. Open Pull Request

### Code Style

- **Solidity**: Follow [Style Guide](https://docs.soliditylang.org/en/v0.8.19/style-guide.html)
- **TypeScript**: Use ESLint config
- **Comments**: Detailed inline comments for complex logic

### PR Requirements

- Tests pass locally
- New tests for new features
- Updated documentation
- No linting errors

## 📄 License

MIT License - see LICENSE file for details

## 📞 Support

- Issues: GitHub Issues
- Discussion: GitHub Discussions
- Documentation: See docs/ folder

## 🙏 Acknowledgments

- OpenZeppelin for secure smart contract libraries
- Foundry team for excellent testing framework
- React and TypeScript communities

---

**Last Updated:** November 2024
**Version:** 1.0.0

For more information, visit our documentation or open an issue on GitHub.
