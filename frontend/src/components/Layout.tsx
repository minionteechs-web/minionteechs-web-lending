import { useWeb3 } from '@hooks/useWeb3'
import { WalletConnectButton, Card } from '@components/UI'

export function Header() {
  const { account, isConnected, connectWallet, disconnectWallet } = useWeb3()

  return (
    <header className="border-b border-slate-700 bg-primary">
      <div className="max-w-7xl mx-auto px-4 py-4 flex justify-between items-center">
        <div>
          <h1 className="text-3xl font-bold text-white">MinionTechs Lending</h1>
          <p className="text-slate-400 text-sm">Decentralized Lending Protocol</p>
        </div>
        <WalletConnectButton
          account={account}
          onConnect={connectWallet}
          onDisconnect={disconnectWallet}
        />
      </div>
    </header>
  )
}

export function Dashboard() {
  const { account, isConnected } = useWeb3()

  if (!isConnected) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <Card>
          <p className="text-xl text-white mb-4">Please connect your wallet to continue</p>
          <WalletConnectButton account={null} onConnect={() => {}} onDisconnect={() => {}} />
        </Card>
      </div>
    )
  }

  return (
    <div className="max-w-7xl mx-auto px-4 py-8">
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <Card>
          <h2 className="text-lg font-semibold text-white mb-4">Total Collateral</h2>
          <p className="text-3xl font-bold text-accent">$0.00</p>
        </Card>

        <Card>
          <h2 className="text-lg font-semibold text-white mb-4">Total Borrowed</h2>
          <p className="text-3xl font-bold text-red-400">$0.00</p>
        </Card>

        <Card>
          <h2 className="text-lg font-semibold text-white mb-4">Health Factor</h2>
          <p className="text-3xl font-bold text-green-400">0.00</p>
        </Card>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mt-8">
        <Card>
          <h2 className="text-lg font-semibold text-white mb-4">Deposit Collateral</h2>
          <p className="text-slate-400">Coming soon...</p>
        </Card>

        <Card>
          <h2 className="text-lg font-semibold text-white mb-4">Borrow</h2>
          <p className="text-slate-400">Coming soon...</p>
        </Card>
      </div>
    </div>
  )
}
