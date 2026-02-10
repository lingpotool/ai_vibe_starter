# 项目规则

> 示例：一个外卖点餐微信小程序

## 项目概述

- **项目名称**: 快点外卖
- **项目描述**: 校园外卖点餐小程序，支持浏览菜单、下单、支付和订单追踪
- **目标用户**: 大学生
- **目标平台**: 微信小程序

## 技术选型

- **项目类型**: 微信小程序
- **核心框架**: Taro 3 (React)
- **编程语言**: TypeScript
- **包管理器**: pnpm
- **数据库**: 微信云开发 (CloudBase)
- **认证方案**: 微信登录

## UI 与设计

- **组件库**: NutUI
- **样式方案**: Sass + NutUI 主题定制
- **设计风格**: 活泼、年轻
- **主色调**: 橙色 (#FF6B35)
- **暗色模式**: 否
- **响应式**: 否（小程序固定宽度）

## 项目结构

```
src/
├── pages/
│   ├── index/          # 首页（菜单浏览）
│   ├── category/       # 分类页
│   ├── cart/           # 购物车
│   ├── order/          # 订单页
│   └── profile/        # 个人中心
├── components/
│   ├── FoodCard/
│   ├── CartBar/
│   └── OrderStatus/
├── hooks/
├── api/
├── stores/
├── utils/
├── assets/
├── app.config.ts
└── app.tsx
```

## 代码规范

- **格式化工具**: ESLint + Prettier
- **命名风格**: 组件 PascalCase，函数 camelCase
- **Git 提交**: Conventional Commits
- **测试策略**: 不写测试（MVP 阶段）

## 部署

- **部署平台**: 微信云开发 + 微信公众平台
- **环境**: development + production
- **CI/CD**: 无（手动上传）
- **发布流程**: 开发者工具上传 → 提交审核 → 发布

## AI 开发规则

1. 严格使用 Taro + NutUI，不要引入其他组件库
2. 遵循小程序包大小限制（主包 2MB，分包 2MB）
3. 图片资源使用云存储 CDN，不要放在本地
4. 使用微信云开发 API，不要自建后端
5. 页面路径必须在 app.config.ts 中注册
6. 注意小程序的 API 限制（如不支持 DOM 操作）
7. 支付功能使用微信支付 API
8. 新增依赖前先说明
