# Development Guide

## Getting Started

This guide will help you set up the MinionTechs Web Lending Protocol for local development.

## Prerequisites

- Foundry: [Installation Guide](https://book.getfoundry.sh/getting-started/installation)
- Node.js 16+
- Git
- MetaMask browser extension

## Backend Development

### 1. Install Dependencies

```bash
forge install
```

This will install:
- OpenZeppelin Contracts library
- Forge Standard Library (forge-std)

### 2. Smart Contract Structure

```
src/
└── Lending.sol          # Main protocol contract
```

### 3. Development Workflow

#### Writing Tests

Add test functions to `test/Lending.t.sol`:

```solidity
function test_YourFeature() public {
    // Setup
    uint256 amount = 100 ether;
    
    // Execute
    vm.prank(alice);
    lending.deposit(address(usdc), amount);
    
    // Assert
    assertEq(lending.getUserCollateral(alice, address(usdc)), amount);
}
```

#### Running Tests

```bash
# Run all tests
forge test

# Run with verbose output
forge test -vvv

# Run specific test
forge test --match-test test_YourFeature

# Run with coverage
forge coverage
```

#### Debugging

```bash
# Run test with full trace
forge test -vvv --match-test test_YourFeature

# Use console.log in contracts
import "forge-std/console.sol";
console.log("Value:", amount);
```

### 4. Local Network Testing

```bash
# Terminal 1: Start Anvil (local Ethereum node)
anvil

# Terminal 2: Deploy contract
forge script script/Deploy.s.sol --rpc-url http://localhost:8545 --broadcast --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb476c6b8d6c1f02960247590ce8e

# Copy the deployed contract address and use in frontend
```

### 5. Testnet Deployment

```bash
# Set environment variables
export PRIVATE_KEY=your_private_key
export SEPOLIA_RPC_URL=your_rpc_url

# Deploy
forge script script/Deploy.s.sol --rpc-url $SEPOLIA_RPC_URL --broadcast --private-key $PRIVATE_KEY

# Verify on Etherscan (optional)
forge verify-contract <CONTRACT_ADDRESS> WebLending --constructor-args "" --chain sepolia
```

## Frontend Development

### 1. Install Dependencies

```bash
cd frontend
npm install
```

### 2. Environment Setup

Create `.env.local`:

```env
REACT_APP_LENDING_ADDRESS=0x...
REACT_APP_USDC_ADDRESS=0x...
REACT_APP_WETH_ADDRESS=0x...
REACT_APP_CHAIN_ID=11155111
```

### 3. Start Development Server

```bash
npm run dev
```

App will open at `http://localhost:3000`

### 4. Component Development

Create new component in `src/components/`:

```tsx
import { Card } from './UI'

export function MyComponent() {
  return (
    <Card>
      <h2 className="text-lg font-semibold text-white">My Component</h2>
      <p className="text-slate-400">Content here</p>
    </Card>
  )
}
```

### 5. Hook Development

Create new hook in `src/hooks/`:

```tsx
import { useState } from 'react'

export const useMyHook = () => {
  const [state, setState] = useState(null)
  
  return { state, setState }
}
```

### 6. Building for Production

```bash
npm run build
npm run preview  # Test production build locally
```

## Code Quality

### Solidity Code Standards

- Follow [Solidity Style Guide](https://docs.soliditylang.org/en/v0.8.19/style-guide.html)
- Run formatter: `forge fmt`
- Add comprehensive comments above functions

Example:
```solidity
/// @dev Deposits collateral for the caller
/// @param token The ERC20 token address
/// @param amount The amount to deposit
function deposit(address token, uint256 amount) external nonReentrant {
    // Implementation
}
```

### TypeScript/React Standards

- Use TypeScript strict mode
- Define interfaces for all props
- Use meaningful variable names
- Add JSDoc comments for complex functions

Example:
```tsx
interface Props {
  title: string
  onClose: () => void
}

/**
 * Modal component for displaying dialogs
 */
export function Modal({ title, onClose }: Props) {
  // Implementation
}
```

## Testing Best Practices

### Unit Tests

Test individual functions:

```solidity
function test_Deposit_IncreasesCollateral() public {
    uint256 before = lending.getUserCollateral(alice, address(usdc));
    
    vm.prank(alice);
    lending.deposit(address(usdc), 100 ether);
    
    uint256 after = lending.getUserCollateral(alice, address(usdc));
    assertEq(after - before, 100 ether);
}
```

### Integration Tests

Test multiple functions together:

```solidity
function test_DepositAndBorrow_WorkTogether() public {
    vm.startPrank(alice);
    usdc.approve(address(lending), 100 ether);
    lending.deposit(address(usdc), 100 ether);
    lending.borrow(address(usdc), address(weth), 50 ether);
    vm.stopPrank();
    
    assertTrue(lending.isHealthy(alice, address(usdc), address(weth)));
}
```

### Edge Cases

Always test boundaries:

```solidity
function test_Borrow_FailsAtBoundary() public {
    vm.startPrank(alice);
    usdc.approve(address(lending), 100 ether);
    lending.deposit(address(usdc), 100 ether);
    
    // Borrow maximum allowed
    vm.expectRevert();
    lending.borrow(address(usdc), address(weth), 67 ether); // 67 > 50
    vm.stopPrank();
}
```

## Debugging Tips

### Smart Contracts

```solidity
// Add console logs
import "forge-std/console.sol";
console.log("Address:", msg.sender);
console.log("Amount:", amount);

// Use forge test with verbose output
forge test -vvvv --match-test test_YourTest
```

### Frontend

```tsx
// Check component state
console.log('Account:', account);
console.log('Balance:', balance);

// Use React DevTools
// Download React DevTools browser extension

// Check Web3 connection
console.log('Provider:', provider);
console.log('Signer:', signer);
```

### Transaction Debugging

```bash
# Check transaction details
cast call <ADDRESS> "<FUNCTION_SIGNATURE>"

# Estimate gas
cast estimate <ADDRESS> "<FUNCTION_SIGNATURE>"

# Send transaction
cast send --private-key <KEY> <ADDRESS> "<FUNCTION_SIGNATURE>"
```

## Performance Optimization

### Gas Optimization

- Use `immutable` for constants set in constructor
- Use `constant` for true constants
- Minimize storage writes
- Use bit shifting instead of multiplication/division by powers of 2

### Frontend Optimization

- Lazy load components
- Memoize expensive computations
- Use React.memo for pure components
- Code split with React.lazy

## Continuous Integration

The project includes GitHub Actions workflows:

- **Smart Contract Tests** (`.github/workflows/test.yml`)
  - Runs Foundry tests on every push to main/develop
  - Checks code formatting
  - Generates gas reports

- **Frontend CI** (`.github/workflows/frontend.yml`)
  - TypeScript type checking
  - Build verification
  - Code quality checks

## Troubleshooting

### "Module not found" errors

```bash
# Reinstall dependencies
forge install --force

# Or in frontend
rm -rf node_modules package-lock.json
npm install
```

### Gas limit exceeded

- Reduce test data size
- Use Anvil instead of public testnet for large-scale testing
- Check for infinite loops in contracts

### Wallet connection issues

- Ensure MetaMask is connected to correct network
- Check RPC URL in .env.local
- Clear MetaMask cache and reconnect

### Contract verification issues

- Ensure constructor args match deployment
- Use exact compiler version
- Check Etherscan supports the chain

## Resources

- [Foundry Book](https://book.getfoundry.sh/)
- [Solidity Docs](https://docs.soliditylang.org/)
- [OpenZeppelin Contracts](https://docs.openzeppelin.com/contracts/)
- [React Documentation](https://react.dev/)
- [ethers.js Documentation](https://docs.ethers.org/v6/)
- [Tailwind CSS](https://tailwindcss.com/)

## Getting Help

1. Check existing GitHub issues
2. Review test files for examples
3. Check deployment logs for error messages
4. Open a new GitHub issue with details

---

Happy coding! 🚀
