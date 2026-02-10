import { contextBridge, ipcRenderer } from 'electron'
import { IPC_CHANNELS } from '@shared/constants/ipc-channels'

const CH = IPC_CHANNELS

/**
 * 类型安全的 API 桥接
 * 按模块分组，不暴露通用 invoke/send
 */
const api = {
  window: {
    minimize: () => ipcRenderer.send(CH.WINDOW.MINIMIZE),
    maximize: () => ipcRenderer.send(CH.WINDOW.MAXIMIZE),
    close: () => ipcRenderer.send(CH.WINDOW.CLOSE),
    isMaximized: (): Promise<boolean> => ipcRenderer.invoke(CH.WINDOW.IS_MAXIMIZED),
    onMaximizeChange: (callback: (maximized: boolean) => void) => {
      ipcRenderer.on(CH.WINDOW.ON_MAXIMIZE_CHANGE, (_event, maximized: boolean) => callback(maximized))
    },
  },

  storage: {
    get: <T = unknown>(key: string): Promise<T> => ipcRenderer.invoke(CH.STORAGE.GET, key),
    set: (key: string, value: unknown): Promise<void> => ipcRenderer.invoke(CH.STORAGE.SET, key, value),
    delete: (key: string): Promise<void> => ipcRenderer.invoke(CH.STORAGE.DELETE, key),
    has: (key: string): Promise<boolean> => ipcRenderer.invoke(CH.STORAGE.HAS, key),
  },

  system: {
    getVersion: (): Promise<string> => ipcRenderer.invoke(CH.SYSTEM.GET_VERSION),
    getPlatform: (): Promise<string> => ipcRenderer.invoke(CH.SYSTEM.GET_PLATFORM),
    openExternal: (url: string): Promise<void> => ipcRenderer.invoke(CH.SYSTEM.OPEN_EXTERNAL, url),
    showItemInFolder: (path: string): Promise<void> => ipcRenderer.invoke(CH.SYSTEM.SHOW_ITEM_IN_FOLDER, path),
    readClipboard: (): Promise<string> => ipcRenderer.invoke(CH.SYSTEM.READ_CLIPBOARD),
    writeClipboard: (text: string): Promise<void> => ipcRenderer.invoke(CH.SYSTEM.WRITE_CLIPBOARD, text),
    showOpenDialog: (options: Record<string, unknown>): Promise<{ canceled: boolean; filePaths: string[] }> =>
      ipcRenderer.invoke(CH.SYSTEM.SHOW_OPEN_DIALOG, options),
    showSaveDialog: (options: Record<string, unknown>): Promise<{ canceled: boolean; filePath?: string }> =>
      ipcRenderer.invoke(CH.SYSTEM.SHOW_SAVE_DIALOG, options),
    showMessageBox: (options: Record<string, unknown>): Promise<{ response: number }> =>
      ipcRenderer.invoke(CH.SYSTEM.SHOW_MESSAGE_BOX, options),
    showNotification: (options: { title: string; body: string }): Promise<void> =>
      ipcRenderer.invoke(CH.SYSTEM.SHOW_NOTIFICATION, options),
    registerShortcut: (accelerator: string, id: string): Promise<boolean> =>
      ipcRenderer.invoke(CH.SYSTEM.REGISTER_SHORTCUT, accelerator, id),
    unregisterShortcut: (id: string): Promise<void> =>
      ipcRenderer.invoke(CH.SYSTEM.UNREGISTER_SHORTCUT, id),
  },
}

if (process.contextIsolated) {
  try {
    contextBridge.exposeInMainWorld('api', api)
  } catch (error) {
    console.error(error)
  }
} else {
  // @ts-ignore
  window.api = api
}
