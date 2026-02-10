# 项目规则

> Electron + Vue3 桌面应用（企业级架构）。所有 AI 编程工具在参与本项目开发时，必须遵循以下规则。

## 项目概述

- **项目名称**: [由用户创建时指定]
- **项目描述**: 基于 Electron + Vue3 的桌面应用
- **目标平台**: Windows / macOS / Linux
- **架构**: 企业级分层架构（shared → main/core + modules → preload → renderer/core + composables）

## 技术选型

- **核心框架**: Electron + Vue 3 (Composition API + script setup)
- **构建工具**: electron-vite
- **编程语言**: TypeScript（严格模式）
- **包管理器**: pnpm
- **UI 组件库**: Element Plus（按需导入，仅用于功能组件）
- **样式方案**: Tailwind CSS + CSS 变量主题系统
- **状态管理**: Pinia（带持久化）
- **路由**: Vue Router

## 架构规则

### IPC 通信
1. 所有 IPC channel 名称必须在 `src/shared/constants/ipc-channels.ts` 中定义
2. 所有 IPC 类型必须在 `src/shared/types/ipc.types.ts` 中定义
3. 渲染进程不直接调用 `window.api`，通过 composables 或 `core/ipc-client.ts` 调用
4. 主进程 handler 通过 `core/ipc-registry.ts` 的 `registerHandler`/`registerListener` 注册

### 主进程模块
5. 新功能以模块形式添加到 `src/main/modules/[模块名]/`
6. 每个模块导出 `register()` 和可选的 `init()` 函数
7. 在 `core/ipc-registry.ts` 中注册新模块

### 渲染进程
8. 常用功能封装为 composable 放在 `src/renderer/composables/`
9. 布局组件（layout/）不使用 Element Plus，全部 Tailwind 自建
10. Element Plus 仅用于功能组件：Form、Table、Dialog、Select、Switch、DatePicker、Pagination

## UI 与设计

- **布局组件**: 自建（Tailwind CSS），Mac 级视觉质感
- **功能组件**: Element Plus（按需导入，深度样式定制）
- **设计风格**: macOS 应用级别的精致感
- **暗色模式**: 支持亮色/暗色切换
- **主题**: CSS 变量驱动，改 `theme.css` 即可换色

## 代码规范

- **格式化工具**: ESLint + Prettier
- **命名风格**: 组件 PascalCase，文件 PascalCase.vue，函数 camelCase
- **Git 提交**: Conventional Commits
- **Vue 风格**: Composition API + `<script setup lang="ts">`

## AI 开发规则

1. **新页面**放在 `src/renderer/views/[功能名]/index.vue`
2. **新路由**放在 `src/renderer/router/modules/` 下，菜单自动生成
3. **新主进程功能**按模块添加到 `src/main/modules/`，同时更新 shared 层类型和 preload
4. **使用 composables** 调用主进程功能，不直接操作 `window.api`
5. **布局组件用 Tailwind**，功能组件用 Element Plus
6. **状态管理**用 Pinia，不要用 provide/inject 做全局状态
7. **不要修改 core/ 目录**，除非用户明确要求
8. **不要修改布局组件**（layout/），除非用户明确要求改布局
9. **不要修改主题配置**，除非用户明确要求
10. **新增依赖前先说明**
11. **TypeScript 严格模式**，不要用 any
