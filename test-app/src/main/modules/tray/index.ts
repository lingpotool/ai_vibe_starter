import { createTray } from './tray.service'
import { getMainWindow } from '../window/window.service'

export function register(): void {
  // 托盘不需要 IPC handlers
}

export function init(): void {
  const win = getMainWindow()
  if (win) createTray(win)
}
