import { useEffect, useState } from 'react'
import { ethers } from 'ethers'

const LENDING_ABI = [
  'function deposit(address token, uint256 amount) external',
  'function withdraw(address token, uint256 amount) external',
  'function borrow(address collateralToken, address borrowToken, uint256 amount) external',
  'function repay(address token, uint256 amount) external',
  'function liquidate(address borrower, address collateralToken, address debtToken) external',
  'function getUserCollateral(address user, address token) external view returns (uint256)',
  'function getUserDebt(address user, address token) external view returns (uint256)',
  'function isHealthy(address user, address collateralToken, address debtToken) external view returns (bool)',
  'function getLiquidationPrice(address user, address collateralToken, address debtToken) external view returns (uint256)',
]

export const useLendingContract = (contractAddress: string | null, signer: ethers.JsonRpcSigner | null) => {
  const [contract, setContract] = useState<ethers.Contract | null>(null)

  useEffect(() => {
    if (contractAddress && signer) {
      const lendingContract = new ethers.Contract(contractAddress, LENDING_ABI, signer)
      setContract(lendingContract)
    }
  }, [contractAddress, signer])

  const deposit = async (tokenAddress: string, amount: string) => {
    if (!contract) throw new Error('Contract not initialized')

    const amountBn = ethers.parseEther(amount)
    const tx = await contract.deposit(tokenAddress, amountBn)
    return tx.wait()
  }

  const withdraw = async (tokenAddress: string, amount: string) => {
    if (!contract) throw new Error('Contract not initialized')

    const amountBn = ethers.parseEther(amount)
    const tx = await contract.withdraw(tokenAddress, amountBn)
    return tx.wait()
  }

  const borrow = async (collateralToken: string, borrowToken: string, amount: string) => {
    if (!contract) throw new Error('Contract not initialized')

    const amountBn = ethers.parseEther(amount)
    const tx = await contract.borrow(collateralToken, borrowToken, amountBn)
    return tx.wait()
  }

  const repay = async (tokenAddress: string, amount: string) => {
    if (!contract) throw new Error('Contract not initialized')

    const amountBn = ethers.parseEther(amount)
    const tx = await contract.repay(tokenAddress, amountBn)
    return tx.wait()
  }

  const getUserCollateral = async (userAddress: string, tokenAddress: string) => {
    if (!contract) throw new Error('Contract not initialized')
    const collateral = await contract.getUserCollateral(userAddress, tokenAddress)
    return ethers.formatEther(collateral)
  }

  const getUserDebt = async (userAddress: string, tokenAddress: string) => {
    if (!contract) throw new Error('Contract not initialized')
    const debt = await contract.getUserDebt(userAddress, tokenAddress)
    return ethers.formatEther(debt)
  }

  const isHealthy = async (userAddress: string, collateralToken: string, debtToken: string) => {
    if (!contract) throw new Error('Contract not initialized')
    return contract.isHealthy(userAddress, collateralToken, debtToken)
  }

  return {
    contract,
    deposit,
    withdraw,
    borrow,
    repay,
    getUserCollateral,
    getUserDebt,
    isHealthy,
  }
}
