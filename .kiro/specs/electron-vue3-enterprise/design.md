# Electron + Vue3 企业级预设架构 — 设计文档

## 架构总览

```
src/
├── shared/                          # 跨进程共享层（类型 + 常量）
│   ├── types/
│   │   └── ipc.types.ts             # IPC channel 请求/响应类型
│   └── constants/
│       └── ipc-channels.ts          # IPC channel 名称常量
├── main/                            # Electron 主进程
│   ├── index.ts                     # 入口（仅调用 bootstrap）
│   ├── bootstrap.ts                 # 启动编排
│   ├── core/                        # 核心基础设施
│   │   ├── ipc-registry.ts          # IPC handler 注册中心
│   │   ├── logger.ts                # 日志服务
│   │   ├── error-handler.ts         # 全局错误处理
│   │   └── event-bus.ts             # 主进程事件总线
│   └── modules/                     # 业务模块
│       ├── window/
│       │   ├── index.ts             # 模块入口（register + init）
│       │   └── window.service.ts    # 窗口管理逻辑
│       ├── storage/
│       │   ├── index.ts
│       │   └── storage.service.ts   # electron-store 持久化
│       ├── system/
│       │   ├── index.ts
│       │   └── system.service.ts    # 平台/版本/shell/clipboard/dialog/notification
│       └── tray/
│           ├── index.ts
│           └── tray.service.ts      # 系统托盘
├── preload/
│   └── index.ts                     # 类型安全的 API 桥接
└── renderer/                        # Vue 渲染进程
    ├── App.vue
    ├── main.ts                      # 入口
    ├── env.d.ts                     # window.api 类型声明
    ├── config/
    │   └── app.ts                   # 应用配置（项目名在这里改）
    ├── core/                        # 渲染进程核心
    │   ├── ipc-client.ts            # IPC 调用封装
    │   ├── error-handler.ts         # Vue 全局错误处理
    │   └── event-bus.ts             # 渲染进程事件总线
    ├── composables/                 # Vue Composables
    │   ├── useTheme.ts
    │   ├── usePlatform.ts
    │   ├── useStorage.ts
    │   ├── useClipboard.ts
    │   ├── useShell.ts
    │   ├── useKeyboard.ts
    │   ├── useDialog.ts
    │   └── useNotification.ts
    ├── components/
    │   ├── ui/                      # 自建 UI 组件（Tailwind）
    │   │   ├── GlassCard.vue
    │   │   ├── PageHeader.vue
    │   │   ├── StatCard.vue
    │   │   ├── EmptyState.vue
    │   │   ├── LoadingOverlay.vue
    │   │   └── SettingsPanel.vue
    │   └── layout/                  # 自建布局组件（Tailwind）
    │       ├── AppLayout.vue
    │       ├── TitleBar.vue
    │       ├── Sidebar.vue
    │       ├── Topbar.vue
    │       ├── Breadcrumb.vue
    │       └── TabsBar.vue
    ├── assets/styles/
    │   ├── index.css                # 全局样式
    │   ├── theme.css                # 主题变量
    │   └── element-override.css     # Element Plus 样式覆盖
    ├── i18n/                        # 国际化（保留）
    ├── router/                      # 路由（保留）
    ├── stores/                      # Pinia（保留）
    └── views/                       # 页面（保留）
```

## 1. 共享层设计（src/shared/）

### 1.1 IPC Channel 常量

`src/shared/constants/ipc-channels.ts`:

```typescript
// 按模块分组的 channel 常量
// 命名规则：MODULE:ACTION
export const IPC_CHANNELS = {
  WINDOW: {
    MINIMIZE: 'window:minimize',
    MAXIMIZE: 'window:maximize',
    CLOSE: 'window:close',
    IS_MAXIMIZED: 'window:isMaximized',
    ON_MAXIMIZE_CHANGE: 'window:onMaximizeChange',
  },
  STORAGE: {
    GET: 'storage:get',
    SET: 'storage:set',
    DELETE: 'storage:delete',
    HAS: 'storage:has',
  },
  SYSTEM: {
    GET_VERSION: 'system:getVersion',
    GET_PLATFORM: 'system:getPlatform',
    OPEN_EXTERNAL: 'system:openExternal',
    SHOW_ITEM_IN_FOLDER: 'system:showItemInFolder',
    READ_CLIPBOARD: 'system:readClipboard',
    WRITE_CLIPBOARD: 'system:writeClipboard',
    SHOW_OPEN_DIALOG: 'system:showOpenDialog',
    SHOW_SAVE_DIALOG: 'system:showSaveDialog',
    SHOW_MESSAGE_BOX: 'system:showMessageBox',
    SHOW_NOTIFICATION: 'system:showNotification',
    REGISTER_SHORTCUT: 'system:registerShortcut',
    UNREGISTER_SHORTCUT: 'system:unregisterShortcut',
  },
} as const
```

### 1.2 IPC 类型定义

`src/shared/types/ipc.types.ts`:

```typescript
// 每个 channel 的请求参数和返回值类型
// 使用 mapped type 确保类型安全

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
  'system:getPlatform': { args: []; return: NodeJS.Platform }
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

// 辅助类型
export type IpcChannel = keyof IpcChannelMap
export type IpcInvokeChannel = { [K in IpcChannel]: IpcChannelMap[K]['return'] extends void ? never : K }[IpcChannel]
export type IpcSendChannel = { [K in IpcChannel]: IpcChannelMap[K]['return'] extends void ? K : never }[IpcChannel]

// Dialog 相关类型（简化版，不依赖 electron 类型）
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
```

## 2. 主进程设计（src/main/）

### 2.1 模块标准接口

每个 module 必须导出：

```typescript
export interface MainModule {
  /** 注册 IPC handlers（在 ipc-registry 初始化时调用） */
  register(): void
  /** 模块初始化（在 bootstrap 中按顺序调用） */
  init?(): void | Promise<void>
}
```

### 2.2 核心层

**ipc-registry.ts** — 收集所有 module 的 handlers 并统一注册：
- 导入所有 modules
- 调用每个 module 的 `register()` 方法
- 提供 `registerHandler(channel, handler)` 和 `registerListener(channel, handler)` 工具函数
- handler 内部自动包装 try-catch，错误通过 logger 记录

**logger.ts** — 简单日志服务：
- 开发环境：console.log/warn/error 带时间戳和模块标签
- 生产环境：写入 `app.getPath('logs')` 目录
- API：`logger.info(module, message)`, `logger.warn(...)`, `logger.error(...)`

**error-handler.ts** — 全局错误捕获：
- `process.on('uncaughtException')` 
- `process.on('unhandledRejection')`
- 错误通过 logger 记录

**event-bus.ts** — 主进程内部事件通信：
- 基于 Node.js EventEmitter
- 类型安全的 emit/on/off

### 2.3 业务模块

**window module:**
- `register()`: 注册 window:minimize, window:maximize, window:close, window:isMaximized
- `window.service.ts`: createWindow() 逻辑（从现有 index.ts 迁移），窗口状态管理
- 监听 maximize/unmaximize 事件，通过 IPC 通知渲染进程

**storage module:**
- `register()`: 注册 storage:get, storage:set, storage:delete, storage:has
- `storage.service.ts`: 使用 electron-store（新增依赖）或简单的 JSON 文件读写
- 设计决策：使用 Node.js fs 读写 JSON 文件到 `app.getPath('userData')`，不引入额外依赖

**system module:**
- `register()`: 注册所有 system:* channels
- `system.service.ts`: 封装 shell.openExternal, clipboard, dialog, Notification, globalShortcut

**tray module:**
- `register()`: 无 IPC（托盘不需要渲染进程调用）
- `init()`: 创建系统托盘（从现有 tray.ts 迁移）

### 2.4 Bootstrap 启动流程

`src/main/bootstrap.ts`:

```
1. 初始化 logger
2. 初始化 error-handler
3. 初始化 ipc-registry（调用所有 module.register()）
4. 调用各 module.init()（window、storage、tray）
5. 创建主窗口
```

`src/main/index.ts` 简化为：

```typescript
import { app } from 'electron'
import { bootstrap } from './bootstrap'

app.whenReady().then(() => bootstrap())

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') app.quit()
})
```

## 3. Preload 设计（src/preload/）

类型安全的 API 桥接，不暴露通用 invoke/send：

```typescript
const api = {
  window: {
    minimize: () => ipcRenderer.send(CHANNELS.WINDOW.MINIMIZE),
    maximize: () => ipcRenderer.send(CHANNELS.WINDOW.MAXIMIZE),
    close: () => ipcRenderer.send(CHANNELS.WINDOW.CLOSE),
    isMaximized: (): Promise<boolean> => ipcRenderer.invoke(CHANNELS.WINDOW.IS_MAXIMIZED),
    onMaximizeChange: (cb: (maximized: boolean) => void) => { ... },
  },
  storage: {
    get: <T>(key: string): Promise<T> => ipcRenderer.invoke(CHANNELS.STORAGE.GET, key),
    set: (key: string, value: unknown): Promise<void> => ipcRenderer.invoke(CHANNELS.STORAGE.SET, key, value),
    delete: (key: string): Promise<void> => ipcRenderer.invoke(CHANNELS.STORAGE.DELETE, key),
    has: (key: string): Promise<boolean> => ipcRenderer.invoke(CHANNELS.STORAGE.HAS, key),
  },
  system: {
    getVersion: (): Promise<string> => ipcRenderer.invoke(CHANNELS.SYSTEM.GET_VERSION),
    getPlatform: (): Promise<NodeJS.Platform> => ipcRenderer.invoke(CHANNELS.SYSTEM.GET_PLATFORM),
    openExternal: (url: string): Promise<void> => ipcRenderer.invoke(CHANNELS.SYSTEM.OPEN_EXTERNAL, url),
    // ... 其他 system API
  },
}
```

## 4. 渲染进程核心设计（src/renderer/core/）

### 4.1 IPC Client

`ipc-client.ts` — 封装 window.api 调用：

```typescript
class IpcClient {
  async invoke<T>(module: string, method: string, ...args: unknown[]): Promise<T> {
    try {
      const api = (window.api as any)[module]
      if (!api || !api[method]) throw new Error(`API not found: ${module}.${method}`)
      return await api[method](...args)
    } catch (error) {
      errorHandler.handle(error)
      throw error
    }
  }
}

export const ipcClient = new IpcClient()
```

设计决策：ipc-client 作为薄封装层，主要职责是统一错误处理。composables 直接调用 `window.api.module.method()` 也可以，ipc-client 提供额外的错误边界。

### 4.2 Error Handler

`error-handler.ts`:
- 注册 `app.config.errorHandler`（Vue 组件错误）
- 注册 `window.addEventListener('unhandledrejection')`
- 开发环境：console.error + 可选的 toast 提示
- 生产环境：静默处理 + 日志

### 4.3 Event Bus

`event-bus.ts`:
- 基于 mitt（轻量事件库，已广泛使用）
- 设计决策：不引入 mitt 依赖，用简单的自实现（Map<string, Set<Function>>）保持零依赖

## 5. Composables 设计（src/renderer/composables/）

所有 composable 通过 `window.api` 调用 preload 暴露的 API。

### 5.1 useTheme

```typescript
export function useTheme() {
  const appStore = useAppStore()
  const isDark = computed(() => appStore.isDark)
  const toggle = () => appStore.toggleTheme()
  const set = (dark: boolean) => appStore.setTheme(dark)
  return { isDark, toggle, set }
}
```

### 5.2 usePlatform

```typescript
export function usePlatform() {
  const platform = ref<NodeJS.Platform>('win32')
  const isMac = computed(() => platform.value === 'darwin')
  const isWindows = computed(() => platform.value === 'win32')
  const isLinux = computed(() => platform.value === 'linux')

  onMounted(async () => {
    platform.value = await window.api.system.getPlatform()
  })

  return { platform, isMac, isWindows, isLinux }
}
```

### 5.3 useStorage

```typescript
export function useStorage() {
  return {
    get: <T>(key: string) => window.api.storage.get<T>(key),
    set: (key: string, value: unknown) => window.api.storage.set(key, value),
    remove: (key: string) => window.api.storage.delete(key),
    has: (key: string) => window.api.storage.has(key),
  }
}
```

### 5.4 useClipboard

```typescript
export function useClipboard() {
  const text = ref('')
  return {
    text: readonly(text),
    read: async () => { text.value = await window.api.system.readClipboard(); return text.value },
    write: (t: string) => window.api.system.writeClipboard(t),
  }
}
```

### 5.5 useShell

```typescript
export function useShell() {
  return {
    openExternal: (url: string) => window.api.system.openExternal(url),
    showItemInFolder: (path: string) => window.api.system.showItemInFolder(path),
  }
}
```

### 5.6 useKeyboard

```typescript
export function useKeyboard() {
  return {
    register: (accelerator: string, id: string) => window.api.system.registerShortcut(accelerator, id),
    unregister: (id: string) => window.api.system.unregisterShortcut(id),
  }
}
```

### 5.7 useDialog

```typescript
export function useDialog() {
  return {
    openFile: (options?: OpenDialogOptions) => window.api.system.showOpenDialog(options ?? {}),
    saveFile: (options?: SaveDialogOptions) => window.api.system.showSaveDialog(options ?? {}),
    messageBox: (options: MessageBoxOptions) => window.api.system.showMessageBox(options),
  }
}
```

### 5.8 useNotification

```typescript
export function useNotification() {
  return {
    show: (options: NotificationOptions) => window.api.system.showNotification(options),
  }
}
```

## 6. 自建 UI 组件设计（src/renderer/components/ui/）

所有组件用 Tailwind CSS + CSS 变量构建，不依赖 Element Plus。

### 6.1 GlassCard

Props: `blur?: number`（默认 20）, `opacity?: number`（默认 0.85）
效果：backdrop-filter 毛玻璃，圆角 radius-lg，细边框，柔和阴影

### 6.2 PageHeader

Props: `title: string`, `description?: string`
Slots: `#actions`（右侧操作区）
效果：左侧标题+描述，右侧操作按钮区

### 6.3 StatCard

Props: `label: string`, `value: string | number`, `icon?: string`, `trend?: 'up' | 'down'`, `gradient?: string`
效果：图标 + 数值 + 标签 + 可选趋势箭头，渐变图标背景

### 6.4 EmptyState

Props: `title?: string`, `description?: string`, `icon?: string`
Slots: `#action`（操作按钮）
效果：居中图标 + 文字 + 操作按钮

### 6.5 LoadingOverlay

Props: `loading: boolean`, `fullscreen?: boolean`
效果：半透明遮罩 + 旋转动画，支持全屏和局部

### 6.6 SettingsPanel

Props: `title: string`
Slots: `default`（设置项列表）
子组件 `SettingsItem`: Props `label: string`, `description?: string`, Slot `default`（右侧控件）
效果：分组卡片，每项左侧标签+描述，右侧控件

## 7. 自建布局组件设计（src/renderer/components/layout/）

### 7.1 Sidebar 重建

移除 el-menu、el-scrollbar、el-icon 依赖。用 Tailwind 实现：
- 路由驱动菜单项（从 router 读取 meta）
- 激活态：左侧 2px 指示条 + 背景色 + 文字加粗
- 折叠/展开动画
- 自定义滚动条（CSS ::-webkit-scrollbar）
- 图标：使用 SVG 内联或简单的 emoji/文字图标（不依赖 Element Plus Icons）

设计决策：图标方案改为使用 Lucide Icons（轻量 SVG 图标库，tree-shakable）。新增 `lucide-vue-next` 依赖。

### 7.2 Topbar 重建

移除 el-icon、el-dropdown 依赖。用 Tailwind 实现：
- 面包屑（保留现有 Breadcrumb 组件）
- 主题切换按钮（SVG 图标）
- 用户头像下拉菜单（自建 dropdown）

### 7.3 TabsBar 保留

现有 TabsBar 已经是纯 Tailwind 实现，保留。

### 7.4 TitleBar 保留

现有 TitleBar 已经是纯 Tailwind + SVG 实现，保留。优化：
- 使用 usePlatform composable 替代 navigator.userAgent 检测
- 使用 window.api.window 替代直接 window.api 调用

## 8. Element Plus 集成策略

### 8.1 按需导入

从全量导入改为按需导入：

```typescript
// main.ts — 不再 app.use(ElementPlus)
// 改为在需要的组件中按需 import
import { ElSwitch, ElSelect, ElOption } from 'element-plus'
```

使用 `unplugin-vue-components` + `unplugin-auto-import` 实现自动按需导入。

### 8.2 样式覆盖

`element-override.css` — 统一 Element Plus 组件的视觉风格：
- 圆角统一为 CSS 变量
- 阴影统一为柔和风格
- 字体统一
- 暗色模式联动

### 8.3 图标迁移

从 `@element-plus/icons-vue` 迁移到 `lucide-vue-next`：
- 移除 `@element-plus/icons-vue` 依赖
- 新增 `lucide-vue-next` 依赖
- 布局组件中的图标全部替换

## 9. 依赖变更

### 新增
- `lucide-vue-next` — SVG 图标库（替代 @element-plus/icons-vue 用于布局）
- `unplugin-vue-components` — Element Plus 按需导入
- `unplugin-auto-import` — Element Plus 按需导入

### 移除
- `@element-plus/icons-vue`（布局不再使用，Element Plus 功能组件自带图标）

### 保留
- `element-plus`（仅用于功能组件）
- `pinia` + `pinia-plugin-persistedstate`
- `vue-router`
- `vue-i18n`
- `tailwindcss`
- 所有 dev 依赖

## 10. IPC 调用链

完整调用链示例（以 useClipboard 为例）：

```
业务组件调用 useClipboard().read()
  → composable 调用 window.api.system.readClipboard()
    → preload 调用 ipcRenderer.invoke('system:readClipboard')
      → ipc-registry 路由到 system module 的 handler
        → system.service.ts 调用 clipboard.readText()
          → 返回结果原路返回
```

## 11. 测试策略

本项目是预设模板（不是运行中的应用），不包含 PBT 测试。验证方式：
- 代码审查：确保类型安全、模块接口一致
- 手动验证：克隆模板后 `pnpm install && pnpm dev` 能正常运行
- TypeScript 编译检查：`vue-tsc --noEmit` 无错误
