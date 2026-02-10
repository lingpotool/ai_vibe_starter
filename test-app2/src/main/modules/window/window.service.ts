import { BrowserWindow, shell } from 'electron'
import { join } from 'path'
import { is } from '@electron-toolkit/utils'

let mainWindow: BrowserWindow | null = null

export function getMainWindow(): BrowserWindow | null {
  return mainWindow
}

export function createWindow(): BrowserWindow {
  const isMac = process.platform === 'darwin'

  const windowOptions: Electron.BrowserWindowConstructorOptions = {
    width: 1200,
    height: 800,
    minWidth: 900,
    minHeight: 600,
    show: false,
    webPreferences: {
      preload: join(__dirname, '../preload/index.js'),
      sandbox: false,
    },
  }

  if (isMac) {
    windowOptions.titleBarStyle = 'hiddenInset'
    windowOptions.trafficLightPosition = { x: 14, y: 18 }
    windowOptions.vibrancy = 'sidebar'
    windowOptions.visualEffectState = 'active'
    windowOptions.transparent = true
    windowOptions.backgroundColor = '#00000000'
  } else {
    // Windows: 使用系统原生 titleBarOverlay
    // 系统绘制最小化/最大化/关闭按钮，不需要自己画
    windowOptions.titleBarStyle = 'hidden'
    windowOptions.titleBarOverlay = {
      color: '#00000000',     // 透明背景
      symbolColor: '#555555', // 亮色模式默认，暗色模式由渲染进程动态更新
      height: 48,             // 与 titlebar 高度一致
    }
    // Windows 11: 启用系统级 Mica 材质模糊
    windowOptions.backgroundMaterial = 'mica'
  }

  mainWindow = new BrowserWindow(windowOptions)

  mainWindow.on('ready-to-show', () => {
    mainWindow?.show()
    // 开发模式自动打开 DevTools
    if (is.dev) {
      mainWindow?.webContents.openDevTools({ mode: 'detach' })
    }
  })

  mainWindow.webContents.setWindowOpenHandler((details) => {
    shell.openExternal(details.url)
    return { action: 'deny' }
  })

  // 通知渲染进程窗口最大化状态变化
  mainWindow.on('maximize', () => {
    mainWindow?.webContents.send('window:onMaximizeChange', true)
  })
  mainWindow.on('unmaximize', () => {
    mainWindow?.webContents.send('window:onMaximizeChange', false)
  })

  if (is.dev && process.env['ELECTRON_RENDERER_URL']) {
    mainWindow.loadURL(process.env['ELECTRON_RENDERER_URL'])
  } else {
    mainWindow.loadFile(join(__dirname, '../renderer/index.html'))
  }

  return mainWindow
}
