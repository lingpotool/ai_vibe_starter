# Flutter 移动端企业级模板 — AI 开发指南

> 本文档是 AI 助手的上下文加载文件。
> 与桌面端 (test_app3) 共享相同的设计语言、色彩系统、玻璃态组件。

---

## 一、项目定位

Flutter 移动应用企业级模板（iOS / Android），提供与桌面端一致的毛玻璃视觉风格。
核心基础设施已就绪：日志、错误处理、事件总线、键值存储、路由、UI 组件库。
开发者只需在 `features/` 下添加业务功能。

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
| google_fonts | Inter 字体 |
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
Logger、ErrorHandler、AppConfig、i18n (ARB)、Riverpod Provider 模式。

---

## 四、目录结构

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
│   │   ├── app_theme.dart
│   │   └── app_colors.dart
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

## 五、开发规范（与桌面端一致）

1. 状态管理：Riverpod 3.x `Notifier` 模式，禁止 `StateNotifier`
2. 路由：GoRouter 声明式配置，新页面加入 ShellRoute
3. 页面位置：`features/功能名/` 下
4. 共享组件：`core/widgets/`，使用 `GlassContainer` 风格
5. 颜色：使用 `AppColors` 或 `Theme.of(context)`
6. 文本：ARB 国际化 `AppLocalizations.of(context)!.xxx`
7. 日志：`AppLogger.info/warn/error`
8. 配置：`AppConfig` 常量

---

## 六、添加新页面

1. 创建 `lib/features/xxx/xxx_page.dart`
2. 在 `app_router.dart` ShellRoute.routes 中添加 GoRoute
3. 在 `app_shell.dart` 的 `_navItems` 中添加导航项
4. 添加 ARB 国际化文本，运行 `flutter gen-l10n`

---

## 七、开发命令

```bash
flutter run                  # 运行
flutter test                 # 测试
flutter gen-l10n             # 重新生成国际化
dart analyze lib             # 代码分析
flutter build apk            # 构建 Android
flutter build ios            # 构建 iOS
```
