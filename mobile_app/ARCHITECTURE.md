# Flutter 移动端企业级模板 — AI 开发指南

> 本文档是 AI 助手的上下文加载文件。
> 与桌面端 (test_app3) 共享相同的设计语言、色彩系统、玻璃态组件。
> **核心原则：本项目是 Android + iOS 双平台应用，所有功能必须同时在两个平台上正常运行。**

---

## 一、项目定位

Flutter 移动应用企业级模板（**iOS / Android**），提供与桌面端一致的毛玻璃视觉风格。
核心基础设施已就绪：日志、错误处理、事件总线、键值存储、路由、UI 组件库。
开发者只需在 `features/` 下添加业务功能。

**跨平台是本项目的第一优先级。** 任何功能、任何代码变更都必须确保 Android 和 iOS 双平台可用。
不存在"先做一个平台再适配另一个"的情况 — 每次提交都必须是双平台完整可用的。

---

## 一.五、跨平台开发规范（最重要）

### 核心原则

每开发一个功能，必须按以下清单逐项检查：

| 检查项 | 说明 |
|--------|------|
| **UI 适配** | SafeArea、刘海屏、圆角屏、折叠屏、不同屏幕尺寸 |
| **交互差异** | iOS 滑动返回（Cupertino 手势）、Android 系统返回键 |
| **系统 API** | 相机、相册、文件、通知、权限等必须双平台测试 |
| **原生插件** | 引入任何插件前检查其 platform support（pubspec 中 android + ios 都有） |
| **字体渲染** | Android 和 iOS 的字体渲染引擎不同，需实机确认视觉效果 |
| **状态栏/导航栏** | Android 有系统导航栏（底部），iOS 有 Home Indicator |
| **键盘行为** | Android 键盘弹出时 resize，iOS 键盘覆盖 — 需要 `MediaQuery.viewInsets` |
| **权限模型** | Android 运行时权限 vs iOS Info.plist 声明，流程不同 |
| **文件路径** | 使用 `path_provider`，不要硬编码路径分隔符 |
| **深色模式** | 两个平台的系统深色模式切换行为不同，需测试 |

### 平台差异处理模式

```dart
// ✅ 正确：使用 Flutter 内置的平台判断
import 'dart:io' show Platform;

if (Platform.isIOS) {
  // iOS 特有逻辑
} else if (Platform.isAndroid) {
  // Android 特有逻辑
}

// ❌ 禁止：只考虑一个平台
// 禁止写 Android-only 或 iOS-only 的代码而不处理另一个平台
```

### 常见跨平台陷阱

| 陷阱 | Android 表现 | iOS 表现 | 解决方案 |
|------|-------------|----------|----------|
| 状态栏颜色 | 可通过 SystemUiOverlayStyle 控制 | 只能控制图标亮暗 | AppTheme 已统一处理 |
| 返回手势 | 系统返回键 + 手势 | 屏幕左边缘滑动 | GoRouter 自动处理 |
| 键盘弹出 | 默认 resize 布局 | 默认覆盖 | 使用 `resizeToAvoidBottomInset` + `MediaQuery.viewInsets` |
| 图片选择 | 不需要特殊权限（Android 13+） | 需要 Photo Library Usage Description | 使用 `image_picker` 统一处理 |
| 文件存储 | `getExternalStorageDirectory()` | `getApplicationDocumentsDirectory()` | 统一使用 `getApplicationDocumentsDirectory()` |
| HTTP 明文 | 默认禁止（需 network_security_config） | 默认禁止（ATS） | 只使用 HTTPS |
| 字体粗细 | 部分字重可能 fallback | 字重渲染更精确 | 使用 Google Fonts 确保一致 |
| 触觉反馈 | `HapticFeedback` 效果较弱 | Taptic Engine 效果丰富 | 统一使用 `HapticFeedback.lightImpact()` |

### 插件选择规范

引入新的 Flutter 插件时，必须检查：

1. **平台支持**：`pub.dev` 页面确认 Android ✅ + iOS ✅
2. **维护状态**：最近 6 个月内有更新
3. **权限声明**：Android `AndroidManifest.xml` + iOS `Info.plist` 都要配
4. **最低版本**：是否要求提高 `minSdkVersion`（Android）或 iOS deployment target？

### 平台特定配置文件

| 文件 | 平台 | 何时需要修改 |
|------|------|-------------|
| `android/app/build.gradle.kts` | Android | 修改 minSdk、targetSdk、添加依赖 |
| `android/app/src/main/AndroidManifest.xml` | Android | 添加权限、Activity 配置、Deep Link |
| `ios/Runner/Info.plist` | iOS | 添加权限描述、URL Scheme、ATS 配置 |
| `ios/Podfile` | iOS | 修改最低 iOS 版本、添加 Pod 配置 |

**规则：修改任何平台配置文件时，必须同时检查另一个平台是否需要对应修改。**

---

## 二、技术栈

| 技术 | 用途 |
|------|------|
| Flutter 3.38.x | 跨平台 UI |
| flutter_riverpod 3.2.x | 状态管理（Notifier 模式） |
| go_router 17.x | 声明式路由 + ShellRoute |
| shared_preferences | 轻量持久化 |
| path_provider | 应用数据目录 |
| url_launcher | 打开 URL |
| google_fonts | Noto Sans SC / Inter / JetBrains Mono |
| lucide_icons | 图标库 |
| intl | 国际化 |

---

## 三、与桌面端的差异

| 桌面端 (test_app3) | 移动端 (mobile_app) |
|---|---|
| NavRail 56px 侧边栏 | 底部 TabBar 导航 |
| 自定义标题栏 + 窗口控制 | 系统状态栏 + SafeArea |
| window_manager | 无 |
| tray_manager | 无 |
| local_notifier | 无 |
| ThemeSwitcher 圆形揭示动画 | 直接切换（无动画） |
| MouseRegion hover 效果 | 触摸交互 |

**共享部分：** AppColors、AppTheme、GlassContainer、MeshGradientBackground、
Toast、ConfirmDialog、EmptyState、LoadingOverlay、EventBus、StorageService、
Logger、ErrorHandler、AppConfig、i18n (ARB)、Riverpod Provider 模式、设计令牌系统。

---

## 四、设计令牌系统

所有视觉参数必须从设计令牌中引用，禁止硬编码数字。

| 文件 | 职责 | 关键内容 |
|------|------|----------|
| `app_colors.dart` | 色彩系统 | 亮/暗双主题，前景/背景/主色/边框/卡片等 |
| `app_typography.dart` | 排版系统 | Noto Sans SC（全局）+ Inter（标题）+ JetBrains Mono（代码），7级字号阶梯 28/20/16/14/13/12/11 |
| `app_spacing.dart` | 间距系统 | 4dp 网格，9级阶梯 xxs(2)~huge(48)，含页面/卡片/列表预设 |
| `app_radius.dart` | 圆角系统 | 6级 xs(4)/sm(8)/md(12)/lg(16)/xl(24)/full(999)，含 BorderRadius 预设 |
| `app_motion.dart` | 动效系统 | 4级时长 instant(100ms)~slow(500ms)，4种曲线 |
| `app_elevation.dart` | 阴影系统 | 3级 low/medium/high，适配亮暗主题 |
| `app_touch.dart` | 触控规范 | 最小目标 48dp，底部导航 56dp，设置项 56dp |
| `app_theme.dart` | 主题整合 | ThemeData 构建，全局字体 Noto Sans SC |

### 使用示例

```dart
// ✅ 正确
padding: AppSpacing.pagePadding,
borderRadius: AppRadius.borderMd,
style: AppTypography.pageTitle.copyWith(color: fg),
duration: AppMotion.fast,
boxShadow: AppElevation.low(isDark),

// ❌ 禁止
padding: EdgeInsets.all(20),
borderRadius: BorderRadius.circular(12),
fontSize: 28,
duration: Duration(milliseconds: 200),
```

---

## 五、目录结构

```
lib/
├── main.dart
├── l10n/
│   ├── app_zh.arb / app_en.arb
│   └── app_localizations.dart (自动生成)
├── core/
│   ├── config/app_config.dart
│   ├── errors/error_handler.dart
│   ├── logger/logger.dart
│   ├── services/
│   │   ├── event_bus.dart
│   │   ├── storage_service.dart
│   │   └── system_service.dart
│   ├── providers/
│   │   ├── app_providers.dart
│   │   └── service_providers.dart
│   ├── router/
│   │   ├── app_router.dart
│   │   ├── app_route_observer.dart
│   │   └── not_found_page.dart
│   ├── layout/
│   │   └── app_shell.dart (底部导航 + 毛玻璃)
│   ├── theme/
│   │   ├── app_theme.dart      — 主题整合
│   │   ├── app_colors.dart     — 色彩
│   │   ├── app_typography.dart — 排版
│   │   ├── app_spacing.dart    — 间距
│   │   ├── app_radius.dart     — 圆角
│   │   ├── app_motion.dart     — 动效
│   │   ├── app_elevation.dart  — 阴影
│   │   └── app_touch.dart      — 触控
│   ├── widgets/
│   │   ├── glass.dart
│   │   ├── mesh_gradient_bg.dart
│   │   ├── toast.dart
│   │   ├── confirm_dialog.dart
│   │   ├── empty_state.dart
│   │   └── loading_overlay.dart
│   ├── utils/
│   │   ├── clipboard_util.dart
│   │   └── shell_util.dart
│   └── extensions/
│       └── context_extensions.dart
└── features/
    ├── home/home_page.dart
    └── settings/settings_page.dart
```

---

## 六、开发规范（与桌面端一致）

1. 跨平台优先：每个功能必须同时在 Android 和 iOS 上可用，不允许单平台实现
2. 状态管理：Riverpod 3.x `Notifier` 模式，禁止 `StateNotifier`
2. 路由：GoRouter 声明式配置，新页面加入 ShellRoute
3. 页面位置：`features/功能名/` 下
4. 共享组件：`core/widgets/`，使用 `GlassContainer` 风格
5. 颜色：使用 `AppColors` 或 `Theme.of(context)`
6. 排版：使用 `AppTypography.xxx.copyWith(color: ...)`，禁止硬编码 fontSize
7. 间距：使用 `AppSpacing.xxx`，禁止硬编码 padding/margin 数字
8. 圆角：使用 `AppRadius.borderXxx`，禁止硬编码 BorderRadius
9. 动效：使用 `AppMotion.xxx`，禁止硬编码 Duration
10. 阴影：使用 `AppElevation.xxx(isDark)`
11. 触控：交互元素最小 `AppTouch.minTarget` (48dp)
12. 文本：ARB 国际化 `AppLocalizations.of(context)!.xxx`
13. 日志：`AppLogger.info/warn/error`
14. 配置：`AppConfig` 常量

---

## 七、添加新页面

1. 创建 `lib/features/xxx/xxx_page.dart`
2. 在 `app_router.dart` ShellRoute.routes 中添加 GoRoute
3. 在 `app_shell.dart` 的 `_navItems` 中添加导航项
4. 添加 ARB 国际化文本，运行 `flutter gen-l10n`

---

## 八、开发命令

```bash
flutter run                  # 运行（自动选择已连接设备）
flutter test                 # 测试
flutter gen-l10n             # 重新生成国际化
dart analyze lib             # 代码分析

# 双平台构建验证（每次提交前都应执行）
flutter build apk --debug    # Android Debug
flutter build apk            # Android Release
flutter build ios --debug --no-codesign  # iOS Debug（需 macOS）
flutter build ios            # iOS Release（需 macOS）
```
