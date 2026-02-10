import { app, shell, clipboard, dialog, Notification, globalShortcut, BrowserWindow } from 'electron'
import type {
  OpenDialogOptions,
  OpenDialogResult,
  SaveDialogOptions,
  SaveDialogResult,
  MessageBoxOptions,
  MessageBoxResult,
  NotificationOptions,
} from '@shared/types/ipc.types'
import { logger } from '../../core/logger'

export function getVersion(): string {
  return app.getVersion()
}

export function getPlatform(): string {
  return process.platform
}

export async function openExternal(url: string): Promise<void> {
  await shell.openExternal(url)
}

export function showItemInFolder(path: string): void {
  shell.showItemInFolder(path)
}

export function readClipboard(): string {
  return clipboard.readText()
}

export function writeClipboard(text: string): void {
  clipboard.writeText(text)
}

export async function showOpenDialog(options: OpenDialogOptions): Promise<OpenDialogResult> {
  const win = BrowserWindow.getFocusedWindow()
  const result = win
    ? await dialog.showOpenDialog(win, options)
    : await dialog.showOpenDialog(options)
  return { canceled: result.canceled, filePaths: result.filePaths }
}

export async function showSaveDialog(options: SaveDialogOptions): Promise<SaveDialogResult> {
  const win = BrowserWindow.getFocusedWindow()
  const result = win
    ? await dialog.showSaveDialog(win, options)
    : await dialog.showSaveDialog(options)
  return { canceled: result.canceled, filePath: result.filePath }
}

export async function showMessageBox(options: MessageBoxOptions): Promise<MessageBoxResult> {
  const win = BrowserWindow.getFocusedWindow()
  const result = win
    ? await dialog.showMessageBox(win, options)
    : await dialog.showMessageBox(options)
  return { response: result.response }
}

export function showNotification(options: NotificationOptions): void {
  new Notification(options).show()
}

// 快捷键管理
const shortcutCallbacks = new Map<string, string>()

export function registerShortcut(accelerator: string, id: string): boolean {
  try {
    const success = globalShortcut.register(accelerator, () => {
      const win = BrowserWindow.getFocusedWindow()
      win?.webContents.send('system:shortcutTriggered', id)
    })
    if (success) shortcutCallbacks.set(id, accelerator)
    return success
  } catch (error) {
    logger.error('system', `Failed to register shortcut: ${accelerator}`, error)
    return false
  }
}

export function unregisterShortcut(id: string): void {
  const accelerator = shortcutCallbacks.get(id)
  if (accelerator) {
    globalShortcut.unregister(accelerator)
    shortcutCallbacks.delete(id)
  }
}
