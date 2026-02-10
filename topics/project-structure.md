# 项目结构知识库

> AI 在推荐项目结构时参考此文件。

## 目录组织策略

### 按功能模块（Feature-based）— 推荐

每个功能是一个独立文件夹，包含自己的组件、逻辑、类型。

```
src/
├── features/
│   ├── auth/
│   │   ├── components/
│   │   ├── hooks/
│   │   ├── api.ts
│   │   └── types.ts
│   ├── dashboard/
│   │   ├── components/
│   │   ├── hooks/
│   │   └── types.ts
│   └── settings/
├── shared/            # 跨功能共享
│   ├── components/    # 通用组件（Button, Modal...）
│   ├── hooks/
│   ├── utils/
│   └── types/
├── lib/               # 第三方库封装
└── config/            # 配置文件
```

适合：中大型项目，多人协作，功能边界清晰。

### 按技术层级（Layer-based）

按组件、hooks、utils 等技术类型分文件夹。

```
src/
├── components/
│   ├── ui/           # 基础 UI 组件
│   ├── layout/       # 布局组件
│   └── forms/        # 表单组件
├── hooks/
├── utils/
├── types/
├── api/
└── config/
```

适合：小型项目，功能简单，一个人开发。

### Next.js App Router 推荐结构

```
src/
├── app/                    # 路由和页面
│   ├── (marketing)/        # 营销页面组
│   │   ├── page.tsx
│   │   └── about/
│   ├── (dashboard)/        # 应用页面组
│   │   ├── layout.tsx
│   │   └── settings/
│   ├── api/                # API 路由
│   └── layout.tsx
├── components/
│   ├── ui/                 # shadcn/ui 组件
│   └── [feature]/          # 功能组件
├── lib/                    # 工具函数、数据库客户端
├── hooks/
└── types/
```

### Python API 推荐结构

```
src/
├── api/
│   ├── routes/
│   ├── models/
│   ├── schemas/
│   └── services/
├── core/
│   ├── config.py
│   ├── database.py
│   └── security.py
├── utils/
└── tests/
```

## 命名规范

### 文件命名

| 类型 | 风格 | 示例 |
|------|------|------|
| React 组件 | PascalCase | `UserProfile.tsx` |
| Vue 组件 | PascalCase | `UserProfile.vue` |
| 工具函数/hooks | camelCase | `useAuth.ts`, `formatDate.ts` |
| 样式文件 | 跟组件同名 | `UserProfile.module.css` |
| 常量/配置 | camelCase 或 kebab-case | `apiConfig.ts` |
| Python 文件 | snake_case | `user_profile.py` |

### 变量命名

| 语言 | 变量/函数 | 类/组件 | 常量 |
|------|----------|--------|------|
| TypeScript | camelCase | PascalCase | UPPER_SNAKE_CASE |
| Python | snake_case | PascalCase | UPPER_SNAKE_CASE |
| Go | camelCase | PascalCase | PascalCase |

## 默认推荐

- 小项目（< 10 个页面）：按技术层级
- 中大型项目：按功能模块
- 始终保留 `shared/` 或 `lib/` 放公共代码
