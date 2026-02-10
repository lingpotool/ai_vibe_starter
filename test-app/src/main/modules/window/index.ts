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
}
