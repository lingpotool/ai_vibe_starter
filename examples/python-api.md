# 项目规则

> 示例：一个内容管理 API 服务

## 项目概述

- **项目名称**: ContentHub API
- **项目描述**: 为多个前端应用提供统一的内容管理接口
- **目标用户**: 前端开发团队

## 技术选型

- **项目类型**: 后端 API
- **核心框架**: FastAPI
- **编程语言**: Python 3.12
- **包管理器**: uv
- **数据库**: PostgreSQL + SQLAlchemy
- **认证方案**: JWT (python-jose)

## UI 与设计

不适用（纯 API 服务）。API 文档使用 FastAPI 自带的 Swagger UI。

## 项目结构

```
src/
├── api/
│   ├── routes/
│   │   ├── auth.py
│   │   ├── articles.py
│   │   ├── categories.py
│   │   └── media.py
│   ├── dependencies.py
│   └── middleware.py
├── models/              # SQLAlchemy 模型
├── schemas/             # Pydantic 模型
├── services/            # 业务逻辑
├── core/
│   ├── config.py        # 配置管理
│   ├── database.py      # 数据库连接
│   └── security.py      # 认证相关
├── utils/
├── tests/
└── main.py
```

## 代码规范

- **格式化工具**: Ruff
- **命名风格**: snake_case（函数/变量），PascalCase（类）
- **Git 提交**: Conventional Commits
- **测试策略**: 全面测试（所有 API 端点）
- **测试框架**: pytest + httpx

## 部署

- **部署平台**: Docker + Railway
- **环境**: development + staging + production
- **CI/CD**: GitHub Actions（测试 + Docker 构建 + 部署）

## AI 开发规则

1. 严格使用指定技术栈，不要引入未列出的框架或库
2. 遵循项目结构，新文件放在正确的目录下
3. 所有 API 端点必须有 Pydantic schema 验证
4. 业务逻辑放在 services 层，routes 只做请求处理
5. 数据库操作使用 async，不要用同步方式
6. 所有端点必须有适当的错误处理和 HTTP 状态码
7. 环境变量通过 pydantic-settings 管理
8. 新增依赖前先说明，不要静默安装新包
9. 每个新端点必须附带测试
