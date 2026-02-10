# 实现任务列表

## 任务总览

将现有 Electron + Vue3 预设模板重建为企业级分层架构。所有文件在 `presets/electron-vue3/template/` 下。

---

- [x] 1. 共享层（src/shared/）
  - [x] 1.1 创建 `src/shared/constants/ipc-channels.ts`
  - [x] 1.2 创建 `src/shared/types/ipc.types.ts`

- [x] 2. 主进程核心层（src/main/core/）
  - [x] 2.1 创建 `src/main/core/logger.ts`
  - [x] 2.2 创建 `src/main/core/error-handler.ts`
  - [x] 2.3 创建 `src/main/core/event-bus.ts`
  - [x] 2.4 创建 `src/main/core/ipc-registry.ts`

- [x] 3. 主进程业务模块（src/main/modules/）
  - [x] 3.1 创建 `src/main/modules/window/`
  - [x] 3.2 创建 `src/main/modules/storage/`
  - [x] 3.3 创建 `src/main/modules/system/`
  - [x] 3.4 创建 `src/main/modules/tray/`

- [x] 4. 主进程启动编排
  - [x] 4.1 创建 `src/main/bootstrap.ts`
  - [x] 4.2 重写 `src/main/index.ts`

- [x] 5. Preload 重建
  - [x] 5.1 重写 `src/preload/index.ts`

- [x] 6. 渲染进程核心层（src/renderer/core/）
  - [x] 6.1 创建 `src/renderer/core/ipc-client.ts`
  - [x] 6.2 创建 `src/renderer/core/error-handler.ts`
  - [x] 6.3 创建 `src/renderer/core/event-bus.ts`

- [x] 7. 渲染进程类型声明
  - [x] 7.1 重写 `src/renderer/env.d.ts`

- [x] 8. Composables（src/renderer/composables/）
  - [x] 8.1 创建 `useTheme.ts`
  - [x] 8.2 创建 `usePlatform.ts`
  - [x] 8.3 创建 `useStorage.ts`
  - [x] 8.4 创建 `useClipboard.ts`
  - [x] 8.5 创建 `useShell.ts`
  - [x] 8.6 创建 `useKeyboard.ts`
  - [x] 8.7 创建 `useDialog.ts`
  - [x] 8.8 创建 `useNotification.ts`

- [x] 9. 自建 UI 组件（src/renderer/components/ui/）
  - [x] 9.1 创建 `GlassCard.vue`
  - [x] 9.2 创建 `PageHeader.vue`
  - [x] 9.3 创建 `StatCard.vue`
  - [x] 9.4 创建 `EmptyState.vue`
  - [x] 9.5 创建 `LoadingOverlay.vue`
  - [x] 9.6 创建 `SettingsPanel.vue` + `SettingsItem.vue`

- [x] 10. 布局组件重建（src/renderer/components/layout/）
  - [x] 10.1 重建 `Sidebar.vue`
  - [x] 10.2 重建 `Topbar.vue`
  - [x] 10.3 更新 `TitleBar.vue`
  - [x] 10.4 AppLayout.vue 保持不变（已是纯 Tailwind）

- [x] 11. Element Plus 按需导入 + 样式覆盖
  - [x] 11.1 更新 `package.json`
  - [x] 11.2 更新 `electron.vite.config.ts`
  - [x] 11.3 创建 `element-override.css`
  - [x] 11.4 更新 `main.ts`

- [x] 12. 页面和 Store 适配
  - [x] 12.1 更新 `stores/app.ts`
  - [x] 12.2 更新 `views/home/index.vue`
  - [x] 12.3 更新 `views/settings/index.vue`
  - [x] 12.4 删除旧文件

- [x] 13. 文档更新
  - [x] 13.1 更新 `PRESET.md`
  - [x] 13.2 更新 `PROJECT_RULES.md`
