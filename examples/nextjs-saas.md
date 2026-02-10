# 项目规则

> 示例：一个 SaaS 订阅管理平台

## 项目概述

- **项目名称**: SubManager
- **项目描述**: 帮助用户管理所有订阅服务的平台，追踪费用和续费提醒
- **目标用户**: 个人用户，管理 Netflix、Spotify 等各种订阅

## 技术选型

- **项目类型**: Web应用
- **核心框架**: Next.js 14 (App Router)
- **编程语言**: TypeScript
- **包管理器**: pnpm
- **数据库**: PostgreSQL + Prisma
- **认证方案**: NextAuth.js (Auth.js)

## UI 与设计

- **组件库**: shadcn/ui
- **样式方案**: Tailwind CSS
- **设计风格**: 简约现代
- **主色调**: 蓝紫色 (#6366f1)
- **暗色模式**: 是
- **响应式**: 是

## 项目结构

```
src/
├── app/
│   ├── (auth)/           # 登录注册页面
│   ├── (dashboard)/      # 应用主体
│   │   ├── layout.tsx
│   │   ├── page.tsx      # 仪表盘首页
│   │   ├── subscriptions/
│   │   └── settings/
│   ├── api/
│   └── layout.tsx
├── components/
│   ├── ui/               # shadcn/ui 组件
│   ├── dashboard/        # 仪表盘组件
│   └── subscription/     # 订阅相关组件
├── lib/
│   ├── db.ts             # Prisma 客户端
│   ├── auth.ts           # 认证配置
│   └── utils.ts
├── hooks/
└── types/
```

## 代码规范

- **格式化工具**: Biome
- **命名风格**: 组件 PascalCase，函数/变量 camelCase，文件跟内容一致
- **Git 提交**: Conventional Commits
- **测试策略**: 关键路径测试（认证流程、订阅 CRUD）
- **测试框架**: Vitest + Testing Library

## 部署

- **部署平台**: Vercel
- **环境**: development + production
- **CI/CD**: Vercel 自动部署 + GitHub Actions（lint + 类型检查）

## AI 开发规则

1. 严格使用指定技术栈，不要引入未列出的框架或库
2. 遵循项目结构，新文件放在正确的目录下
3. 遵循命名规范，保持代码风格一致
4. 遵循设计风格，UI 组件使用 shadcn/ui + Tailwind
5. 最小化代码，不要过度抽象，不要生成不需要的文件
6. 不要自作主张添加功能，只实现用户明确要求的
7. 环境变量使用 `.env.local`，并更新 `.env.example`
8. 错误处理统一封装，不要每个地方各写各的
9. 新增依赖前先说明，不要静默安装新包
10. 所有价格相关计算使用分（cent）为单位，避免浮点数问题
