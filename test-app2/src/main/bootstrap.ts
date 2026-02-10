import { app, BrowserWindow } from 'electron'
import { electronApp, optimizer } from '@electron-toolkit/utils'
import { logger } from './core/logger'
import { initErrorHandler } from './core/error-handler'
import { initIpcRegistry } from './core/ipc-registry'
import { createWindow } from './modules/window/window.service'
import { init as initStorage } from './modules/storage'
import { init as initTray } from './modules/tray'

export async function bootstrap(): Promise<void> {
  // 1. 核心基础设施
  logger.info('bootstrap', 'Starting application...')
  initErrorHandler()

  // 2. Electron 工具
  electronApp.setAppUserModelId('com.app')
  app.on('browser-window-created', (_, window) => {
    optimizer.watchWindowShortcuts(window)
  })

  // 3. IPC 注册（所有 module 的 handlers）
  initIpcRegistry()

  // 4. 模块初始化
  initStorage()

  // 5. 创建主窗口
  createWindow()

  // 6. 托盘（需要窗口创建后）
  initTray()

  // 7. macOS activate
  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) {
      createWindow()
    }
  })

  logger.info('bootstrap', 'Application started successfully')
}
