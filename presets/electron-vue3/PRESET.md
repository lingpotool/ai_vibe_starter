# Electron + Vue3 桌面应用预设（企业级架构）

## 技术栈

- **框架**: Electron 33 + Vue 3.5 (Composition API + script setup)
- **构建工具**: Vite + electron-vite
- **语言**: TypeScript（严格模式）
- **UI 组件库**: Element Plus（按需导入，仅用于功能组件）
- **样式**: Tailwind CSS + CSS 变量主题系统
- **状态管理**: Pinia（带持久化）
- **路由**: Vue Router（路由驱动菜单）
- **国际化**: vue-i18n（中/英文）
- **包管理器**: pnpm

## 架构特点

### 企业级分层架构
- **共享层**（src/shared/）：跨进程类型定义和 IPC channel 常量
- **主进程**（src/main/）：core 核心层 + modules 业务模块
- **渲染进程**（src/renderer/）：core 核心层 + composables + 自建组件

### 类型安全的 IPC 通信
- 所有 IPC channel 名称集中管理（不会拼错）
- 请求/响应类型定义共享（主进程和渲染进程同一套类型）
- 调用链：composable → ipc-client → preload → ipc-registry → module service

### 自建 UI 组件（Mac 级质感）
- 布局组件全部自建（TitleBar、Sidebar、Topbar、TabsBar）
- 6 个通用 UI 组件（GlassCard、PageHeader、StatCard、EmptyState、LoadingOverlay、SettingsPanel）
- Element Plus 仅用于功能组件（Form、Table、Dialog、Select、Switch）

### 8 个 Composables
- useTheme / usePlatform / useStorage / useClipboard
- useShell / useKeyboard / useDialog / useNotification

## 修改项目名称

修改两个地方：
1. `src/renderer/config/app.ts` — 修改 `APP_CONFIG.name`
2. `package.json` — 修改 `name`、`build.appId`、`build.productName`

## 修改主色调

编辑 `src/renderer/assets/styles/theme.css`，修改 `--color-primary-*` 系列变量。

## 添加新页面

1. 在 `src/renderer/views/[功能名]/index.vue` 创建页面
2. 在 `src/renderer/router/modules/` 创建路由文件
3. 在 `src/renderer/i18n/locales/` 中添加翻译
4. 侧边栏菜单自动生成

## 添加主进程功能

1. 在 `src/shared/constants/ipc-channels.ts` 添加 channel 常量
2. 在 `src/shared/types/ipc.types.ts` 添加类型定义
3. 在 `src/main/modules/[模块名]/` 创建模块（index.ts + service.ts）
4. 在 `src/main/core/ipc-registry.ts` 中注册模块
5. 在 `src/preload/index.ts` 中暴露 API
6. 在 `src/renderer/env.d.ts` 中更新类型声明
7. 创建对应的 composable（可选）

## 目录结构

```
src/
├── shared/                          # ★ 跨进程共享层
│   ├── constants/
│   │   └── ipc-channels.ts          # IPC channel 名称常量
│   └── types/
│       └── ipc.types.ts             # IPC 类型定义
├── main/                            # Electron 主进程
│   ├── index.ts                     # 入口
│   ├── bootstrap.ts                 # 启动编排
│   ├── core/                        # 核心基础设施
│   │   ├── ipc-registry.ts          # IPC handler 注册中心
│   │   ├── logger.ts                # 日志服务
│   │   ├── error-handler.ts         # 全局错误处理
│   │   └── event-bus.ts             # 事件总线
│   └── modules/                     # ★ 业务模块（在这里加主进程功能）
│       ├── window/                  # 窗口管理
│       ├── storage/                 # 数据持久化
│       ├── system/                  # 系统功能（shell/clipboard/dialog/notification）
│       └── tray/                    # 系统托盘
├── preload/
│   └── index.ts                     # 类型安全的 API 桥接
└── renderer/                        # Vue 渲染进程
    ├── App.vue
    ├── main.ts
    ├── env.d.ts                     # window.api 类型声明
    ├── config/
    │   └── app.ts                   # ★ 应用配置（项目名在这里改）
    ├── core/                        # 渲染进程核心
    │   ├── ipc-client.ts            # IPC 调用封装
    │   ├── error-handler.ts         # 全局错误处理
    │   └── event-bus.ts             # 事件总线
    ├── composables/                 # ★ Vue Composables
    │   ├── useTheme.ts
    │   ├── usePlatform.ts
    │   ├── useStorage.ts
    │   ├── useClipboard.ts
    │   ├── useShell.ts
    │   ├── useKeyboard.ts
    │   ├── useDialog.ts
    │   └── useNotification.ts
    ├── components/
    │   ├── ui/                      # 自建 UI 组件
    │   │   ├── GlassCard.vue
    │   │   ├── PageHeader.vue
    │   │   ├── StatCard.vue
    │   │   ├── EmptyState.vue
    │   │   ├── LoadingOverlay.vue
    │   │   ├── SettingsPanel.vue
    │   │   └── SettingsItem.vue
    │   └── layout/                  # 自建布局组件
    │       ├── AppLayout.vue
    │       ├── TitleBar.vue
    │       ├── Sidebar.vue
    │       ├── Topbar.vue
    │       ├── Breadcrumb.vue
    │       └── TabsBar.vue
    ├── assets/styles/
    │   ├── index.css
    │   ├── theme.css                # ★ 主题变量（颜色在这里改）
    │   └── element-override.css     # Element Plus 样式覆盖
    ├── i18n/
    ├── router/
    │   ├── index.ts
    │   └── modules/                 # ★ 路由模块（在这里加页面路由）
    ├── stores/
    └── views/                       # ★ 页面（在这里加业务页面）
        ├── home/index.vue
        └── settings/index.vue
```

标 ★ 的是用户主要操作的文件/目录。
