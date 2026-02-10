# 技术选型知识库

> AI 在推荐技术方案时参考此文件。根据用户的项目描述，选择最合适的技术组合。

## 项目类型 → 推荐框架

### 网站 / 落地页 / 博客
需要 SEO，内容为主，交互较少。

| 框架 | 适合场景 | 语言 |
|------|---------|------|
| Next.js (App Router) | 功能丰富的网站，需要动态内容 | TypeScript |
| Astro | 内容为主的静态网站，性能极致 | TypeScript |
| Nuxt | Vue 生态偏好 | TypeScript |
| Hugo | 极快的静态站点生成 | Go (模板) |
| 11ty (Eleventy) | 简单灵活的静态站点 | JavaScript |

### Web 应用 / SaaS / 管理后台
交互复杂，不太需要 SEO，类似"软件"的体验。

| 框架 | 适合场景 | 语言 |
|------|---------|------|
| Next.js | 全栈应用，前后端一体 | TypeScript |
| React + Vite | 纯前端应用，后端分离 | TypeScript |
| Vue + Vite | Vue 生态偏好 | TypeScript |
| Nuxt | Vue 全栈应用 | TypeScript |
| SvelteKit | 轻量全栈，编译时优化 | TypeScript |
| Angular | 大型企业应用，强约束 | TypeScript |

### 后端 API / 微服务
只提供接口，没有界面。

| 框架 | 适合场景 | 语言 |
|------|---------|------|
| FastAPI | 快速开发，AI/ML 项目 | Python |
| Express / Fastify | Node.js 生态 | TypeScript |
| Hono | 轻量、边缘计算 | TypeScript |
| NestJS | 企业级 Node.js，强架构 | TypeScript |
| Go + Gin/Echo | 高性能、高并发 | Go |
| Spring Boot | 企业级、Java 生态 | Java/Kotlin |
| Rust + Actix/Axum | 极致性能 | Rust |
| Django / DRF | Python 全功能框架 | Python |
| Ruby on Rails | 快速开发，约定优于配置 | Ruby |
| ASP.NET Core | .NET 生态，企业级 | C# |

### 移动端 App
手机上运行的应用。

| 框架 | 适合场景 | 语言 |
|------|---------|------|
| React Native + Expo | 跨平台，JS 生态 | TypeScript |
| Flutter | 跨平台，UI 精美 | Dart |
| Swift/SwiftUI | 仅 iOS，原生性能 | Swift |
| Kotlin/Jetpack Compose | 仅 Android，原生性能 | Kotlin |
| Ionic + Capacitor | Web 技术做 App | TypeScript |
| .NET MAUI | .NET 跨平台 | C# |

### 命令行工具 (CLI)
终端里运行的工具。

| 框架 | 适合场景 | 语言 |
|------|---------|------|
| Commander.js / oclif | Node.js 生态 | TypeScript |
| Click / Typer | Python 生态 | Python |
| Cobra | Go 生态，编译为单文件 | Go |
| clap | Rust 生态，高性能 | Rust |
| Picocli | Java 生态 | Java/Kotlin |

### 桌面应用
电脑上安装运行的软件。

| 框架 | 适合场景 | 语言 |
|------|---------|------|
| Electron | 跨平台，Web 技术栈，生态成熟 | TypeScript |
| Tauri | 跨平台，轻量，性能好 | Rust + TypeScript |
| Qt (PyQt/PySide) | 跨平台，原生体验 | Python / C++ |
| WPF / WinUI | 仅 Windows | C# |
| SwiftUI | 仅 macOS | Swift |
| JavaFX | 跨平台，Java 生态 | Java/Kotlin |

### 微信小程序 / 跨端小程序

| 框架 | 适合场景 | 语言 |
|------|---------|------|
| 微信原生 | 仅微信，最稳定 | JavaScript/TypeScript |
| Taro | 跨端（微信/支付宝/百度/字节/H5/React Native） | TypeScript (React) |
| uni-app | 跨端，Vue 语法，生态丰富 | TypeScript (Vue) |
| Remax | React 语法写小程序 | TypeScript (React) |

### 游戏开发

| 引擎/框架 | 适合场景 | 语言 |
|-----------|---------|------|
| Unity | 2D/3D 游戏，跨平台，生态最大 | C# |
| Unreal Engine | 3A 级 3D 游戏，画面顶级 | C++ / Blueprint |
| Godot | 开源，轻量，2D 优秀 | GDScript / C# |
| Phaser | Web 2D 游戏 | TypeScript |
| Three.js / R3F | Web 3D 体验/游戏 | TypeScript |
| Pygame | Python 学习/原型 | Python |
| Bevy | Rust 游戏引擎，ECS 架构 | Rust |
| Cocos Creator | 2D/3D，国内生态好 | TypeScript |
| RPG Maker | RPG 游戏，低代码 | JavaScript/Ruby |
| Ren'Py | 视觉小说/文字冒险 | Python |

### AI / 机器学习项目

| 框架/工具 | 适合场景 | 语言 |
|-----------|---------|------|
| PyTorch | 研究、灵活、动态图 | Python |
| TensorFlow / Keras | 生产部署、TPU 支持 | Python |
| Hugging Face Transformers | NLP、预训练模型 | Python |
| LangChain / LlamaIndex | LLM 应用开发 | Python / TypeScript |
| scikit-learn | 传统 ML、数据分析 | Python |
| FastAPI + ML 模型 | 模型服务化 | Python |
| Gradio / Streamlit | 快速搭建 AI Demo | Python |
| MLflow | 实验管理、模型追踪 | Python |
| ONNX Runtime | 模型推理优化 | Python / C++ |

### 嵌入式 / IoT

| 框架/平台 | 适合场景 | 语言 |
|-----------|---------|------|
| Arduino | 入门、原型、传感器 | C/C++ |
| ESP-IDF | ESP32 专业开发 | C |
| MicroPython | Python 写嵌入式 | Python |
| CircuitPython | 教育、快速原型 | Python |
| PlatformIO | 统一嵌入式开发环境 | C/C++ |
| Raspberry Pi + Python | Linux 级 IoT | Python |
| Zephyr RTOS | 专业实时操作系统 | C |
| Rust Embedded | 安全的嵌入式开发 | Rust |
| Node-RED | 可视化 IoT 流程编排 | JavaScript (低代码) |

### 浏览器扩展

| 框架 | 适合场景 | 语言 |
|------|---------|------|
| 原生 WebExtension API | 简单扩展，兼容所有浏览器 | TypeScript |
| Plasmo | 现代浏览器扩展框架，React/Vue/Svelte | TypeScript |
| WXT | 类似 Nuxt 的扩展框架 | TypeScript |
| Chrome Extension + React/Vue | 复杂 UI 的扩展 | TypeScript |

### 库 / SDK / 工具包

| 工具 | 适合场景 | 语言 |
|------|---------|------|
| tsup / unbuild | TypeScript 库打包 | TypeScript |
| Rollup / esbuild | JS 库打包 | TypeScript |
| setuptools / poetry / hatch | Python 包 | Python |
| Cargo | Rust crate | Rust |
| Go modules | Go 包 | Go |
| Maven / Gradle | Java 库 | Java/Kotlin |

### 数据工程

| 框架/工具 | 适合场景 | 语言 |
|-----------|---------|------|
| Apache Airflow | 工作流编排 | Python |
| dbt | 数据转换（SQL 优先） | SQL / Python |
| Pandas / Polars | 数据处理和分析 | Python |
| Apache Spark (PySpark) | 大规模数据处理 | Python / Scala |
| Prefect / Dagster | 现代数据编排 | Python |
| Apache Kafka | 流数据处理 | Java / Python |
| Jupyter Notebook | 探索性分析 | Python |
| Metabase / Superset | 数据可视化 BI | 低代码 |
| DuckDB | 本地分析型数据库 | SQL / Python |

### 区块链 / Web3

| 框架/工具 | 适合场景 | 语言 |
|-----------|---------|------|
| Hardhat | 以太坊智能合约开发 | Solidity + TypeScript |
| Foundry | 高性能合约开发和测试 | Solidity |
| Anchor | Solana 智能合约 | Rust |
| ethers.js / viem | 前端与合约交互 | TypeScript |
| wagmi + RainbowKit | React DApp 前端 | TypeScript |
| The Graph | 链上数据索引 | GraphQL / TypeScript |
| IPFS / Arweave | 去中心化存储 | 任意 |
| OpenZeppelin | 安全的合约模板库 | Solidity |

### 平台插件开发

| 平台 | 框架/工具 | 语言 |
|------|-----------|------|
| VS Code 扩展 | VS Code Extension API | TypeScript |
| Figma 插件 | Figma Plugin API | TypeScript |
| Slack Bot / App | Bolt.js | TypeScript |
| Discord Bot | discord.js / discord.py | TypeScript / Python |
| Shopify App | Shopify CLI + Remix | TypeScript |
| WordPress 插件 | WordPress Plugin API | PHP |
| Obsidian 插件 | Obsidian Plugin API | TypeScript |
| Raycast 扩展 | Raycast API | TypeScript |

### Monorepo 多包项目

| 工具 | 适合场景 |
|------|---------|
| Turborepo | 简单高效，适合大部分场景 |
| Nx | 功能强大，适合大型团队 |
| pnpm workspaces | 轻量，不需要额外工具 |
| Lerna | 老牌方案，npm 包发布 |
| Rush | 微软出品，超大型项目 |

## 数据库选择

| 数据库 | 适合场景 | 配套 ORM / 客户端 |
|--------|---------|-------------------|
| PostgreSQL | 通用首选，功能强大 | Prisma / Drizzle / SQLAlchemy / TypeORM |
| SQLite | 小项目、本地应用、原型、嵌入式 | Prisma / Drizzle / better-sqlite3 |
| MySQL | 传统项目、已有基础设施 | Prisma / Drizzle / SQLAlchemy / Sequelize |
| MongoDB | 文档型数据、灵活 schema | Mongoose / Prisma / Motor |
| Redis | 缓存、会话、消息队列 | ioredis / redis-py |
| Supabase | PostgreSQL + 实时 + 认证，开箱即用 | Supabase Client |
| PlanetScale | 无服务器 MySQL，自动扩展 | Prisma / Drizzle |
| Firebase Firestore | 实时数据库，移动端友好 | Firebase SDK |
| DynamoDB | AWS 生态，无服务器 | AWS SDK / ElectroDB |
| Neo4j | 图数据库，关系复杂的数据 | neo4j-driver |
| InfluxDB | 时序数据，IoT 传感器数据 | influxdb-client |
| Pinecone / Weaviate / Milvus | 向量数据库，AI 语义搜索 | 各自 SDK |
| DuckDB | 本地分析型，OLAP | duckdb SDK |

## 认证方案

| 方案 | 适合场景 | 复杂度 |
|------|---------|--------|
| NextAuth.js (Auth.js) | Next.js 项目，快速集成 | 低 |
| Supabase Auth | 使用 Supabase 的项目 | 低 |
| Clerk | 需要完整用户管理 UI | 低 |
| Firebase Auth | Google 生态、移动端 | 低 |
| Lucia | 轻量，完全控制 | 中 |
| Passport.js | Node.js 传统方案，策略丰富 | 中 |
| 微信登录 SDK | 小程序/公众号 | 中 |
| OAuth 2.0 自建 | 完全自定义需求 | 高 |
| 自建 JWT | 完全自定义需求 | 高 |
| Keycloak | 企业级 SSO | 高 |
| Web3 钱包登录 (SIWE) | DApp 项目 | 中 |

## 包管理器

### JavaScript / TypeScript
| 工具 | 推荐场景 |
|------|---------|
| pnpm | 默认推荐，快速，节省磁盘 |
| npm | 最通用，兼容性最好 |
| yarn | 已有项目在用 |
| bun | 追求极致速度，较新 |

### Python
| 工具 | 推荐场景 |
|------|---------|
| uv | 默认推荐，极快，现代 |
| poetry | 成熟，依赖管理好 |
| pip + venv | 最传统，兼容性最好 |
| conda | 科学计算、ML 项目 |
| pdm | 现代，PEP 标准 |

### 其他语言
| 语言 | 包管理器 |
|------|---------|
| Go | go modules（标准） |
| Rust | cargo（标准） |
| Java | Maven / Gradle |
| C# | NuGet |
| Ruby | Bundler |
| PHP | Composer |
| Dart | pub |
| Swift | Swift Package Manager |
