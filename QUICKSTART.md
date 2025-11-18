# Quick Start Guide

Get started with MinionTechs Web Lending in 5 minutes.

## 1. Clone & Setup

```bash
git clone https://github.com/yourusername/minionteechs-web-lending.git
cd minionteechs-web-lending
```

## 2. Backend Setup

```bash
# Install Foundry first if you haven't:
# https://book.getfoundry.sh/getting-started/installation

# Install dependencies
forge install

# Run tests
forge test

# Or with verbose output
forge test -vvv
```

## 3. Frontend Setup

```bash
cd frontend
npm install
npm run dev
```

Opens at: `http://localhost:3000`

## 4. Local Testing (Optional)

Terminal 1 - Start local blockchain:
```bash
anvil
```

Terminal 2 - Deploy contract:
```bash
forge script script/Deploy.s.sol --rpc-url http://localhost:8545 --broadcast
```

Copy the deployed address to frontend `.env.local`

## 5. Environment Variables

Create `frontend/.env.local`:
```env
REACT_APP_LENDING_ADDRESS=0x...
REACT_APP_USDC_ADDRESS=0x...
REACT_APP_WETH_ADDRESS=0x...
REACT_APP_CHAIN_ID=11155111
```

## Available Commands

### Backend
```bash
forge test              # Run all tests
forge test -vvv        # Verbose output
forge build            # Compile contracts
forge fmt              # Format code
forge script <path>    # Run deployment script
```

### Frontend
```bash
npm run dev            # Start dev server
npm run build          # Build for production
npm run preview        # Preview production build
npm run lint           # Type checking
```

## Project Structure

```
minionteechs-web-lending/
├── src/                    # Smart contracts
│   └── Lending.sol
├── test/                   # Contract tests
│   └── Lending.t.sol
├── script/                 # Deployment scripts
│   └── Deploy.s.sol
├── frontend/               # React app
│   ├── src/
│   ├── package.json
│   └── vite.config.ts
├── foundry.toml           # Foundry config
└── README.md              # Full documentation
```

## Key Features

✅ Deposit collateral  
✅ Borrow against collateral  
✅ Automatic interest accrual  
✅ Liquidation mechanism  
✅ MetaMask integration  
✅ Real-time position tracking  

## Testing

```bash
# Run all tests
forge test

# Run specific test
forge test --match-test test_Deposit_Success

# Gas analysis
forge test --gas-report

# Coverage
forge coverage
```

## Deployment Checklist

- [ ] Tests pass: `forge test`
- [ ] Contract compiles: `forge build`
- [ ] Frontend builds: `cd frontend && npm run build`
- [ ] Environment variables set
- [ ] Private key available
- [ ] RPC URL configured
- [ ] Sufficient testnet funds
- [ ] Ready for deployment!

## Next Steps

1. **Read**: [README.md](./README.md) - Full documentation
2. **Develop**: [DEVELOPMENT.md](./DEVELOPMENT.md) - Development guide
3. **Contribute**: [CONTRIBUTING.md](./CONTRIBUTING.md) - Contribution guidelines
4. **Security**: [SECURITY.md](./SECURITY.md) - Security policy

## Support

- GitHub Issues: Report bugs
- Discussions: Ask questions
- Security: See SECURITY.md

## Resources

- [Foundry Book](https://book.getfoundry.sh/)
- [Solidity Docs](https://docs.soliditylang.org/)
- [React Docs](https://react.dev/)
- [ethers.js](https://docs.ethers.org/v6/)

---

**Ready to go?** Start with `forge test` to verify everything works!
