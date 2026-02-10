/**
 * IPC 类型定义 — 每个 channel 的请求参数和返回值类型
 * 主进程和渲染进程共享同一套类型，确保类型安全
 */

// ===== Dialog / Notification 辅助类型 =====

export interface OpenDialogOptions {
  title?: string
  defaultPath?: string
  filters?: { name: string; extensions: string[] }[]
  properties?: ('openFile' | 'openDirectory' | 'multiSelections')[]
}

export interface OpenDialogResult {
  canceled: boolean
  filePaths: string[]
}

export interface SaveDialogOptions {
  title?: string
  defaultPath?: string
  filters?: { name: string; extensions: string[] }[]
}

export interface SaveDialogResult {
  canceled: boolean
  filePath?: string
}

export interface MessageBoxOptions {
  type?: 'none' | 'info' | 'error' | 'question' | 'warning'
  title?: string
  message: string
  detail?: string
  buttons?: string[]
}

export interface MessageBoxResult {
  response: number
}

export interface NotificationOptions {
  title: string
  body: string
}

// ===== IPC Channel 类型映射 =====

export interface IpcChannelMap {
  // Window
  'window:minimize': { args: []; return: void }
  'window:maximize': { args: []; return: void }
  'window:close': { args: []; return: void }
  'window:isMaximized': { args: []; return: boolean }

  // Storage
  'storage:get': { args: [key: string]; return: unknown }
  'storage:set': { args: [key: string, value: unknown]; return: void }
  'storage:delete': { args: [key: string]; return: void }
  'storage:has': { args: [key: string]; return: boolean }

  // System
  'system:getVersion': { args: []; return: string }
  'system:getPlatform': { args: []; return: string }
  'system:openExternal': { args: [url: string]; return: void }
  'system:showItemInFolder': { args: [path: string]; return: void }
  'system:readClipboard': { args: []; return: string }
  'system:writeClipboard': { args: [text: string]; return: void }
  'system:showOpenDialog': { args: [options: OpenDialogOptions]; return: OpenDialogResult }
  'system:showSaveDialog': { args: [options: SaveDialogOptions]; return: SaveDialogResult }
  'system:showMessageBox': { args: [options: MessageBoxOptions]; return: MessageBoxResult }
  'system:showNotification': { args: [options: NotificationOptions]; return: void }
  'system:registerShortcut': { args: [accelerator: string, id: string]; return: boolean }
  'system:unregisterShortcut': { args: [id: string]; return: void }
}

// ===== 辅助类型 =====

export type IpcChannel = keyof IpcChannelMap
