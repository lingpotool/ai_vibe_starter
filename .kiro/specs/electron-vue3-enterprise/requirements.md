# Electron + Vue3 企业级预设架构重建

## 概述

将现有的 Electron + Vue3 预设模板从简单的插件式架构重建为企业级分层架构。用户克隆后改个项目名就能跑，只需专注在业务功能开发上。

## 用户故事

### 1. 类型安全的 IPC 通信体系

**作为** 使用预设模板的开发者
**我希望** IPC 通信有完整的类型定义和常量管理
**以便** 主进程和渲染进程之间的通信类型安全、不会拼错 channel 名

**验收标准:**
- [ ] `src/shared/types/ipc.types.ts` 定义所有 IPC channel 的请求/响应类型
- [ ] `src/shared/constants/ipc-channels.ts` 集中管理所有 channel 名称常量
- [ ] 主进程和渲染进程共享同一套类型定义
- [ ] 新增 IPC 通道只需在 shared 层添加类型和常量，两端自动获得类型提示

### 2. 主进程模块化架构

**作为** 使用预设模板的开发者
**我希望** 主进程按职责分层，核心基础设施和业务模块分离
**以便** 扩展功能时只需在 modules 中添加新模块，不影响核心层

**验收标准:**
- [ ] `src/main/core/ipc-registry.ts` — 统一的 IPC handler 注册中心，自动从 modules 收集 handlers
- [ ] `src/main/core/logger.ts` — 日志服务（开发环境控制台 + 生产环境文件日志）
- [ ] `src/main/core/error-handler.ts` — 全局错误捕获和处理
- [ ] `src/main/core/event-bus.ts` — 主进程内部事件总线
- [ ] `src/main/modules/window/` — 窗口管理（创建、控制、状态）
- [ ] `src/main/modules/storage/` — 数据持久化服务
- [ ] `src/main/modules/system/` — 系统信息（平台、版本等）
- [ ] `src/main/modules/tray/` — 系统托盘
- [ ] `src/main/bootstrap.ts` — 应用启动编排，按顺序初始化各模块
- [ ] 每个 module 导出标准接口：`register()` 注册 IPC handlers + `init()` 初始化

### 3. 类型安全的 Preload 桥接

**作为** 使用预设模板的开发者
**我希望** preload 层的 API 桥接是类型安全的
**以便** 渲染进程调用主进程 API 时有完整的类型提示

**验收标准:**
- [ ] preload 基于 shared 类型定义生成 API 桥接
- [ ] 暴露的 API 按模块分组（window、storage、system 等）
- [ ] 不暴露通用的 invoke/send，只暴露明确定义的 API
- [ ] `src/renderer/env.d.ts` 中有完整的 window.api 类型声明

### 4. 渲染进程核心基础设施

**作为** 使用预设模板的开发者
**我希望** 渲染进程有统一的 IPC 客户端和错误处理
**以便** 业务代码不直接接触 IPC 细节，通过 composables 调用

**验收标准:**
- [ ] `src/renderer/core/ipc-client.ts` — 封装所有 IPC 调用，统一错误处理和 loading 状态
- [ ] `src/renderer/core/error-handler.ts` — 渲染进程全局错误处理（Vue errorHandler + unhandledrejection）
- [ ] `src/renderer/core/event-bus.ts` — 渲染进程内部事件总线
- [ ] IPC 调用链：composable → ipc-client → preload → ipc-registry → module service

### 5. Composables 工具库

**作为** 使用预设模板的开发者
**我希望** 常用的桌面应用功能都封装成 Vue composables
**以便** 在业务组件中一行代码就能使用窗口控制、剪贴板、存储等功能

**验收标准:**
- [ ] `useTheme()` — 主题切换（亮/暗），读取/设置当前主题
- [ ] `usePlatform()` — 平台检测（Mac/Win/Linux），平台相关的 UI 适配
- [ ] `useStorage()` — 持久化存储（通过 IPC 调用主进程 storage 模块）
- [ ] `useClipboard()` — 剪贴板读写
- [ ] `useShell()` — 打开外部链接、文件管理器
- [ ] `useKeyboard()` — 全局快捷键注册
- [ ] `useDialog()` — 原生对话框（打开文件、保存文件、消息框）
- [ ] `useNotification()` — 系统通知
- [ ] 每个 composable 内部通过 ipc-client 调用，业务代码无需关心 IPC

### 6. 自建 UI 组件（Mac 级视觉质感）

**作为** 使用预设模板的开发者
**我希望** 预设提供一套高质感的自建 UI 组件
**以便** 不依赖 Element Plus 就能构建出 Mac 应用级别的精致界面

**验收标准:**
- [ ] `GlassCard` — 毛玻璃卡片组件（backdrop-filter，可配置模糊度和透明度）
- [ ] `PageHeader` — 页面标题栏（标题 + 描述 + 操作区）
- [ ] `StatCard` — 数据统计卡片（图标 + 数值 + 趋势）
- [ ] `EmptyState` — 空状态占位（图标 + 文字 + 操作按钮）
- [ ] `LoadingOverlay` — 加载遮罩（支持全屏和局部）
- [ ] `SettingsPanel` — 设置面板（分组的设置项列表）
- [ ] 所有组件用 Tailwind CSS 构建，不依赖 Element Plus
- [ ] 所有组件支持亮色/暗色主题自动切换
- [ ] 动画流畅（transition/animation），间距精致

### 7. 自建布局组件

**作为** 使用预设模板的开发者
**我希望** 布局组件完全自建，不依赖 Element Plus 的布局能力
**以便** 获得 Mac 应用级别的布局质感（毛玻璃、精致间距、流畅动画）

**验收标准:**
- [ ] TitleBar — Mac/Win 自适应标题栏（保留现有设计，优化细节）
- [ ] Sidebar — 自建侧边栏（不用 el-menu，用 Tailwind 实现路由驱动菜单）
- [ ] Topbar — 顶部工具栏（面包屑 + 操作区）
- [ ] TabsBar — 标签页栏（自建，不用 el-tabs）
- [ ] AppLayout — 主布局编排
- [ ] 所有布局组件用 Tailwind + CSS 变量，不依赖 Element Plus

### 8. Element Plus 集成策略

**作为** 使用预设模板的开发者
**我希望** Element Plus 只用于功能性组件，且样式深度定制
**以便** 表单、表格、对话框等复杂交互组件开箱即用，同时视觉风格统一

**验收标准:**
- [ ] Element Plus 仅用于：Form、Table、Dialog、Select、DatePicker、Pagination 等功能组件
- [ ] `element-override.css` 深度定制 Element Plus 样式，统一圆角、阴影、间距
- [ ] 按需导入 Element Plus 组件（不全量导入），减小包体积
- [ ] Element Plus 暗色模式与自定义主题系统联动

### 9. 应用启动与配置

**作为** 使用预设模板的开发者
**我希望** 应用有清晰的启动流程和集中的配置管理
**以便** 改项目名只需改一个地方，启动顺序可控

**验收标准:**
- [ ] `src/renderer/config/app.ts` 集中管理应用配置（名称、描述、默认语言等）
- [ ] `package.json` 中的 name/appId/productName 与 app.ts 对应
- [ ] 主进程 bootstrap.ts 按顺序初始化：logger → error-handler → ipc-registry → modules → window
- [ ] 渲染进程 main.ts 按顺序初始化：pinia → router → i18n → Element Plus → 挂载

### 10. 保留现有功能

**作为** 使用预设模板的开发者
**我希望** 重建后保留所有已有的好功能
**以便** 不丢失已经设计好的能力

**验收标准:**
- [ ] i18n 中英文双语支持（保留）
- [ ] CSS 变量主题系统 + 亮/暗切换（保留并增强）
- [ ] Mac/Win 自适应标题栏（保留）
- [ ] Pinia 状态持久化（保留）
- [ ] 路由驱动侧边栏菜单（保留）
- [ ] 标签页系统（保留）
- [ ] 页面切换动画（保留）
- [ ] macOS 风格滚动条（保留）
- [ ] 系统托盘（保留，移入 modules/tray）
