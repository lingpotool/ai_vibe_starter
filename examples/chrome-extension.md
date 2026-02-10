# 项目规则

> 示例：一个网页标注和笔记的浏览器扩展

## 项目概述

- **项目名称**: WebNotes
- **项目描述**: 在任何网页上高亮文字、添加笔记，自动同步保存
- **目标用户**: 学生、研究人员
- **目标平台**: Chrome / Edge / Firefox

## 技术选型

- **项目类型**: 浏览器扩展
- **核心框架**: Plasmo + React
- **编程语言**: TypeScript
- **包管理器**: pnpm
- **数据库**: Chrome Storage API (本地) + Supabase (云同步)
- **认证方案**: Supabase Auth

## UI 与设计

- **组件库**: shadcn/ui (popup/options 页面)
- **样式方案**: Tailwind CSS + CSS Modules (content script 隔离)
- **设计风格**: 简洁、不干扰阅读
- **主色调**: 黄色 (#f59e0b，高亮色)
- **暗色模式**: 跟随网页

## 项目结构

```
src/
├── background/
│   ├── index.ts
│   └── sync.ts         # 云同步逻辑
├── content/
│   ├── index.tsx
│   ├── Highlighter.tsx  # 高亮组件
│   ├── NotePopup.tsx    # 笔记弹窗
│   └── styles.module.css
├── popup/
│   ├── index.tsx
│   └── NotesList.tsx
├── options/
│   ├── index.tsx
│   └── Settings.tsx
├── shared/
│   ├── storage.ts       # 存储封装
│   ├── types.ts
│   └── utils.ts
└── assets/
    └── icon.png
```

## 代码规范

- **格式化工具**: Biome
- **命名风格**: 组件 PascalCase，函数 camelCase
- **Git 提交**: Conventional Commits
- **测试策略**: 关键路径测试（存储、同步）
- **测试框架**: Vitest

## 部署

- **部署平台**: Chrome Web Store + Firefox Add-ons + Edge Add-ons
- **环境**: development + production
- **CI/CD**: GitHub Actions（构建 + 打包）
- **发布流程**: 构建 → 打包 zip → 提交各商店审核

## AI 开发规则

1. 使用 Plasmo 框架，遵循其约定
2. Content Script 的样式必须隔离，不能影响宿主页面
3. 使用 Chrome Storage API 做本地存储，不要用 localStorage
4. 跨浏览器兼容：使用 WebExtension API，避免 Chrome 专有 API
5. Manifest V3 规范，使用 Service Worker 而非 Background Page
6. 权限最小化，只申请必要的权限
7. Content Script 注入要轻量，不要拖慢页面
8. 新增依赖前先说明
