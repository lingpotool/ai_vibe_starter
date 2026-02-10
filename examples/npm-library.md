# 项目规则

> 示例：一个日期处理工具库

## 项目概述

- **项目名称**: @myorg/datekit
- **项目描述**: 轻量级日期处理库，支持格式化、相对时间、时区转换
- **目标用户**: JavaScript/TypeScript 开发者
- **目标平台**: npm (浏览器 + Node.js)

## 技术选型

- **项目类型**: 库 / npm 包
- **核心框架**: 无框架，纯 TypeScript
- **编程语言**: TypeScript
- **包管理器**: pnpm
- **特殊依赖**: tsup (打包)、changesets (版本管理)

## UI 与设计

不适用（纯逻辑库）。

## 项目结构

```
src/
├── core/
│   ├── format.ts        # 日期格式化
│   ├── relative.ts      # 相对时间（3分钟前）
│   ├── timezone.ts      # 时区转换
│   └── parse.ts         # 日期解析
├── utils/
│   └── constants.ts
├── types/
│   └── index.ts
└── index.ts             # 公共 API 导出
tests/
├── format.test.ts
├── relative.test.ts
├── timezone.test.ts
└── parse.test.ts
docs/                    # 文档
examples/                # 使用示例
├── node-example.ts
└── browser-example.html
```

## 代码规范

- **格式化工具**: Biome
- **命名风格**: camelCase 函数，PascalCase 类型
- **Git 提交**: Conventional Commits
- **测试策略**: 全面测试（所有公共 API）
- **测试框架**: Vitest
- **文档要求**: TSDoc 注释 + README API 文档

## 部署

- **部署平台**: npm (npmjs.com)
- **环境**: 无（库不需要环境）
- **CI/CD**: GitHub Actions（测试 + 构建 + 发布）
- **发布流程**: changeset version → changeset publish

## AI 开发规则

1. 零依赖，不引入任何第三方包
2. 同时支持 ESM 和 CJS 导出
3. 所有公共函数必须有 TSDoc 注释
4. 所有公共函数必须有对应的测试
5. 导出类型定义 (.d.ts)
6. 包体积尽量小，支持 tree-shaking
7. 兼容 Node.js 18+ 和现代浏览器
8. 不要使用 any 类型
9. 每个新功能都要更新 README 的 API 文档
