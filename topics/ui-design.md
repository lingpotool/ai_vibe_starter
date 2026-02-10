# UI 设计知识库

> AI 在推荐 UI 方案时参考此文件。注意用非技术语言和用户沟通。

## 用户说的感觉 → 对应的设计方向

| 用户可能说的 | 设计方向 | 推荐组件库 |
|-------------|---------|-----------|
| "简洁的""干净的""像苹果" | 极简主义 | shadcn/ui, Radix |
| "专业的""企业级的""正式的" | 企业风格 | Ant Design, MUI |
| "现代的""酷的""有设计感" | 现代风格 | shadcn/ui, NextUI |
| "可爱的""活泼的""年轻的" | 活泼风格 | daisyUI, Chakra UI |
| "像 xxx 网站那样" | 参考竞品 | 根据竞品分析选择 |
| "你来定""好看就行" | 默认推荐 | shadcn/ui（最灵活） |
| "科技感""未来感" | 赛博风格 | 自定义 + Tailwind |
| "复古""怀旧" | 复古风格 | 自定义 CSS |
| "像素风""8-bit" | 像素风格 | 自定义 + 像素字体 |

## 组件库对照表

### React 生态

| 组件库 | 风格 | 特点 | 适合 |
|--------|------|------|------|
| shadcn/ui | 极简、可定制 | 代码复制到项目中，完全可控 | 追求独特设计的项目 |
| Ant Design | 企业级 | 功能最全，中文友好 | 管理后台、企业应用 |
| MUI (Material UI) | Google 风格 | 成熟稳定，组件丰富 | 通用 Web 应用 |
| Chakra UI | 现代、友好 | 开发体验好，主题灵活 | 中小型项目 |
| NextUI | 现代、精美 | 基于 Tailwind，动画好 | 追求视觉效果 |
| Mantine | 全面、实用 | 内置 hooks 和工具 | 功能丰富的应用 |
| Radix UI | 无样式基础 | 无障碍性好，完全可控 | 需要完全自定义 |
| Arco Design | 字节跳动风格 | 功能全面，设计规范 | 企业应用 |

### Vue 生态

| 组件库 | 风格 | 特点 | 适合 |
|--------|------|------|------|
| Element Plus | 企业级 | 中文生态最好 | 管理后台 |
| Vuetify | Material 风格 | 组件丰富 | 通用应用 |
| Naive UI | 现代、轻量 | TypeScript 友好 | 中小型项目 |
| PrimeVue | 多主题 | 主题切换方便 | 需要多套皮肤 |
| Ant Design Vue | 企业级 | Ant Design 的 Vue 版 | 企业应用 |
| Vant | 移动端 | 轻量、移动优先 | 移动端 H5 / 小程序 |
| TDesign | 腾讯风格 | 多端支持 | 企业应用 |

### 小程序 UI

| 组件库 | 适合框架 | 特点 |
|--------|---------|------|
| WeUI | 微信原生 | 微信官方风格，最原生 |
| Vant Weapp | 微信原生 | 功能丰富，移动端体验好 |
| Taro UI | Taro | 跨端组件库 |
| NutUI | Taro / 原生 | 京东出品，移动端优秀 |
| uView | uni-app | uni-app 生态最全 |
| ThorUI | uni-app | 精美，组件丰富 |

### Flutter UI

| 组件库 | 特点 |
|--------|------|
| Material 3 (内置) | Google 风格，默认推荐 |
| Cupertino (内置) | iOS 风格 |
| GetWidget | 1000+ 预构建组件 |
| Flutter Neumorphic | 新拟态风格 |

### React Native UI

| 组件库 | 特点 |
|--------|------|
| React Native Paper | Material Design |
| NativeBase | 跨平台通用组件 |
| Tamagui | 高性能，跨平台 |
| React Native Elements | 简单易用 |
| Gluestack UI | 现代，可定制 |

### 桌面应用 UI

| 框架 | 组件方案 |
|------|---------|
| Electron | 使用 Web 组件库（shadcn/ui, Ant Design 等） |
| Tauri | 使用 Web 组件库 |
| Qt (Python) | Qt Widgets / QML（原生风格） |
| WPF | XAML 控件 / MaterialDesignInXAML |
| SwiftUI | 系统原生控件 |

### 游戏 UI

| 引擎 | UI 方案 |
|------|--------|
| Unity | Unity UI Toolkit / UGUI / TextMeshPro |
| Unreal | UMG (Unreal Motion Graphics) |
| Godot | 内置 Control 节点 |
| Phaser | 自定义 UI / rexUI 插件 |
| Web (Three.js) | HTML overlay / drei |

### 通用 / 跨框架

| 组件库 | 风格 | 特点 |
|--------|------|------|
| daisyUI | 活泼、多彩 | 基于 Tailwind，纯 CSS 类 |
| Headless UI | 无样式 | 只提供逻辑，样式完全自定义 |
| Ark UI | 无样式 | 支持 React/Vue/Solid |
| Park UI | 精美预设 | 基于 Ark UI 的样式预设 |

## 样式方案

| 方案 | 推荐场景 | 搭配 |
|------|---------|------|
| Tailwind CSS | 默认推荐，AI 生成代码最友好 | shadcn/ui, daisyUI, NextUI |
| CSS Modules | 需要样式隔离，传统写法 | 任何组件库 |
| Styled Components | CSS-in-JS 偏好 | MUI, Chakra UI |
| UnoCSS | 追求极致性能和灵活性 | 任何组件库 |
| Sass/SCSS | 传统项目，需要变量和嵌套 | 任何组件库 |
| vanilla-extract | 类型安全的 CSS-in-TS | 任何组件库 |
| StyleX | Meta 出品，编译时 CSS | React 项目 |

## 颜色方案建议

| 行业/类型 | 推荐主色调 | 感觉 |
|-----------|-----------|------|
| 科技/SaaS | 蓝色、紫色 | 专业、信任 |
| 电商 | 橙色、红色 | 活力、促销 |
| 健康/医疗 | 绿色、蓝色 | 安全、自然 |
| 教育 | 蓝色、绿色 | 知识、成长 |
| 金融 | 深蓝、金色 | 稳重、高端 |
| 社交/娱乐 | 多彩、渐变 | 活泼、年轻 |
| 工具/效率 | 灰色、蓝色 | 专注、简洁 |
| 游戏 | 根据游戏主题 | 沉浸感 |
| AI/科技 | 紫色、青色、渐变 | 未来感 |
| 环保/自然 | 绿色、棕色 | 自然、有机 |
| 奢侈品 | 黑色、金色 | 高端、尊贵 |
| 儿童 | 明亮多彩 | 快乐、安全 |

## 图标库推荐

| 图标库 | 特点 | 适合 |
|--------|------|------|
| Lucide | 简洁线条，shadcn 默认 | 极简风格 |
| Heroicons | Tailwind 官方 | Tailwind 项目 |
| Phosphor Icons | 风格多样（线条/填充/双色） | 通用 |
| Ant Design Icons | 企业级 | Ant Design 项目 |
| Material Icons | Google 风格 | MUI 项目 |
| Font Awesome | 最全面 | 通用 |
| Tabler Icons | 开源，数量多 | 通用 |
| iconify | 聚合所有图标库 | 需要多种风格 |

## 动画库推荐

| 库 | 适合场景 |
|----|---------|
| Framer Motion | React 动画，最流行 |
| GSAP | 复杂动画，跨框架 |
| Lottie | 设计师导出的动画 |
| Motion One | 轻量，Web Animations API |
| Auto Animate | 自动过渡动画，零配置 |
| Vue Transition | Vue 内置过渡 |

## 默认推荐组合

当用户没有特别偏好时，推荐：
- **React 项目**: shadcn/ui + Tailwind CSS + Lucide Icons
- **Vue 项目**: Element Plus + Tailwind CSS（管理后台）或 Naive UI + Tailwind CSS（C端）
- **小程序 (Taro)**: NutUI
- **小程序 (uni-app)**: uView
- **React Native**: Tamagui 或 React Native Paper
- **Flutter**: Material 3（内置）
- **桌面 (Electron/Tauri)**: shadcn/ui + Tailwind CSS
- **游戏**: 引擎内置 UI 系统
