/**
 * IPC Client — 封装 window.api 调用，统一错误处理
 * Composables 通过此模块或直接通过 window.api 调用主进程
 */

export const ipcClient = {
  window: {
    minimize: () => window.api.window.minimize(),
    maximize: () => window.api.window.maximize(),
    close: () => window.api.window.close(),
    isMaximized: () => window.api.window.isMaximized(),
    onMaximizeChange: (cb: (maximized: boolean) => void) => window.api.window.onMaximizeChange(cb),
  },

  storage: {
    get: <T = unknown>(key: string) => window.api.storage.get<T>(key),
    set: (key: string, value: unknown) => window.api.storage.set(key, value),
    delete: (key: string) => window.api.storage.delete(key),
    has: (key: string) => window.api.storage.has(key),
  },

  system: {
    getVersion: () => window.api.system.getVersion(),
    getPlatform: () => window.api.system.getPlatform(),
    openExternal: (url: string) => window.api.system.openExternal(url),
    showItemInFolder: (path: string) => window.api.system.showItemInFolder(path),
    readClipboard: () => window.api.system.readClipboard(),
    writeClipboard: (text: string) => window.api.system.writeClipboard(text),
    showOpenDialog: (options: Record<string, unknown> = {}) => window.api.system.showOpenDialog(options),
    showSaveDialog: (options: Record<string, unknown> = {}) => window.api.system.showSaveDialog(options),
    showMessageBox: (options: Record<string, unknown>) => window.api.system.showMessageBox(options),
    showNotification: (options: { title: string; body: string }) => window.api.system.showNotification(options),
    registerShortcut: (accelerator: string, id: string) => window.api.system.registerShortcut(accelerator, id),
    unregisterShortcut: (id: string) => window.api.system.unregisterShortcut(id),
  },
}
