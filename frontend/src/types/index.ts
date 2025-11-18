export interface User {
  address: string
  collateral: Record<string, string>
  debt: Record<string, string>
  isHealthy: boolean
}

export interface Token {
  address: string
  symbol: string
  decimals: number
  balance: string
}

export interface Position {
  collateralToken: string
  borrowToken: string
  collateralAmount: string
  debtAmount: string
  healthFactor: number
  isHealthy: boolean
}

export interface Transaction {
  hash: string
  from: string
  to: string
  value: string
  status: 'pending' | 'success' | 'failed'
  timestamp: number
}
