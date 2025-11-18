import { useEffect, useState } from 'react'
import { ethers } from 'ethers'

export const useWeb3 = () => {
  const [provider, setProvider] = useState<ethers.BrowserProvider | null>(null)
  const [signer, setSigner] = useState<ethers.JsonRpcSigner | null>(null)
  const [account, setAccount] = useState<string | null>(null)
  const [chainId, setChainId] = useState<number | null>(null)
  const [isConnected, setIsConnected] = useState(false)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    const initWeb3 = async () => {
      if (!window.ethereum) {
        setError('MetaMask is not installed')
        return
      }

      try {
        const provider = new ethers.BrowserProvider(window.ethereum)
        setProvider(provider)

        const accounts = await provider.send('eth_requestAccounts', [])
        if (accounts.length > 0) {
          setAccount(accounts[0])
          setIsConnected(true)

          const signer = await provider.getSigner()
          setSigner(signer)

          const network = await provider.getNetwork()
          setChainId(Number(network.chainId))
        }
      } catch (err) {
        setError(err instanceof Error ? err.message : 'Failed to connect wallet')
      }
    }

    initWeb3()
  }, [])

  const connectWallet = async () => {
    if (!window.ethereum) {
      setError('MetaMask is not installed')
      return
    }

    try {
      const accounts = await window.ethereum.request({
        method: 'eth_requestAccounts',
      })

      if (accounts.length > 0) {
        setAccount(accounts[0])
        setIsConnected(true)
        setError(null)
      }
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to connect wallet')
    }
  }

  const disconnectWallet = () => {
    setAccount(null)
    setIsConnected(false)
    setSigner(null)
    setProvider(null)
  }

  return {
    provider,
    signer,
    account,
    chainId,
    isConnected,
    error,
    connectWallet,
    disconnectWallet,
  }
}
