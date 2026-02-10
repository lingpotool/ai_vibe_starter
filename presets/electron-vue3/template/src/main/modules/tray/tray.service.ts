import { Tray, Menu, BrowserWindow, nativeImage } from 'electron'

let tray: Tray | null = null

export function createTray(mainWindow: BrowserWindow): void {
  const icon = nativeImage.createEmpty()
  tray = new Tray(icon)

  const contextMenu = Menu.buildFromTemplate([
    {
      label: '显示窗口',
      click: () => {
        mainWindow.show()
        mainWindow.focus()
      },
    },
    { type: 'separator' },
    {
      label: '退出',
      click: () => {
        mainWindow.destroy()
      },
    },
  ])

  tray.setToolTip('My Electron App')
  tray.setContextMenu(contextMenu)

  tray.on('double-click', () => {
    mainWindow.show()
    mainWindow.focus()
  })
}
