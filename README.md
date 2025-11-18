# MinionTechs Lending Protocol

A decentralized lending protocol built with Solidity and React. Deposit collateral, borrow assets, and earn yield through smart contracts and a modern frontend.

## Features

**Smart Contracts**
- Deposit ERC20 tokens as collateral
- Borrow against collateral (150% collateralization ratio)
- Variable interest rates per token
- Automatic liquidation mechanism with 10% penalty
- Health factor tracking

**Frontend**
- MetaMask wallet integration
- Real-time account data and position tracking
- Responsive UI built with React + Tailwind CSS
- TypeScript for type safety

## Tech Stack

- **Backend**: Solidity 0.8.19, Foundry
- **Frontend**: React 18, TypeScript, Vite, Tailwind CSS
- **Web3**: ethers.js v6, MetaMask
- **Testing**: Foundry (15+ test cases)
- **CI/CD**: GitHub Actions

## Project Structure

```
src/                   # Smart contracts
test/                  # Contract tests
script/                # Deployment scripts
frontend/              # React application
.github/workflows/     # CI/CD pipelines
```

## Getting Started

### Prerequisites

- [Foundry](https://book.getfoundry.sh/) for smart contract development
- [Node.js](https://nodejs.org/) 16+ for frontend
- [MetaMask](https://metamask.io/) browser extension

### Setup

```bash
# Clone repository
git clone https://github.com/yourusername/minionteechs-web-lending.git
cd minionteechs-web-lending

# Install Foundry dependencies
forge install

# Install frontend dependencies
cd frontend && npm install && cd ..
```

### Environment Configuration

Create `.env` file:
```bash
cp .env.example .env
```

Update with your values:
```
PRIVATE_KEY=your_private_key_here
SEPOLIA_RPC_URL=https://eth-sepolia.g.alchemy.com/v2/your-api-key
MAINNET_RPC_URL=https://eth-mainnet.g.alchemy.com/v2/your-api-key
```

## Development

### Smart Contracts

```bash
# Build contracts
forge build

# Run tests
forge test

# Run with verbose output
forge test -vvv

# Gas report
forge test --gas-report

# Format code
forge fmt
```

### Frontend

```bash
# Start development server
cd frontend && npm run dev

# Build for production
npm run build

# Run linting
npm run lint
```

### Combined Development

```bash
# Start both backend and frontend
npm run dev
```

## Testing

Comprehensive test suite includes:
- Deposit/withdrawal functionality
- Borrowing mechanisms
- Interest accrual
- Health factor calculations
- Liquidation logic
- Edge cases and error scenarios

Run all tests:
```bash
npm run test
```

## Deployment

### Local Testing (Anvil)

```bash
# Start local blockchain
anvil

# In another terminal, deploy to local network
forge script script/Deploy.s.sol --rpc-url http://localhost:8545 --broadcast
```

### Testnet Deployment (Sepolia)

```bash
forge script script/Deploy.s.sol --rpc-url $SEPOLIA_RPC_URL --broadcast
```

### Mainnet Deployment

```bash
forge script script/Deploy.s.sol --rpc-url $MAINNET_RPC_URL --broadcast
```

## How It Works

1. **Deposit**: Users deposit ERC20 tokens as collateral
2. **Borrow**: Users can borrow up to 66.67% of collateral value (150% ratio)
3. **Interest**: Borrowed amounts accrue interest at configurable rates
4. **Repay**: Users repay borrowed amount plus interest
5. **Liquidate**: If health factor drops below 1, liquidators can liquidate the position and earn 10% bonus

## Security

- ReentrancyGuard for reentrancy protection
- Input validation on all functions
- Overflow/underflow protection (Solidity 0.8.19+)
- Health factor enforcement
- Event logging for all state changes

## License

MIT License - see LICENSE file for details

## Support

For issues and questions, please open a GitHub issue.
