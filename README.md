# AI Project Bootstrap Protocol (AIPB)

一个通用的 AI 项目启动协议。让任何 AI 编程工具在启动项目前，先和用户对齐技术选型、设计风格和开发规范，然后严格按照约定来开发。

## 解决什么问题

Vibe coding 时代，用户只需要描述想法，AI 来写代码。但 AI 每次启动项目都在"猜"：
- 用什么框架？随机选
- 什么 UI 风格？看心情
- 代码怎么组织？每次不一样
- 换个 AI 工具？之前的约定全丢

AIPB 解决这个问题：**在动手之前，先把规矩定好。**

## 支持的项目类型

- 网站 / 落地页 / 博客
- Web 应用 / SaaS / 管理后台
- 后端 API / 微服务
- 移动端 App（iOS / Android / 跨平台）
- 命令行工具 (CLI)
- 桌面应用（Electron / Tauri / Qt）
- 微信小程序 / 支付宝小程序 / 跨端小程序
- 游戏开发（Unity / Unreal / Godot / Web 游戏）
- AI / 机器学习项目（模型训练、LLM 应用、数据处理）
- 嵌入式 / IoT（Arduino / ESP32 / 树莓派）
- 浏览器扩展（Chrome / Firefox / Edge）
- 库 / SDK / npm 包 / PyPI 包
- 数据工程（ETL、数据管道、数据分析）
- 区块链 / Web3（智能合约、DApp）
- 平台插件（VS Code / Figma / Slack / Discord 等）
- Monorepo 多包项目

## 怎么用

### 1. 启动新项目时

把 `BOOTSTRAP.md` 文件丢给你的 AI 工具（Kiro、Cursor、Copilot、Claude、ChatGPT 等），告诉它：

> 按照 BOOTSTRAP.md 的流程，帮我启动一个新项目。

AI 会引导你完成几轮简单的对话，帮你确定技术选型和开发规范。

### 2. 讨论完成后

AI 会生成一份 `PROJECT_RULES.md` 文件，放在项目根目录。这份文件包含了所有决策。

### 3. 后续开发

任何 AI 工具在开发这个项目时，先读 `PROJECT_RULES.md`，就知道该遵循什么规则。

## 文件说明

```
├── BOOTSTRAP.md              # 项目启动引导流程（给 AI 读的）
├── topics/                   # 各主题的知识库（AI 推荐方案时参考）
│   ├── tech-stack.md         # 技术选型：框架、语言、数据库、认证...
│   ├── ui-design.md          # UI 设计：组件库、样式、颜色、图标、动画...
│   ├── project-structure.md  # 项目结构：20+ 种项目类型的目录模板
│   ├── code-standards.md     # 代码规范：格式化、错误处理、测试、文档...
│   └── deployment.md         # 部署方案：16+ 种项目类型的部署指南
├── templates/
│   └── PROJECT_RULES.md      # 项目规则模板（讨论完后生成）
├── presets/                   # 项目预设（开箱即用的完整代码模板）
│   └── electron-vue3/        # Electron + Vue3 桌面应用预设
│       ├── PRESET.md          # 预设说明
│       ├── PROJECT_RULES.md   # 项目规则
│       └── template/          # 可直接运行的项目代码
└── examples/                 # 已填好的示例
    ├── nextjs-saas.md        # Next.js SaaS 应用
    ├── python-api.md         # Python API 服务
    ├── wechat-miniprogram.md # 微信小程序
    ├── unity-game.md         # Unity 游戏
    ├── ai-llm-app.md        # AI / LLM 应用
    ├── chrome-extension.md   # 浏览器扩展
    ├── iot-smart-home.md     # IoT 智能家居
    ├── npm-library.md        # npm 工具库
    └── web3-dapp.md          # Web3 DApp
```

## 项目预设 (Presets)

除了引导式讨论，AIPB 还提供**开箱即用的项目预设**——完整的可运行代码模板，拉下来改个名字就能跑。

用户看到基础效果后，只需要专注在菜单中每个具体功能的开发。

### 可用预设

| 预设 | 技术栈 | 说明 |
|------|--------|------|
| `electron-vue3` | Electron + Vue3 + Element Plus + Tailwind | 桌面应用，含侧边栏/标签页/暗色模式/自定义标题栏 |

> 更多预设持续添加中...

### 使用预设

1. 复制 `presets/[预设名]/template/` 到你的项目目录
2. 修改 `package.json` 中的项目名称
3. `pnpm install && pnpm dev`
4. 在 `views/` 中添加业务页面，在 `router/modules/` 中注册路由
5. 侧边栏菜单自动生成

每个预设都附带对应的 `PROJECT_RULES.md`，AI 工具读取后就知道该怎么开发。

## 设计原则

- **AI 工具无关** — 纯 Markdown，任何 AI 都能读懂
- **对话驱动** — 不是填表，是和 AI 讨论后产出决策
- **用户不需要懂技术** — AI 负责推荐和解释，用户只需要说感觉
- **一次决策，持续生效** — 生成的规则文件在整个项目生命周期内有效
- **全类型覆盖** — 从网站到嵌入式，从游戏到区块链，都能用
