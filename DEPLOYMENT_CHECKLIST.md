# Pre-Deployment Checklist

Complete this checklist before deploying to mainnet.

## Code Quality

### Smart Contracts
- [ ] Code compiles without warnings: `forge build`
- [ ] All tests pass: `forge test`
- [ ] Code is formatted: `forge fmt --check`
- [ ] No console logs in production code
- [ ] No hardcoded addresses (except constants)
- [ ] Comments explain complex logic
- [ ] NatSpec comments on all public functions
- [ ] No unused imports
- [ ] No debug code

### Frontend
- [ ] TypeScript strict mode enabled
- [ ] No `any` types except where necessary
- [ ] Code builds successfully: `npm run build`
- [ ] No console errors or warnings
- [ ] No sensitive data in code
- [ ] Environment variables properly configured
- [ ] Responsive design tested
- [ ] All links working
- [ ] Images optimized

## Security

### Smart Contract Security
- [ ] Read SECURITY.md
- [ ] Reentrancy protection in place (ReentrancyGuard)
- [ ] Input validation on all functions
- [ ] No arithmetic overflow/underflow risks
- [ ] Access control properly implemented
- [ ] No unnecessary functions
- [ ] Constants marked as `immutable` or `constant`
- [ ] Error messages clear and helpful
- [ ] Events emitted for all state changes

### Frontend Security
- [ ] No hardcoded private keys
- [ ] API keys in environment variables
- [ ] Input validation on forms
- [ ] XSS protection (React handles this)
- [ ] CSRF protection considered
- [ ] No localStorage for sensitive data
- [ ] HTTPS enforced in production

### Operational Security
- [ ] Private key management plan documented
- [ ] Multi-sig wallet considered for mainnet
- [ ] Emergency procedures documented
- [ ] Pause/circuit breaker considered
- [ ] Monitoring/alerting set up

## Testing

### Unit Tests
- [ ] All functions have tests
- [ ] Edge cases covered
- [ ] Error cases covered
- [ ] Boundary conditions tested
- [ ] Test coverage > 80%: `forge coverage`

### Integration Tests
- [ ] Multiple functions tested together
- [ ] State changes verified
- [ ] Events emitted correctly
- [ ] Error handling verified

### Manual Testing
- [ ] Tested on local blockchain (Anvil)
- [ ] Tested on testnet (Sepolia)
- [ ] Tested wallet connections
- [ ] Tested all UI interactions
- [ ] Tested error scenarios
- [ ] Tested with real transactions

## Documentation

### README & Guides
- [ ] README.md complete and accurate
- [ ] QUICKSTART.md tested and working
- [ ] DEVELOPMENT.md comprehensive
- [ ] CONTRIBUTING.md present
- [ ] SECURITY.md present
- [ ] DEPLOYMENT_CONFIG.md complete
- [ ] All links working
- [ ] Code examples accurate

### Code Documentation
- [ ] Complex functions commented
- [ ] NatSpec on contracts
- [ ] JSDoc on React components
- [ ] Inline comments where needed

## Configuration

### Environment
- [ ] .env.example filled with correct structure
- [ ] All required env vars documented
- [ ] Testnet RPC URLs valid
- [ ] Etherscan API key configured
- [ ] No secrets in repository

### Smart Contract
- [ ] foundry.toml configured correctly
- [ ] Compiler version specified (0.8.19)
- [ ] Gas optimizations considered
- [ ] Library versions pinned

### Frontend
- [ ] package.json dependencies resolved
- [ ] vite.config.ts correct
- [ ] tsconfig.json strict mode enabled
- [ ] Tailwind config complete
- [ ] Environment variables mapped

## Deployment

### Pre-Deployment
- [ ] Backup private key safely
- [ ] Testnet deployment successful
- [ ] Contract verified on Etherscan
- [ ] Gas estimates reviewed
- [ ] Transaction limits understood
- [ ] Rollback plan documented

### Smart Contract Deployment
- [ ] Deploy script tested on testnet
- [ ] Constructor arguments documented
- [ ] Initial state verified post-deployment
- [ ] Events working correctly
- [ ] View functions returning correct values

### Frontend Deployment
- [ ] Contract address updated in config
- [ ] Build tested locally: `npm run build`
- [ ] Preview tested: `npm run preview`
- [ ] All pages load
- [ ] MetaMask integration working
- [ ] Contract calls working

## Post-Deployment

### Verification
- [ ] Contract verified on Etherscan
- [ ] All functions callable
- [ ] Events being emitted
- [ ] Frontend connecting properly
- [ ] Wallet integration working
- [ ] Test transactions successful

### Monitoring
- [ ] Transaction logs monitored
- [ ] Error tracking enabled
- [ ] Performance metrics captured
- [ ] Alerts configured
- [ ] Escalation procedures documented

### Communication
- [ ] Team notified of deployment
- [ ] Documentation updated
- [ ] Support ready
- [ ] Known issues documented
- [ ] Incident response plan ready

## Compliance

### Legal
- [ ] License correct (MIT)
- [ ] No third-party IP violations
- [ ] Terms of Service considered
- [ ] Privacy considerations
- [ ] Regulatory compliance checked

### Standards
- [ ] Follows Solidity best practices
- [ ] Follows React best practices
- [ ] Code style consistent
- [ ] Naming conventions followed

## Final Checklist

### Before Mainnet
- [ ] All tests pass
- [ ] Code reviewed by team
- [ ] Security audit completed (recommended)
- [ ] Testnet deployment successful
- [ ] Documentation complete
- [ ] Emergency contacts documented
- [ ] Backup procedures tested
- [ ] Monitoring configured
- [ ] Support plan ready

### During Deployment
- [ ] Single responsibility per transaction
- [ ] Transactions monitored in real-time
- [ ] Wallet has sufficient funds
- [ ] Gas prices reasonable
- [ ] Network congestion checked

### After Deployment
- [ ] Verify contract deployed correctly
- [ ] Verify contract verified on Etherscan
- [ ] Verify frontend working
- [ ] Monitor for errors
- [ ] Document any issues
- [ ] Celebrate! 🎉

## Rollback Plan

- [ ] Backup of previous version available
- [ ] Rollback procedures documented
- [ ] Emergency contact list updated
- [ ] Communication template prepared

## Emergency Contacts

| Role | Name | Contact |
|------|------|---------|
| Lead Dev | | |
| DevOps | | |
| Security | | |
| Product | | |

## Sign-Off

- [ ] Lead Developer: _____________ Date: _______
- [ ] QA Lead: _____________ Date: _______
- [ ] Project Manager: _____________ Date: _______
- [ ] Security Lead: _____________ Date: _______

---

## Testing Commands

```bash
# Compile
forge build

# Run tests
forge test -vvv

# Gas report
forge test --gas-report

# Coverage
forge coverage

# Format check
forge fmt --check

# Frontend build
cd frontend
npm run build
npm run lint
```

## Deployment Commands

```bash
# Testnet
export PRIVATE_KEY=your_key
export SEPOLIA_RPC_URL=your_rpc
forge script script/Deploy.s.sol --rpc-url $SEPOLIA_RPC_URL --broadcast

# Mainnet (use with caution!)
export PRIVATE_KEY=your_key
export MAINNET_RPC_URL=your_rpc
forge script script/Deploy.s.sol --rpc-url $MAINNET_RPC_URL --broadcast
```

## Notes & Known Issues

```
Keep track of any issues found during deployment:

1. Issue: 
   Resolution:
   Date:

2. Issue:
   Resolution:
   Date:
```

---

**Remember:** 
- ✅ Test thoroughly on testnet first
- ✅ Never share private keys
- ✅ Monitor after deployment
- ✅ Have a rollback plan
- ✅ Document everything

**Good luck! 🚀**
