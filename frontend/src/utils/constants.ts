export const LENDING_ADDRESS = import.meta.env.REACT_APP_LENDING_ADDRESS || '0x'
export const USDC_ADDRESS = import.meta.env.REACT_APP_USDC_ADDRESS || '0x'
export const WETH_ADDRESS = import.meta.env.REACT_APP_WETH_ADDRESS || '0x'
export const CHAIN_ID = Number(import.meta.env.REACT_APP_CHAIN_ID || 11155111)

export const CHAIN_NAMES: Record<number, string> = {
  1: 'Ethereum Mainnet',
  11155111: 'Sepolia Testnet',
  31337: 'Local (Anvil)',
}

export const RPC_URLS: Record<number, string> = {
  1: 'https://eth.llamarpc.com',
  11155111: 'https://rpc.sepolia.org',
  31337: 'http://localhost:8545',
}
