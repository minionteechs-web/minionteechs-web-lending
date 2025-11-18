import './App.css'

export default function App() {
  return (
    <div className="bg-primary min-h-screen text-white">
      <header className="border-b border-slate-700 bg-primary">
        <div className="max-w-7xl mx-auto px-4 py-4">
          <h1 className="text-3xl font-bold text-white">MinionTechs Lending</h1>
          <p className="text-slate-400 text-sm">Decentralized Lending Protocol</p>
        </div>
      </header>
      
      <div className="max-w-7xl mx-auto px-4 py-8">
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          <div className="bg-secondary border border-slate-700 rounded-xl p-6">
            <h2 className="text-lg font-semibold text-white mb-4">Total Collateral</h2>
            <p className="text-3xl font-bold text-accent">$0.00</p>
          </div>

          <div className="bg-secondary border border-slate-700 rounded-xl p-6">
            <h2 className="text-lg font-semibold text-white mb-4">Total Borrowed</h2>
            <p className="text-3xl font-bold text-red-400">$0.00</p>
          </div>

          <div className="bg-secondary border border-slate-700 rounded-xl p-6">
            <h2 className="text-lg font-semibold text-white mb-4">Health Factor</h2>
            <p className="text-3xl font-bold text-green-400">0.00</p>
          </div>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mt-8">
          <div className="bg-secondary border border-slate-700 rounded-xl p-6">
            <h2 className="text-lg font-semibold text-white mb-4">Deposit Collateral</h2>
            <p className="text-slate-400">Coming soon...</p>
          </div>

          <div className="bg-secondary border border-slate-700 rounded-xl p-6">
            <h2 className="text-lg font-semibold text-white mb-4">Borrow</h2>
            <p className="text-slate-400">Coming soon...</p>
          </div>
        </div>
      </div>
    </div>
  )
}
