/// <reference types="vite/client" />

declare module '*.vue' {
  import type { DefineComponent } from 'vue'
  const component: DefineComponent<{}, {}, any>
  export default component
}

interface Window {
  api: {
    window: {
      minimize: () => void
      maximize: () => void
      close: () => void
      isMaximized: () => Promise<boolean>
      onMaximizeChange: (callback: (maximized: boolean) => void) => void
    }
    storage: {
      get: <T = unknown>(key: string) => Promise<T>
      set: (key: string, value: unknown) => Promise<void>
      delete: (key: string) => Promise<void>
      has: (key: string) => Promise<boolean>
    }
    system: {
      getVersion: () => Promise<string>
      getPlatform: () => Promise<string>
      openExternal: (url: string) => Promise<void>
      showItemInFolder: (path: string) => Promise<void>
      readClipboard: () => Promise<string>
      writeClipboard: (text: string) => Promise<void>
      showOpenDialog: (options: Record<string, unknown>) => Promise<{ canceled: boolean; filePaths: string[] }>
      showSaveDialog: (options: Record<string, unknown>) => Promise<{ canceled: boolean; filePath?: string }>
      showMessageBox: (options: Record<string, unknown>) => Promise<{ response: number }>
      showNotification: (options: { title: string; body: string }) => Promise<void>
      registerShortcut: (accelerator: string, id: string) => Promise<boolean>
      unregisterShortcut: (id: string) => Promise<void>
    }
  }
}
