# 项目架构文档

> 本文档描述了整个项目的设计思想、技术栈、目录结构和开发约定。
> AI 助手加载此文档后，即可理解项目全貌并开始开发具体功能。
> **核心原则：本项目是 Windows / macOS / Linux 三平台桌面应用，所有功能必须同时在三个平台上正常运行。**

## 一、项目定位

这是一个 **Electron + Vue 3 桌面应用模板**，设计目标是提供 macOS 级别的视觉质感（毛玻璃/高斯模糊/玻璃态），同时在 **Windows / macOS / Linux** 上都能优雅运行。

UI 风格参考了 shadcn/ui 的设计语言 — 不使用任何重型 UI 组件库（如 Element Plus、Ant Design），而是用 Tailwind CSS 原子类 + radix-vue 无样式原语 + 手写组件的方式，实现完全可控的精致界面。

**跨平台是本项目的第一优先级。** 任何功能、任何代码变更都必须确保 Windows / macOS / Linux 三平台可用。
不存在"先做一个平台再适配另一个"的情况 — 每次提交都必须是三平台完整可用的。

## 一.五、跨平台开发规范（最重要）

### 核心原则

每开发一个功能，必须按以下清单逐项检查：

| 检查项 | 说明 |
|--------|------|
| **窗口标题栏** | macOS 用 `hiddenInset` + 红绿灯，Windows 用 `titleBarOverlay` 系统按钮，Linux 同 Windows |
| **系统托盘** | 三平台 API 一致（Electron Tray），但图标格式不同（Windows .ico，macOS 模板图标，Linux .png） |
| **文件路径** | 使用 `app.getPath()` 系列 API，不要硬编码路径分隔符 |
| **快捷键** | macOS 用 `CommandOrControl`（映射 Cmd），Windows/Linux 映射 Ctrl |
| **字体渲染** | 三平台渲染引擎不同，macOS 最精细，Windows ClearType，Linux 随配置 |
| **窗口材质** | macOS `vibrancy: 'sidebar'`，Windows `backgroundMaterial: 'mica'`，Linux 无系统级模糊 |
| **原生模块** | 引入 Node.js 原生模块前确认三平台预编译二进制可用 |
| **系统通知** | Electron `Notification` 三平台行为不同（macOS 通知中心、Windows 操作中心、Linux 桌面通知） |
| **文件对话框** | `dialog.showOpenDialog` 过滤器格式三平台一致，但默认路径不同 |
| **深色模式** | `nativeTheme.shouldUseDarkColors` 统一检测，但 titleBarOverlay 颜色需动态更新 |

### 平台差异处理模式

```typescript
// ✅ 正确：使用 appStore 中的平台检测
const { isMac, isWindows, isLinux } = usePlatform()

if (isMac) {
  // macOS 特有逻辑（如红绿灯区域预留）
} else {
  // Windows / Linux 逻辑（如自定义窗口按钮区域）
}

// 主进程中
import { platform } from 'node:process'
if (platform === 'darwin') { /* macOS */ }
if (platform === 'win32')  { /* Windows */ }
if (platform === 'linux')  { /* Linux */ }

// ❌ 禁止：只考虑一个平台
// 禁止写 Windows-only 的代码而不处理 macOS 和 Linux
```

### 常见跨平台陷阱

| 陷阱 | Windows | macOS | Linux | 解决方案 |
|------|---------|-------|-------|----------|
| 标题栏 | `titleBarOverlay` 系统按钮 | `hiddenInset` + 红绿灯 | 同 Windows | `window.service.ts` 已处理 |
| 窗口模糊 | `backgroundMaterial: 'mica'` | `vibrancy: 'sidebar'` | 不支持 | CSS `.glass` 类兜底 |
| 托盘图标 | `.ico` 格式 | 模板图标（16x16 @2x） | `.png` 格式 | `tray.service.ts` 按平台选择 |
| 文件路径 | `\` 分隔符 | `/` 分隔符 | `/` 分隔符 | 使用 `path.join()` |
| 系统字体 | 微软雅黑 | 苹方 | 随桌面环境 | CSS `font-family` fallback 链 |
| 应用签名 | 代码签名证书 | Apple Developer ID | 无需签名 | `electron-builder` 配置 |
| 自动更新 | NSIS 安装包 | DMG / zip | AppImage | `electron-updater` |
| 高 DPI | 缩放比例不同 | Retina 2x | 随设置 | CSS `rem` + Tailwind 自动处理 |

### 插件/原生模块选择规范

引入新的 npm 包时，如果包含原生模块（N-API / node-gyp），必须检查：

1. **平台支持**：确认 Windows ✅ + macOS ✅ + Linux ✅ 预编译二进制可用
2. **Electron 版本兼容**：确认支持当前 Electron 版本的 Node.js ABI
3. **构建依赖**：是否需要 Visual Studio Build Tools（Windows）/ Xcode（macOS）/ build-essential（Linux）？
4. **打包兼容**：`electron-builder` 能否正确打包该原生模块？

### 平台特定配置

| 配置 | 位置 | 何时需要修改 |
|------|------|-------------|
| Windows 安装包 | `electron-builder.yml` → `nsis` | 安装选项、注册表、文件关联 |
| macOS 签名 | `electron-builder.yml` → `mac` | 签名证书、公证、entitlements |
| Linux 打包 | `electron-builder.yml` → `linux` | 桌面文件、图标、分类 |
| 窗口创建 | `window.service.ts` | 标题栏样式、窗口材质、最小尺寸 |
| 托盘 | `tray.service.ts` | 图标路径、菜单项 |

**规则：修改任何平台相关配置时，必须同时检查其他两个平台是否需要对应修改。**

## 二、技术栈

| 层级 | 技术 | 版本 | 说明 |
|------|------|------|------|
| 桌面框架 | Electron | 40.x | 主进程 + 渲染进程架构 |
| 构建工具 | electron-vite | 5.x | 统一管理 main/preload/renderer 三个 vite 构建 |
| 前端框架 | Vue 3 | 3.5.x | Composition API + `<script setup>` |
| 路由 | vue-router | 4.6.x | Hash 模式（Electron 兼容） |
| 状态管理 | Pinia | 3.x | Setup Store 风格 |
| 持久化 | pinia-plugin-persistedstate | 4.x | 自动持久化到 localStorage |
| 国际化 | vue-i18n | 11.x | Composition API 模式（`legacy: false`） |
| CSS | Tailwind CSS | 4.x | v4 新语法（`@theme inline`、`@custom-variant`） |
| CSS 工具 | tailwind-merge + clsx | 最新 | `cn()` 工具函数合并 class |
| 无样式原语 | radix-vue | 1.9.x | 可访问性优先的无样式 UI 原语（按需使用） |
| 图标 | lucide-vue-next | 0.563.x | 轻量 SVG 图标库（当前布局组件使用内联 SVG） |
| 样式方法论 | class-variance-authority | 0.7.x | 组件变体管理（cva） |
| TypeScript | typescript | 5.9.x | 全项目严格模式 |

### 为什么不用 Element Plus / Ant Design Vue？

- 这些库的视觉风格偏"后台管理系统"，无法达到 macOS 原生应用的精致感
- 玻璃态（glassmorphism）需要精确控制 `backdrop-filter`、半透明色值、阴影层次，组件库的封装会阻碍这种控制
- shadcn/ui 的理念是"把代码复制到你的项目里"，完全可控，这正是我们需要的

## 三、目录结构

```
src/
├── main/                          # Electron 主进程
│   ├── index.ts                   # 入口：app.whenReady → bootstrap()
│   ├── bootstrap.ts               # 启动编排：初始化顺序控制
│   ├── core/                      # 核心基础设施
│   │   ├── logger.ts              # 日志（dev→console，prod→文件）
│   │   ├── error-handler.ts       # 全局异常捕获
│   │   ├── event-bus.ts           # 主进程事件总线
│   │   └── ipc-registry.ts        # IPC handler 注册中心（自动 try-catch）
│   └── modules/                   # 功能模块（每个模块一个文件夹）
│       ├── window/                # 窗口管理
│       │   ├── index.ts           # IPC handlers 注册
│       │   └── window.service.ts  # 窗口创建、平台适配
│       ├── storage/               # 本地存储（JSON 文件）
│       │   ├── index.ts
│       │   └── storage.service.ts
│       ├── system/                # 系统功能（剪贴板、对话框、快捷键等）
│       │   ├── index.ts
│       │   └── system.service.ts
│       └── tray/                  # 系统托盘
│           ├── index.ts
│           └── tray.service.ts
│
├── preload/                       # 预加载脚本
│   └── index.ts                   # contextBridge 暴露 window.api
│
├── renderer/                      # 渲染进程（Vue 应用）
│   ├── main.ts                    # Vue 应用入口
│   ├── App.vue                    # 根组件
│   ├── env.d.ts                   # window.api 类型声明
│   ├── index.html                 # HTML 模板
│   ├── assets/styles/
│   │   └── index.css              # 全局样式（Tailwind v4 + 玻璃态 + 色彩系统）
│   ├── components/
│   │   ├── layout/
│   │   │   ├── AppLayout.vue      # 主布局（背景渐变 + NavRail + 内容区）
│   │   │   └── NavRail.vue        # 56px 窄侧边栏（图标导航 + 玻璃态）
│   │   └── ui/                    # UI 组件目录（按需添加）
│   ├── composables/               # Vue 组合式函数（封装 IPC 调用）
│   │   ├── useClipboard.ts        # 剪贴板读写
│   │   ├── useDialog.ts           # 系统对话框（打开/保存/消息框）
│   │   ├── useKeyboard.ts         # 全局快捷键注册
│   │   ├── useNotification.ts     # 系统通知
│   │   ├── usePlatform.ts         # 平台检测
│   │   ├── useShell.ts            # 打开外部链接/文件夹
│   │   ├── useStorage.ts          # 主进程存储读写
│   │   └── useTheme.ts            # 主题切换
│   ├── config/
│   │   └── app.ts                 # 应用配置（名称、描述、语言等）
│   ├── core/
│   │   ├── error-handler.ts       # Vue 全局错误处理
│   │   ├── event-bus.ts           # 渲染进程事件总线
│   │   └── ipc-client.ts          # IPC 调用封装（可选，也可直接用 window.api）
│   ├── i18n/
│   │   ├── index.ts               # vue-i18n 初始化
│   │   └── locales/
│   │       ├── zh-CN.ts           # 中文语言包
│   │       └── en-US.ts           # 英文语言包
│   ├── lib/
│   │   └── utils.ts               # cn() 工具函数（clsx + tailwind-merge）
│   ├── router/
│   │   ├── index.ts               # 路由配置（自动扫描 modules/）
│   │   └── modules/               # 路由模块（自动注册）
│   │       └── demo.ts            # 示例模块
│   ├── stores/
│   │   ├── app.ts                 # 全局状态（主题、语言、平台）
│   │   └── tabs.ts                # 标签页状态（预留）
│   └── views/                     # 页面组件
│       ├── home/index.vue         # 首页
│       └── settings/index.vue     # 设置页
│
└── shared/                        # 主进程 + 渲染进程共享代码
    ├── constants/
    │   └── ipc-channels.ts        # IPC 通道名称常量
    └── types/
        └── ipc.types.ts           # IPC 类型定义
```

## 四、核心设计思想

### 4.1 三进程架构

```
┌─────────────┐     IPC      ┌──────────────┐    contextBridge    ┌───────────────┐
│  Main 主进程  │ ◄──────────► │ Preload 预加载 │ ◄────────────────► │ Renderer 渲染  │
│  (Node.js)   │              │  (受限 Node)   │                    │  (Vue 应用)    │
└─────────────┘              └──────────────┘                    └───────────────┘
```

- **主进程**：Node.js 环境，管理窗口、系统 API、文件存储
- **预加载脚本**：桥接层，通过 `contextBridge.exposeInMainWorld('api', ...)` 暴露安全 API
- **渲染进程**：纯浏览器环境，运行 Vue 应用，通过 `window.api` 调用主进程功能

### 4.2 IPC 通信设计

所有跨进程通信遵循统一模式：

1. **通道名称**定义在 `src/shared/constants/ipc-channels.ts`，格式为 `模块:动作`
2. **类型定义**在 `src/shared/types/ipc.types.ts`，主进程和渲染进程共享
3. **主进程 handler** 在各模块的 `index.ts` 中注册，通过 `ipc-registry.ts` 统一包装 try-catch
4. **预加载脚本**在 `preload/index.ts` 中按模块分组暴露 API
5. **渲染进程**通过 `window.api.模块.方法()` 调用，或通过 composables 封装

**添加新 IPC 通道的步骤：**
1. 在 `ipc-channels.ts` 添加通道常量
2. 在 `ipc.types.ts` 添加类型（可选）
3. 在对应模块的 `index.ts` 注册 handler
4. 在 `preload/index.ts` 暴露 API
5. 在 `env.d.ts` 更新 `Window` 类型声明
6. 在渲染进程使用 `window.api.xxx.yyy()`

### 4.3 模块化主进程

主进程采用模块化设计，每个功能域一个文件夹：

```
modules/
├── window/          # 窗口创建、最小化/最大化/关闭、titleBarOverlay
├── storage/         # JSON 文件存储（userData 目录）
├── system/          # 系统功能集合（剪贴板、对话框、快捷键、通知等）
└── tray/            # 系统托盘
```

每个模块包含：
- `index.ts` — IPC handler 注册 + 模块初始化导出
- `xxx.service.ts` — 业务逻辑实现

**添加新模块的步骤：**
1. 创建 `src/main/modules/新模块/index.ts` 和 `新模块.service.ts`
2. 在 `ipc-channels.ts` 添加通道
3. 在 `ipc-registry.ts` 导入并调用 `register()`
4. 如需初始化，在 `bootstrap.ts` 调用 `init()`

### 4.4 启动流程

```
app.whenReady() → bootstrap()
  1. initErrorHandler()        — 全局异常捕获
  2. electronApp.setAppUserModelId() — Windows 任务栏标识
  3. initIpcRegistry()         — 注册所有模块的 IPC handlers
  4. initStorage()             — 初始化本地存储
  5. createWindow()            — 创建主窗口（平台适配）
  6. initTray()                — 创建系统托盘
```

## 五、视觉设计系统

### 5.1 玻璃态（Glassmorphism）

这是本项目的核心视觉特征。实现方式：

**底层**：`AppLayout.vue` 中放置多层径向渐变背景（radial-gradient mesh），为玻璃效果提供可透出的色彩内容。

**中层**：所有卡片、侧边栏使用半透明背景色 + `backdrop-filter: blur()` 实现毛玻璃效果。

**CSS 工具类**（定义在 `index.css`）：
- `.glass` — 强模糊（blur 40px, saturate 180%），用于侧边栏
- `.glass-subtle` — 轻模糊（blur 20px, saturate 150%），用于小元素
- `.glass-card` — 卡片模糊（blur 24px）+ 多层阴影，用于内容卡片

**色彩系统**：使用 oklch 色彩空间，所有颜色变量带透明度通道：
```css
--card: oklch(1 0 0 / 72%);          /* 亮色：72% 不透明白 */
--sidebar: oklch(0.98 0.002 260 / 65%); /* 亮色：65% 不透明 */
--card: oklch(1 0 0 / 6%);           /* 暗色：6% 不透明白 */
```

### 5.2 平台窗口适配

窗口标题栏根据真实平台自动适配（不模拟，不切换）：

| 平台 | 标题栏方案 | 特殊处理 |
|------|-----------|---------|
| macOS | `titleBarStyle: 'hiddenInset'` | `vibrancy: 'sidebar'` 系统级模糊 + `trafficLightPosition` 红绿灯位置 |
| Windows | `titleBarStyle: 'hidden'` + `titleBarOverlay` | 系统绘制最小化/最大化/关闭按钮，`backgroundMaterial: 'mica'` 系统级模糊 |
| Linux | 同 Windows 方案 | — |

**暗色模式适配**：切换主题时通过 IPC 调用 `window:setTitleBarOverlay` 动态更新按钮颜色（亮色 `#555555`，暗色 `#cccccc`）。

### 5.3 布局结构

```
┌──────────────────────────────────────────────┐
│  (macOS: 红绿灯区域)  │   可拖拽标题栏区域      │
├──────┬───────────────────────────────────────┤
│      │                                       │
│  N   │                                       │
│  a   │          页面内容区                     │
│  v   │          (router-view)                │
│  R   │                                       │
│  a   │                                       │
│  i   │                                       │
│  l   │                                       │
│      │                                       │
├──────┤                                       │
│ 主题 │                                       │
└──────┴───────────────────────────────────────┘
```

- **NavRail**：56px 宽的图标侧边栏，顶部 App 图标，中间导航图标，底部主题切换
- 导航项从路由配置自动生成（`meta.title` + `meta.icon`）
- 当前激活项左侧有 3px 蓝色指示条
- 悬停显示玻璃态 tooltip

### 5.4 Tailwind CSS v4 配置

本项目使用 Tailwind CSS v4 新语法，**没有** `tailwind.config.js` 文件。所有配置在 `index.css` 中：

```css
@import "tailwindcss";                    /* 导入 Tailwind */
@custom-variant dark (&:is(.dark *));     /* 暗色模式变体（class 策略） */
@theme inline { ... }                     /* 主题 token 映射 */
:root { ... }                             /* 亮色变量 */
.dark { ... }                             /* 暗色变量 */
```

Vite 插件配置（`electron.vite.config.ts`）：
```ts
import tailwindcss from '@tailwindcss/vite'
plugins: [vue(), tailwindcss()]  // 不需要 PostCSS 配置
```

## 六、状态管理

### app store（`stores/app.ts`）

| 状态 | 类型 | 持久化 | 说明 |
|------|------|--------|------|
| `isDark` | `boolean` | ✅ | 暗色模式开关 |
| `locale` | `'zh-CN' \| 'en-US'` | ✅ | 当前语言 |
| `platform` | `'windows' \| 'macos' \| 'linux'` | ❌ | 真实平台（启动时 IPC 检测） |

关键方法：
- `toggleTheme()` — 切换主题 + 更新 DOM class + 同步 titleBarOverlay 颜色
- `detectPlatform()` — 通过 `window.api.system.getPlatform()` 获取真实平台

### tabs store（`stores/tabs.ts`）

预留的标签页管理，支持添加/删除/切换标签。当前布局未使用标签栏，但 store 已就绪。

## 七、路由系统

路由使用 **Hash 模式**（Electron file:// 协议兼容）。

路由配置支持两种方式：
1. **直接定义**：在 `router/index.ts` 中写死（如 Home、Settings）
2. **模块自动注册**：在 `router/modules/` 下创建 `.ts` 文件，导出路由数组，自动扫描注册

路由 meta 字段：
```ts
meta: {
  title: '页面标题',        // 用于菜单显示
  titleKey: 'menu.xxx',    // i18n key（优先使用）
  icon: 'home',            // 图标标识（NavRail 中匹配）
}
```

**添加新页面的步骤：**
1. 在 `views/` 下创建页面组件（如 `views/about/index.vue`）
2. 在 `router/modules/` 下创建路由文件，导出路由数组
3. NavRail 会自动显示新的导航项（需要 `meta.title` 和 `meta.icon`）
4. 在 `i18n/locales/` 中添加对应的翻译 key

## 八、国际化

使用 vue-i18n v11 Composition API 模式。

语言包结构（`i18n/locales/zh-CN.ts`）：
```ts
export default {
  common: { confirm: '确认', cancel: '取消', ... },
  menu: { home: '首页', settings: '设置', ... },
  home: { welcome: '欢迎使用', ... },
  settings: { title: '设置', ... },
}
```

在组件中使用：
```vue
<script setup>
const { t } = useI18n()
</script>
<template>
  <span>{{ t('menu.home') }}</span>
</template>
```

## 九、Composables 速查

所有 composables 封装了 `window.api` 的调用，在 Vue 组件中直接使用：

| Composable | 功能 | 示例 |
|-----------|------|------|
| `useClipboard()` | 剪贴板读写 | `const { read, write } = useClipboard()` |
| `useDialog()` | 系统对话框 | `const { openFile, saveFile, messageBox } = useDialog()` |
| `useKeyboard()` | 全局快捷键 | `const { register, unregister } = useKeyboard()` |
| `useNotification()` | 系统通知 | `const { show } = useNotification()` |
| `usePlatform()` | 平台检测 | `const { isMac, isWindows } = usePlatform()` |
| `useShell()` | 打开链接/文件夹 | `const { openExternal } = useShell()` |
| `useStorage()` | 主进程存储 | `const { get, set } = useStorage()` |
| `useTheme()` | 主题切换 | `const { isDark, toggle } = useTheme()` |

## 十、开发命令

```bash
pnpm dev        # 启动开发模式（HMR 热更新）
pnpm build      # 构建生产版本
pnpm preview    # 预览生产构建
pnpm pack       # 打包为目录（不生成安装包）
pnpm dist       # 打包为安装包（nsis/dmg/AppImage）
```

**注意**：首次运行需要下载 Electron 二进制文件。如果在中国大陆，设置镜像：
```bash
# PowerShell
$env:ELECTRON_MIRROR="https://npmmirror.com/mirrors/electron/"
pnpm dev
```

## 十一、构建配置

### electron-vite 配置（`electron.vite.config.ts`）

三个独立的 Vite 构建配置：
- **main**：主进程，使用 `externalizeDepsPlugin()` 排除 Node 模块
- **preload**：预加载脚本，同上
- **renderer**：渲染进程，使用 `vue()` + `tailwindcss()` 插件

路径别名：
- `@` → `src/renderer/`（仅渲染进程）
- `@shared` → `src/shared/`（所有进程）

### TypeScript 配置

- `tsconfig.json`：主配置，覆盖所有 `src/` 文件，`moduleResolution: "bundler"`
- `tsconfig.node.json`：仅覆盖 `electron.vite.config.ts`

## 十二、开发约定

1. **跨平台优先**：每个功能必须同时在 Windows / macOS / Linux 上可用，不允许单平台实现
2. **组件风格**：全部使用 `<script setup lang="ts">` + Composition API
3. **样式方式**：Tailwind 原子类为主，复杂效果用 CSS 工具类（`.glass`、`.glass-card`）
4. **IPC 安全**：渲染进程不直接访问 Node API，全部通过 `window.api` 桥接
5. **平台检测**：使用 `appStore.isMac` / `appStore.platform`，不要用 `navigator.userAgent`
6. **主题切换**：通过 `appStore.toggleTheme()`，会自动同步 DOM class + titleBarOverlay
7. **新增功能模块**：遵循 `modules/模块名/index.ts + 模块名.service.ts` 的结构
8. **UI 组件**：放在 `components/ui/` 下，使用 `cn()` 合并 class，支持 `class` prop 透传
9. **不使用 UI 组件库**：所有 UI 手写或基于 radix-vue 原语构建
10. **平台配置同步**：修改任何平台相关配置时，必须同时检查其他两个平台是否需要对应修改
