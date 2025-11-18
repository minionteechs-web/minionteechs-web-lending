import { ReactNode } from 'react'

interface WalletConnectButtonProps {
  account: string | null
  isConnecting?: boolean
  onConnect: () => void
  onDisconnect: () => void
}

export function WalletConnectButton({
  account,
  isConnecting = false,
  onConnect,
  onDisconnect,
}: WalletConnectButtonProps) {
  const formatAddress = (addr: string) => `${addr.slice(0, 6)}...${addr.slice(-4)}`

  if (account) {
    return (
      <button
        onClick={onDisconnect}
        className="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors"
      >
        {formatAddress(account)}
      </button>
    )
  }

  return (
    <button
      onClick={onConnect}
      disabled={isConnecting}
      className="px-4 py-2 bg-accent text-white rounded-lg hover:bg-blue-600 disabled:opacity-50 transition-colors"
    >
      {isConnecting ? 'Connecting...' : 'Connect Wallet'}
    </button>
  )
}

interface CardProps {
  children: ReactNode
  className?: string
}

export function Card({ children, className = '' }: CardProps) {
  return (
    <div className={`bg-secondary border border-slate-700 rounded-xl p-6 ${className}`}>
      {children}
    </div>
  )
}

interface InputProps extends React.InputHTMLAttributes<HTMLInputElement> {
  label?: string
}

export function Input({ label, className = '', ...props }: InputProps) {
  return (
    <div className="flex flex-col gap-2">
      {label && <label className="text-sm font-medium text-slate-300">{label}</label>}
      <input
        {...props}
        className={`bg-slate-800 border border-slate-600 rounded-lg px-3 py-2 text-white placeholder-slate-400 focus:outline-none focus:border-accent transition-colors ${className}`}
      />
    </div>
  )
}

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'secondary' | 'danger'
  loading?: boolean
}

export function Button({
  variant = 'primary',
  loading = false,
  children,
  disabled,
  ...props
}: ButtonProps) {
  const baseStyles = 'px-4 py-2 rounded-lg font-medium transition-colors disabled:opacity-50'
  const variants = {
    primary: 'bg-accent text-white hover:bg-blue-600',
    secondary: 'bg-slate-700 text-white hover:bg-slate-600',
    danger: 'bg-red-600 text-white hover:bg-red-700',
  }

  return (
    <button
      disabled={disabled || loading}
      {...props}
      className={`${baseStyles} ${variants[variant]}`}
    >
      {loading ? 'Loading...' : children}
    </button>
  )
}
