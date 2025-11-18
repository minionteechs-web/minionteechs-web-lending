# Deployment Configuration

This file documents all environment variables needed for deployment.

## Local Development

Create `.env` file in project root:

```env
# Local Anvil (optional)
# Generated automatically by: anvil
# Default private key (DO NOT USE IN PRODUCTION)
PRIVATE_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb476c6b8d6c1f02960247590ce8e

# Local RPC
RPC_URL=http://127.0.0.1:8545
```

## Testnet Deployment (Sepolia)

Create `.env` file:

```env
# Your testnet private key
# Get from: MetaMask → Account Details → Export Private Key
# NEVER commit this to git!
PRIVATE_KEY=your_sepolia_private_key_here

# RPC URLs - Choose one provider:
SEPOLIA_RPC_URL=https://sepolia.infura.io/v3/YOUR_INFURA_KEY
# OR
SEPOLIA_RPC_URL=https://eth-sepolia.g.alchemy.com/v2/YOUR_ALCHEMY_KEY
# OR
SEPOLIA_RPC_URL=https://sepolia-rpc.publicnode.com

# Etherscan API Key for contract verification
# Get from: https://etherscan.io/apis
ETHERSCAN_API_KEY=your_etherscan_api_key_here
```

## Mainnet Deployment (Production)

Create `.env` file:

```env
# Your mainnet private key (use hardware wallet)
PRIVATE_KEY=your_mainnet_private_key_here

# RPC URLs - Use reliable providers:
MAINNET_RPC_URL=https://eth.llamarpc.com
# OR
MAINNET_RPC_URL=https://mainnet.infura.io/v3/YOUR_INFURA_KEY

# Etherscan API Key
ETHERSCAN_API_KEY=your_etherscan_api_key_here
```

## Frontend Configuration

Create `frontend/.env.local`:

```env
# After deploying contract, add address here
REACT_APP_LENDING_ADDRESS=0x...deployed_contract_address...

# Token addresses on your network
REACT_APP_USDC_ADDRESS=0x...usdc_address...
REACT_APP_WETH_ADDRESS=0x...weth_address...

# Chain ID: 1 (mainnet), 11155111 (sepolia), 31337 (local)
REACT_APP_CHAIN_ID=11155111
```

## Getting Required Keys

### Private Key
1. Open MetaMask
2. Click account menu → Settings → Security & Privacy
3. Click "Reveal Secret Recovery Phrase" (or "Export Private Key")
4. Copy your private key

⚠️ **NEVER share or commit your private key!**

### Infura API Key
1. Go to https://infura.io
2. Sign up/login
3. Create new project
4. Copy the API key

### Alchemy API Key
1. Go to https://alchemy.com
2. Sign up/login
3. Create new app
4. Copy the API key

### Etherscan API Key
1. Go to https://etherscan.io/apis
2. Sign up/login
3. Create new API key
4. Copy the key

## Security Best Practices

### ✅ DO:
- ✅ Use environment variables for secrets
- ✅ Create separate keys for each environment
- ✅ Use hardware wallet for mainnet
- ✅ Rotate keys regularly
- ✅ Use limited-permission keys
- ✅ Add .env to .gitignore (already done)

### ❌ DON'T:
- ❌ Commit .env file to git
- ❌ Share private keys via email/chat
- ❌ Use same key for testnet and mainnet
- ❌ Log private keys to console
- ❌ Use private keys in frontend code
- ❌ Share API keys publicly

## Environment Variable Reference

| Variable | Where | Purpose | Required |
|----------|-------|---------|----------|
| `PRIVATE_KEY` | `.env` | Sign transactions | Yes (except local dev) |
| `SEPOLIA_RPC_URL` | `.env` | Connect to Sepolia | Yes (testnet deploy) |
| `MAINNET_RPC_URL` | `.env` | Connect to Mainnet | Yes (mainnet deploy) |
| `ETHERSCAN_API_KEY` | `.env` | Verify contracts | No (but recommended) |
| `REACT_APP_LENDING_ADDRESS` | `frontend/.env.local` | Contract address | Yes (frontend) |
| `REACT_APP_USDC_ADDRESS` | `frontend/.env.local` | USDC token | Yes (frontend) |
| `REACT_APP_WETH_ADDRESS` | `frontend/.env.local` | WETH token | Yes (frontend) |
| `REACT_APP_CHAIN_ID` | `frontend/.env.local` | Network chain ID | Yes (frontend) |

## Using Environment Variables

### In Foundry Scripts
```solidity
uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
```

### In Frontend (React)
```tsx
const contractAddress = import.meta.env.REACT_APP_LENDING_ADDRESS
```

### In Shell Commands
```bash
export PRIVATE_KEY=your_key
forge script script/Deploy.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast
```

## Common Issues

### "Private key not found"
- Ensure .env file exists
- Check PRIVATE_KEY is set
- Verify format (no 0x prefix needed in .env)

### "Invalid RPC response"
- Check RPC URL is correct
- Verify network is up
- Try different provider

### "Insufficient funds"
- Add funds to wallet
- Use testnet faucet for Sepolia
- Check balance: `cast balance 0x...`

### Contract verification fails
- Ensure Etherscan API key is valid
- Match compiler version exactly
- Include constructor args if present

## Verification Commands

### Check balance
```bash
cast balance 0xYourAddress --rpc-url $SEPOLIA_RPC_URL
```

### Get RPC status
```bash
curl -X POST $SEPOLIA_RPC_URL \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'
```

### Verify contract on Etherscan
```bash
forge verify-contract <ADDRESS> WebLending \
  --constructor-args "" \
  --chain sepolia \
  --etherscan-api-key $ETHERSCAN_API_KEY
```

## Testing Configuration

For local testing without real keys:

```bash
# Use Anvil's default account
anvil

# In another terminal
export PRIVATE_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb476c6b8d6c1f02960247590ce8e
forge script script/Deploy.s.sol --rpc-url http://127.0.0.1:8545 --broadcast
```

---

**Remember:** Never commit secrets to git. Always use .env files for local configuration.
