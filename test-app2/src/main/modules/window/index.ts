import { BrowserWindow } from 'electron'
import { IPC_CHANNELS } from '@shared/constants/ipc-channels'
import { registerHandler, registerListener } from '../../core/ipc-registry'

export function register(): void {
  const CH = IPC_CHANNELS.WINDOW

  registerListener(CH.MINIMIZE, (event) => {
    BrowserWindow.fromWebContents(event.sender)?.minimize()
  })

  registerListener(CH.MAXIMIZE, (event) => {
    const win = BrowserWindow.fromWebContents(event.sender)
    if (win?.isMaximized()) {
      win.unmaximize()
    } else {
      win?.maximize()
    }
  })

  registerListener(CH.CLOSE, (event) => {
    BrowserWindow.fromWebContents(event.sender)?.close()
  })

  registerHandler(CH.IS_MAXIMIZED, (event) => {
    return BrowserWindow.fromWebContents(event.sender)?.isMaximized() ?? false
  })

  // Windows: 动态更新 titleBarOverlay 颜色（暗色模式适配）
  registerHandler(CH.SET_TITLE_BAR_OVERLAY, (event, ...args) => {
    const win = BrowserWindow.fromWebContents(event.sender)
    if (win && process.platform === 'win32') {
      const options = args[0] as Electron.TitleBarOverlay
      win.setTitleBarOverlay(options)
    }
  })
}
