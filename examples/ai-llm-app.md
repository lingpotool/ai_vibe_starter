# 项目规则

> 示例：一个基于 LLM 的智能文档问答系统

## 项目概述

- **项目名称**: DocChat
- **项目描述**: 上传文档后可以用自然语言提问，AI 基于文档内容回答
- **目标用户**: 企业内部知识管理
- **目标平台**: Web

## 技术选型

- **项目类型**: AI 应用 (全栈)
- **核心框架**: Next.js (前端) + FastAPI (后端)
- **编程语言**: TypeScript (前端) + Python (后端)
- **包管理器**: pnpm (前端) + uv (后端)
- **数据库**: PostgreSQL (元数据) + Pinecone (向量存储)
- **认证方案**: NextAuth.js
- **特殊依赖**: LangChain、OpenAI API、Unstructured (文档解析)

## UI 与设计

- **组件库**: shadcn/ui
- **样式方案**: Tailwind CSS
- **设计风格**: 简约专业
- **主色调**: 深蓝 (#1e40af)
- **图标库**: Lucide
- **暗色模式**: 是
- **响应式**: 是

## 项目结构

```
frontend/
├── src/
│   ├── app/
│   │   ├── (auth)/
│   │   ├── (dashboard)/
│   │   │   ├── chat/
│   │   │   ├── documents/
│   │   │   └── settings/
│   │   └── api/
│   ├── components/
│   │   ├── ui/
│   │   ├── chat/
│   │   └── document/
│   ├── lib/
│   ├── hooks/
│   └── types/

backend/
├── src/
│   ├── api/
│   │   └── routes/
│   ├── chains/          # LangChain 链
│   ├── document/        # 文档处理
│   │   ├── loader.py
│   │   ├── splitter.py
│   │   └── embedder.py
│   ├── vectorstore/     # 向量存储
│   ├── models/
│   ├── schemas/
│   ├── core/
│   └── utils/
```

## 代码规范

- **格式化工具**: Biome (前端) + Ruff (后端)
- **命名风格**: 前端 camelCase，后端 snake_case
- **Git 提交**: Conventional Commits
- **测试策略**: 关键路径测试（文档解析、问答链）
- **测试框架**: Vitest (前端) + pytest (后端)

## 部署

- **部署平台**: Vercel (前端) + Railway (后端)
- **环境**: development + production
- **CI/CD**: GitHub Actions（lint + 测试 + 部署）

## AI 开发规则

1. 前端用 Next.js + shadcn/ui，后端用 FastAPI + LangChain
2. LLM 调用统一通过 LangChain，不要直接调用 OpenAI API
3. API Key 等敏感信息只放在后端，前端不能直接访问
4. 文档处理要支持 PDF、Word、Markdown 格式
5. 向量搜索结果要附带来源引用（哪个文档的哪一段）
6. 聊天界面支持流式输出 (SSE)
7. 大文件上传使用分片上传
8. 错误处理：LLM 超时、文档解析失败都要有友好提示
9. 新增依赖前先说明
