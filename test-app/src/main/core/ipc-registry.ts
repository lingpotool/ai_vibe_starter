import { ipcMain, type IpcMainInvokeEvent, type IpcMainEvent } from 'electron'
import { logger } from './logger'
import { register as registerWindow } from '../modules/window'
import { register as registerStorage } from '../modules/storage'
import { register as registerSystem } from '../modules/system'

/**
 * IPC Handler 注册中心
 * 所有 module 通过这里注册 handler，自动包装 try-catch
 */

/** 注册 invoke handler（有返回值） */
export function registerHandler(
  channel: string,
  handler: (event: IpcMainInvokeEvent, ...args: unknown[]) => unknown | Promise<unknown>
): void {
  ipcMain.handle(channel, async (event, ...args) => {
    try {
      return await handler(event, ...args)
    } catch (error) {
      logger.error('ipc', `Handler error on "${channel}"`, error)
      throw error
    }
  })
}

/** 注册 send/on listener（无返回值） */
export function registerListener(
  channel: string,
  handler: (event: IpcMainEvent, ...args: unknown[]) => void
): void {
  ipcMain.on(channel, (event, ...args) => {
    try {
      handler(event, ...args)
    } catch (error) {
      logger.error('ipc', `Listener error on "${channel}"`, error)
    }
  })
}

/** 初始化所有模块的 IPC handlers */
export function initIpcRegistry(): void {
  // 静态导入在文件顶部，这里直接调用
  registerWindow()
  registerStorage()
  registerSystem()

  logger.info('ipc-registry', 'All IPC handlers registered')
}
