# 部署方案知识库

> AI 在推荐部署方案时参考此文件。优先推荐最简单的方案。

## 项目类型 → 推荐部署

### 静态网站 / 前端应用

| 平台 | 特点 | 免费额度 |
|------|------|---------|
| Vercel | 最简单，Git 推送自动部署 | 慷慨 |
| Netlify | 类似 Vercel，表单功能好 | 慷慨 |
| Cloudflare Pages | 速度快，全球 CDN | 慷慨 |
| GitHub Pages | 最简单的静态托管 | 免费 |

### Next.js / Nuxt / SvelteKit 全栈应用

| 平台 | 特点 |
|------|------|
| Vercel | Next.js 官方平台，零配置 |
| Netlify | 支持好，配置简单 |
| Cloudflare Workers | 边缘部署，速度快 |
| AWS Amplify | AWS 生态集成 |
| Docker + 任意云 | 完全控制 |

### 后端 API

| 平台 | 特点 | 适合 |
|------|------|------|
| Railway | 最简单，支持多种语言 | 快速上线 |
| Fly.io | 全球部署，Docker 支持 | 需要低延迟 |
| Render | 简单，免费层 | 小项目 |
| AWS Lambda / API Gateway | 按调用计费 | 流量不稳定 |
| Google Cloud Run | 容器化，按需扩展 | 容器化项目 |
| Azure App Service | .NET 项目首选 | 企业级 |
| Docker + VPS | 完全控制 | 有运维能力 |
| Kubernetes | 大规模微服务 | 企业级 |

### 移动端 App

| 平台 | 用途 |
|------|------|
| Expo EAS | React Native 构建和分发 |
| Codemagic | Flutter CI/CD |
| Fastlane | iOS/Android 自动化发布 |
| App Store Connect | iOS 正式发布 |
| Google Play Console | Android 正式发布 |
| TestFlight | iOS 测试分发 |
| Firebase App Distribution | 跨平台测试分发 |

### 微信小程序 / 跨端小程序

| 平台 | 用途 |
|------|------|
| 微信开发者工具 | 上传代码、提交审核 |
| 微信公众平台 | 管理、发布、数据分析 |
| 支付宝开放平台 | 支付宝小程序发布 |
| 字节跳动开放平台 | 抖音/头条小程序发布 |
| 云开发 (CloudBase) | 小程序后端（腾讯云） |

小程序发布流程：
1. 本地开发 → 开发者工具预览
2. 上传代码到平台
3. 提交审核（通常 1-3 天）
4. 审核通过后发布

### 桌面应用

| 工具 | 用途 |
|------|------|
| electron-builder | Electron 打包和分发 |
| Tauri bundler | Tauri 打包 |
| GitHub Releases | 分发安装包 |
| Microsoft Store | Windows 应用商店 |
| Mac App Store | macOS 应用商店 |
| Snap / Flatpak / AppImage | Linux 分发 |
| 自动更新 (electron-updater / Tauri updater) | 应用内更新 |

### 浏览器扩展

| 平台 | 用途 |
|------|------|
| Chrome Web Store | Chrome 扩展发布 |
| Firefox Add-ons (AMO) | Firefox 扩展发布 |
| Microsoft Edge Add-ons | Edge 扩展发布 |

扩展发布流程：
1. 打包为 .zip / .crx
2. 提交到各浏览器商店
3. 审核（Chrome 通常 1-3 天）
4. 自动分发给用户

### 库 / SDK / 工具包

| 平台 | 用途 |
|------|------|
| npm / npmjs.com | JavaScript/TypeScript 包 |
| PyPI | Python 包 |
| crates.io | Rust crate |
| Maven Central | Java 库 |
| NuGet | .NET 包 |
| RubyGems | Ruby gem |
| pub.dev | Dart/Flutter 包 |
| Go Proxy | Go 模块 |
| GitHub Packages | 多语言私有包 |

发布流程：
1. 版本号管理（语义化版本 semver）
2. 构建和打包
3. 发布到 registry
4. 更新 CHANGELOG

### 游戏

| 平台 | 用途 |
|------|------|
| Steam (Steamworks) | PC 游戏发布 |
| itch.io | 独立游戏发布，门槛低 |
| Epic Games Store | PC 游戏 |
| App Store / Google Play | 手机游戏 |
| Web (itch.io / Newgrounds) | Web 游戏 |
| Unity Cloud Build | Unity 自动构建 |
| GameCI | GitHub Actions 游戏 CI |

### AI / ML 项目

| 平台 | 用途 |
|------|------|
| Hugging Face Spaces | 模型 Demo 托管 |
| Hugging Face Hub | 模型和数据集发布 |
| Gradio / Streamlit Cloud | AI Demo 部署 |
| AWS SageMaker | 模型训练和部署 |
| Google Vertex AI | 模型训练和部署 |
| Modal / Replicate | GPU 推理服务 |
| BentoML | 模型服务化 |
| MLflow | 模型管理和部署 |
| Docker + GPU 服务器 | 自建推理服务 |

### 数据工程

| 平台 | 用途 |
|------|------|
| Astronomer / MWAA | 托管 Airflow |
| dbt Cloud | 托管 dbt |
| Databricks | 统一数据平台 |
| Snowflake | 云数据仓库 |
| Google BigQuery | 无服务器数据仓库 |
| Docker + Airflow | 自建编排 |

### 区块链 / Web3

| 平台 | 用途 |
|------|------|
| Ethereum Mainnet | 以太坊主网部署 |
| Polygon / Arbitrum / Optimism | L2 低成本部署 |
| Solana Mainnet | Solana 部署 |
| Testnet (Sepolia/Goerli) | 测试网部署 |
| Vercel / Netlify | DApp 前端 |
| IPFS / Arweave | 去中心化前端托管 |
| The Graph (hosted/decentralized) | 子图部署 |
| Alchemy / Infura | RPC 节点服务 |

### 嵌入式 / IoT

| 方式 | 用途 |
|------|------|
| USB / 串口烧录 | 直接烧录固件 |
| OTA (Over-The-Air) | 远程固件更新 |
| PlatformIO Upload | 一键烧录 |
| AWS IoT Core | 设备管理和通信 |
| Azure IoT Hub | 设备管理和通信 |
| MQTT Broker (Mosquitto) | 轻量消息通信 |

### 平台插件

| 插件类型 | 发布方式 |
|---------|---------|
| VS Code 扩展 | VS Code Marketplace (vsce publish) |
| Figma 插件 | Figma Community |
| Slack App | Slack App Directory |
| Discord Bot | 自托管 / Railway |
| Shopify App | Shopify App Store |
| WordPress 插件 | WordPress.org Plugin Directory |
| Obsidian 插件 | Obsidian Community Plugins |
| Raycast 扩展 | Raycast Store |

## 环境管理

推荐至少两个环境：
- **开发环境 (development)**: 本地开发
- **生产环境 (production)**: 线上服务

中大型项目增加：
- **预发布环境 (staging)**: 上线前验证
- **测试环境 (testing)**: 自动化测试专用

### 环境变量管理

```
.env.local          # 本地开发（不提交到 Git）
.env.example        # 环境变量模板（提交到 Git，不含真实值）
```

线上环境变量通过部署平台的控制台管理。

特殊项目的环境管理：
- **小程序**: 通过开发者工具切换环境
- **移动端**: 通过构建变体 (Build Variants) 区分
- **嵌入式**: 通过编译宏 (#define) 区分
- **智能合约**: 通过网络配置区分（mainnet/testnet）

## CI/CD

### 简单项目
不需要 CI/CD，用部署平台的自动部署（Git push 触发）。

### 中型项目
GitHub Actions 基础流水线：
- push 时自动运行 lint + 类型检查
- main 分支自动部署

### 大型项目
完整流水线：
- PR 时运行测试
- 代码审查通过后合并
- main 分支自动部署到 staging
- 手动确认后部署到 production

### CI/CD 工具

| 工具 | 适合场景 |
|------|---------|
| GitHub Actions | 默认推荐，GitHub 项目 |
| GitLab CI | GitLab 项目 |
| CircleCI | 复杂流水线 |
| Jenkins | 自建，完全控制 |
| Bitbucket Pipelines | Bitbucket 项目 |

## 默认推荐

- 前端/全栈 Web：Vercel（最省心）
- 后端 API：Railway（最简单）
- 移动端：Expo EAS (RN) / Codemagic (Flutter)
- 小程序：云开发 + 平台审核发布
- 桌面应用：GitHub Releases + 自动更新
- 库/SDK：对应语言的 registry
- 游戏：itch.io（独立）/ Steam（商业）
- AI/ML：Hugging Face Spaces（Demo）
- 不需要 CI/CD 就不配，用平台自带的
- `.env.example` 必须有
