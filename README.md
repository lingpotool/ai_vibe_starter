# AI Vibe Starter — AI 驱动的项目模板集合

一套经过精心设计的跨平台应用模板，拥有完整的设计令牌系统、毛玻璃视觉风格和企业级基础设施。
拉取即用，配合任何 AI 编码工具（Kiro、Cursor、Copilot、Claude 等）直接开发业务功能。

## 可用模板

| 模板 | 技术栈 | 平台 | 说明 |
|------|--------|------|------|
| [`test-app2`](#electron-vue3-桌面端) | Electron + Vue3 + Tailwind v4 | Windows / macOS / Linux | 桌面应用，NavRail + 玻璃态 + 暗色模式 |
| [`test_app3`](#flutter-桌面端) | Flutter + Riverpod + GoRouter | Windows / macOS / Linux | 桌面应用，NavRail + 玻璃态 + 系统托盘 |
| [`mobile_app`](#flutter-移动端) | Flutter + Riverpod + GoRouter | Android / iOS | 移动应用，底部导航 + 玻璃态 |

> `creatorino/` 是基于 mobile_app 模板创建的独立项目实例，可作为参考。

## 每个模板都包含什么

所有模板共享统一的设计语言和基础设施：

**设计令牌系统（禁止硬编码）**
- 色彩系统 — 亮/暗双主题，oklch 色彩空间
- 排版系统 — Noto Sans SC + Inter + JetBrains Mono，7级字号阶梯
- 间距系统 — 4dp/4px 网格，9级阶梯
- 圆角系统 — 6级层级
- 动效系统 — 4级时长 + 标准曲线
- 阴影系统 — 3级层级，亮暗适配
- 交互区域 — 平台适配的最小点击/触控目标

**基础设施**
- 结构化日志（dev→控制台，release→文件）
- 全局错误处理
- 事件总线
- 键值存储
- 国际化（中/英）
- 路由 + 导航

**视觉风格**
- 毛玻璃/玻璃态（Glassmorphism）
- 多层径向渐变背景
- macOS 级别的视觉质感

## 如何使用

### 1. 拉取项目

```bash
git clone https://github.com/lingpotool/ai_vibe_starter.git
```

### 2. 选择模板，复制到你的项目目录

```bash
# 例如：基于 Flutter 移动端模板创建新项目
cp -r ai_vibe_starter/mobile_app  my_new_app

# 或者基于 Electron Vue3 桌面端模板
cp -r ai_vibe_starter/test-app2  my_desktop_app

# 或者基于 Flutter 桌面端模板
cp -r ai_vibe_starter/test_app3  my_desktop_app
```

### 3. 修改项目名称和包名

根据模板类型修改对应的配置文件（`pubspec.yaml` / `package.json`、Android/iOS 配置等）。

### 4. 安装依赖并运行

```bash
# Flutter 模板
flutter pub get
flutter run

# Electron Vue3 模板
pnpm install
pnpm dev
```

### 5. 让 AI 读取 ARCHITECTURE.md 开始开发

每个模板根目录都有 `ARCHITECTURE.md`，这是 AI 助手的上下文文件。
让 AI 读取后，它就知道项目的架构、规范、设计令牌、跨平台要求，可以直接在 `features/`（或 `views/`）下添加业务功能。

```
# 告诉你的 AI 工具：
读取 ARCHITECTURE.md，然后帮我开发 XXX 功能。
```

---

## 模板详情

### Electron Vue3 桌面端

`test-app2/` — Electron + Vue 3 + Tailwind CSS v4

- 三平台：Windows / macOS / Linux
- NavRail 56px 侧边栏 + 玻璃态
- 系统级窗口模糊（macOS vibrancy / Windows Mica）
- 自定义标题栏（平台自适应）
- 系统托盘
- IPC 三进程架构（Main / Preload / Renderer）
- Pinia 状态管理 + 持久化
- vue-i18n 国际化
- 设计令牌：CSS 自定义属性（`theme.css`）

```bash
cd test-app2
pnpm install
pnpm dev
```

### Flutter 桌面端

`test_app3/` — Flutter + Riverpod 3.x + GoRouter

- 三平台：Windows / macOS / Linux
- NavRail 56px 侧边栏 + 玻璃态
- 自定义标题栏 + 窗口控制按钮
- 系统托盘
- 圆形揭示主题切换动画
- 184 个测试（含属性测试）
- 设计令牌：Dart 静态类（`app_typography.dart` 等）

```bash
cd test_app3
flutter pub get
flutter run -d windows   # 或 macos / linux
```

### Flutter 移动端

`mobile_app/` — Flutter + Riverpod 3.x + GoRouter

- 双平台：Android / iOS
- 底部导航 + 毛玻璃
- SafeArea + 状态栏适配
- 与桌面端共享设计语言
- 设计令牌：Dart 静态类（与桌面端一致的 API，移动端适配的值）

```bash
cd mobile_app
flutter pub get
flutter run
```

---

## 项目结构

```
ai_vibe_starter/
├── test-app2/          # Electron Vue3 桌面端模板
├── test_app3/          # Flutter 桌面端模板
├── mobile_app/         # Flutter 移动端模板
├── creatorino/         # 独立项目实例（基于 mobile_app）
├── presets/            # [暂停] 提示词驱动的项目预设
├── topics/             # [暂停] 技术选型知识库
├── examples/           # [暂停] 项目规则示例
├── templates/          # [暂停] 规则模板
└── BOOTSTRAP.md        # [暂停] 提示词启动协议
```

> 标记 `[暂停]` 的是早期的提示词驱动方案（通过 AI 对话生成项目规则）。
> 当前推荐直接使用上面的模板，拉取即用。

## 设计理念

- **拉取即用** — 不需要通过提示词生成，直接复制模板开始开发
- **AI 友好** — 每个模板都有 `ARCHITECTURE.md`，AI 读取后即可理解全貌
- **跨平台优先** — 每个模板都强制要求多平台一致性
- **设计令牌驱动** — 所有视觉参数从令牌引用，禁止硬编码
- **毛玻璃统一风格** — 所有模板共享 macOS 级别的玻璃态视觉语言
