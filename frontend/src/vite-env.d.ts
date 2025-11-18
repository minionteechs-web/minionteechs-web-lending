/// <reference types="vite/client" />

interface Window {
  ethereum?: {
    request: (args: { method: string; params?: Array<any> }) => Promise<any>
    on: (event: string, handler: (...args: Array<any>) => void) => void
    removeListener: (event: string, handler: (...args: Array<any>) => void) => void
  }
}
