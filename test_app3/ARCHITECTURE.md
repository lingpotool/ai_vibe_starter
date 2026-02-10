# Flutter 桌面企业级模板 — AI 开发指南

> 本文档是 AI 助手（任何工具）的上下文加载文件。
> 加载后即可理解项目全貌、架构约束、开发规范，并开始开发具体功能。
> 适用于 Cursor、Kiro、Copilot、Claude、ChatGPT 等所有 AI 编码工具。

---

## 一、项目定位

Flutter 桌面应用企业级模板，提供 macOS 级别的视觉质感（毛玻璃/高斯模糊/玻璃态），跨平台支持 Windows / macOS / Linux。

核心基础设施已就绪：结构化日志、全局错误处理、事件总线、键值存储、系统托盘、路由观察、UI 组件库。开发者只需在 `features/` 下添加业务功能。

---

## 二、技术栈

| 技术 | 版本 | 用途 |
|------|------|------|
| Flutter | 3.38.x (stable) | 跨平台 UI 框架 |
| Dart | 3.10.x | 编程语言 |
| flutter_riverpod | 3.2.x | 状态管理（Notifier 模式，非 StateNotifier） |
| go_router | 17.x | 声明式路由 + ShellRoute |
| window_manager | 0.5.x | 桌面窗口管理 |
| shared_preferences | 2.5.x | 轻量持久化（主题、语言偏好） |
| tray_manager | 0.2.x | 系统托盘 |
| path_provider | 2.1.x | 应用数据目录 |
| url_launcher | 6.3.x | 打开 URL |
| local_notifier | 0.1.x | 桌面系统通知 |
| google_fonts | 8.x | Inter 字体 |
| lucide_icons | 0.257.x | 图标库 |
| intl | 0.20.x | 国际化 |
| glados | dev | 属性测试（Property-Based Testing） |

---

## 三、目录结构

```
lib/
├── main.dart                              # 入口：错误处理 → 窗口 → 存储 → 托盘 → runZonedGuarded
├── l10n/                                  # 国际化（ARB + 自动生成）
│   ├── app_zh.arb / app_en.arb
│   └── app_localizations.dart             # 自动生成
├── core/                                  # 核心基础设施（不含业务逻辑）
│   ├── config/
│   │   └── app_config.dart                # 集中式常量配置（名称、版本、语言）
│   ├── errors/
│   │   └── error_handler.dart             # 全局错误捕获（FlutterError + PlatformDispatcher + Zone）
│   ├── logger/
│   │   └── logger.dart                    # 结构化日志（debug→控制台，release→文件）
│   ├── services/
│   │   ├── event_bus.dart                 # 类型化事件总线（on/off/emit/once/clear）
│   │   ├── storage_service.dart           # JSON 文件键值存储（get/set/delete/has）
│   │   ├── system_service.dart            # 平台工具（URL、剪贴板、文件管理器）
│   │   └── tray_service.dart              # 系统托盘（图标 + 右键菜单）
│   ├── providers/
│   │   ├── app_providers.dart             # 应用级状态（主题、语言、平台）
│   │   └── service_providers.dart         # 服务 Provider（EventBus、StorageService）
│   ├── router/
│   │   ├── app_router.dart                # GoRouter 配置（ShellRoute + fade 动画）
│   │   ├── app_route_observer.dart        # 路由导航日志观察器
│   │   └── not_found_page.dart            # 404 页面（毛玻璃风格）
│   ├── layout/
│   │   ├── app_shell.dart                 # 主布局壳（渐变背景 + NavRail + 标题栏 + 内容区）
│   │   └── nav_rail.dart                  # 56px 窄侧边栏（玻璃态 + 图标导航 + 主题切换）
│   ├── theme/
│   │   ├── app_theme.dart                 # ThemeData（亮/暗）
│   │   └── app_colors.dart                # 色彩系统（亮/暗双套）
│   ├── widgets/                           # 通用 UI 组件库
│   │   ├── glass.dart                     # GlassContainer / GlassCard（核心玻璃态组件）
│   │   ├── mesh_gradient_bg.dart          # 多层径向渐变背景
│   │   ├── loading_overlay.dart           # 加载遮罩（半透明 + 毛玻璃指示器）
│   │   ├── empty_state.dart               # 空状态（图标 + 标题 + 描述）
│   │   ├── confirm_dialog.dart            # 确认对话框（毛玻璃风格）
│   │   ├── toast.dart                     # Toast 通知（success/error/info）
│   │   └── page_header.dart               # 页面头部（标题 + 副标题 + 操作按钮）
│   ├── utils/                             # 工具类
│   │   ├── clipboard_util.dart            # 剪贴板读写
│   │   ├── dialog_util.dart               # 文件选择 + 确认对话框
│   │   ├── keyboard_util.dart             # 全局键盘快捷键注册
│   │   ├── notification_util.dart         # 桌面系统通知
│   │   └── shell_util.dart                # 打开 URL + 文件管理器
│   └── extensions/
│       └── context_extensions.dart        # BuildContext 扩展（theme/colorScheme/isDark 等）
└── features/                              # 业务功能模块
    ├── home/
    │   └── home_page.dart                 # 首页（统计卡片 + 快速开始指南）
    └── settings/
        └── settings_page.dart             # 设置页（主题 + 语言 + 关于信息）
```

---

## 四、启动流程

`main.dart` 的初始化顺序（严格按此顺序）：

```
1. WidgetsFlutterBinding.ensureInitialized()
2. ErrorHandler.init()           → 设置 FlutterError.onError + PlatformDispatcher.onError
3. windowManager.ensureInitialized()
4. SharedPreferences.getInstance()
5. StorageService().init()       → 读取/创建 JSON 存储文件
6. TrayService.init()            → 创建系统托盘图标
7. WindowOptions 配置            → 使用 AppConfig.name 作为窗口标题
8. runZonedGuarded {             → 捕获所有异步异常
     runApp(ProviderScope(...))
   }
```

---

## 五、核心设计模式

### 5.1 玻璃态（Glassmorphism）

所有 UI 组件统一使用毛玻璃设计语言：

```dart
// 基础用法 — 任何需要玻璃效果的地方
GlassContainer(
  borderRadius: BorderRadius.circular(12),
  padding: const EdgeInsets.all(16),
  child: YourContent(),
)

// 卡片变体
GlassCard(child: YourContent())
```

底层原理：`BackdropFilter(blur) + 半透明背景 + 细边框 + 多层阴影`。
背景由 `MeshGradientBackground` 提供可透出的色彩。

**关键规则：**
- 所有新 UI 组件必须使用 `GlassContainer` 或 `GlassCard`
- 颜色使用 `AppColors` 或 `Theme.of(context)`，不要硬编码
- 亮/暗模式自动适配，通过 `Theme.of(context).brightness` 判断

### 5.2 状态管理（Riverpod 3.x Notifier）

**必须使用 `Notifier` 模式，禁止使用已废弃的 `StateNotifier`。**

```dart
// 定义 Provider
final myFeatureProvider = NotifierProvider<MyFeatureNotifier, MyState>(
  MyFeatureNotifier.new,
);

class MyFeatureNotifier extends Notifier<MyState> {
  @override
  MyState build() => MyState.initial();

  void doSomething() {
    state = state.copyWith(loading: true);
    // ...
  }
}

// 读取状态
final value = ref.watch(myFeatureProvider);

// 调用方法
ref.read(myFeatureProvider.notifier).doSomething();
```

**现有 Provider 清单：**

| Provider | 文件 | 用途 |
|----------|------|------|
| `isDarkProvider` | app_providers.dart | 暗色模式开关（持久化） |
| `localeProvider` | app_providers.dart | 当前语言（持久化） |
| `platformProvider` | app_providers.dart | 平台检测 |
| `isMacProvider` | app_providers.dart | 是否 macOS |
| `themeModeProvider` | app_providers.dart | ThemeMode 派生 |
| `sharedPrefsProvider` | app_providers.dart | SharedPreferences 实例 |
| `eventBusProvider` | service_providers.dart | EventBus 单例 |
| `storageServiceProvider` | service_providers.dart | StorageService 单例 |

**新增服务 Provider 的规则：** 在 `service_providers.dart` 中注册，不要修改 `app_providers.dart`。

### 5.3 路由（GoRouter + ShellRoute）

```dart
// 现有路由结构
ShellRoute(
  builder: (context, state, child) => AppShell(child: child),
  routes: [
    GoRoute(path: '/home', pageBuilder: ... _fadeTransition),
    GoRoute(path: '/settings', pageBuilder: ... _fadeTransition),
  ],
)
```

路由观察器 `AppRouteObserver` 自动记录所有导航事件到日志。
未匹配路由自动显示 `NotFoundPage`（404 毛玻璃页面）。

### 5.4 日志系统

```dart
AppLogger.info('module_name', '操作描述');
AppLogger.warn('module_name', '警告信息');
AppLogger.error('module_name', '错误描述', exception, stackTrace);
```

- Debug 模式：输出到控制台（dart:developer）
- Release 模式：写入 `{appLogsDir}/{yyyy-MM-dd}.log`
- 格式：`[2025-01-15 10:30:00] [INFO] [module] 消息`

### 5.5 事件总线

```dart
final bus = ref.read(eventBusProvider);

// 订阅
bus.on('user:login', (data) => print(data));

// 一次性订阅
bus.once('app:ready', (data) => print('Ready!'));

// 发布
bus.emit('user:login', {'name': 'Alice'});

// 取消订阅
bus.off('user:login', handler);

// 清除
bus.clear('user:login');  // 清除指定事件
bus.clear();              // 清除全部
```

### 5.6 存储服务

```dart
final storage = ref.read(storageServiceProvider);

await storage.set('key', 'value');       // 写入（立即持久化）
final val = storage.get<String>('key');  // 读取
final exists = storage.has('key');       // 检查
await storage.delete('key');             // 删除
```

底层：JSON 文件 `{appDataDir}/app-storage.json`。

### 5.7 UI 组件库

| 组件 | 用法 |
|------|------|
| `LoadingOverlay` | `LoadingOverlay(isLoading: true, message: '加载中...', child: content)` |
| `EmptyState` | `EmptyState(icon: Icons.inbox, title: '暂无数据', description: '...')` |
| `ConfirmDialog` | `final ok = await ConfirmDialog.show(context, title: '确认删除?')` |
| `ToastService` | `ToastService.show(context, message: '成功', type: ToastType.success)` |
| `PageHeader` | `PageHeader(title: '用户管理', subtitle: '...', actions: [...])` |

所有组件自动适配亮/暗主题，使用毛玻璃风格。

### 5.8 工具类

| 工具 | 用法 |
|------|------|
| `ClipboardUtil` | `await ClipboardUtil.write('text')` / `await ClipboardUtil.read()` |
| `DialogUtil` | `await DialogUtil.confirm(context, title: '...')` |
| `KeyboardShortcutUtil` | `KeyboardShortcutUtil.register({...})` |
| `NotificationUtil` | `await NotificationUtil.show(title: '...', body: '...')` |
| `ShellUtil` | `await ShellUtil.openUrl('https://...')` |

### 5.9 BuildContext 扩展

```dart
import 'package:test_app3/core/extensions/context_extensions.dart';

context.theme          // ThemeData
context.colorScheme    // ColorScheme
context.textTheme      // TextTheme
context.isDark         // bool
context.isLight        // bool
context.screenSize     // Size
```

---

## 六、添加新功能页面（完整步骤）

以添加「用户管理」页面为例：

### 步骤 1：创建页面文件

```
lib/features/users/
├── users_page.dart          # 页面 Widget
├── users_provider.dart      # 状态管理（如需要）
└── widgets/                 # 页面专属组件（如需要）
    └── user_card.dart
```

### 步骤 2：编写页面

```dart
// lib/features/users/users_page.dart
import 'package:flutter/material.dart';
import 'package:test_app3/core/widgets/glass.dart';
import 'package:test_app3/core/widgets/page_header.dart';
import 'package:test_app3/core/widgets/empty_state.dart';
import 'package:test_app3/core/theme/app_colors.dart';
import 'package:test_app3/core/extensions/context_extensions.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 4),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 使用 PageHeader 组件
                PageHeader(
                  title: '用户管理',
                  subtitle: '管理系统用户',
                  actions: [
                    FilledButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add),
                      label: const Text('添加用户'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 使用 GlassContainer 包裹内容
                GlassContainer(
                  borderRadius: BorderRadius.circular(12),
                  padding: const EdgeInsets.all(20),
                  child: const EmptyState(
                    icon: Icons.people_outline,
                    title: '暂无用户',
                    description: '点击上方按钮添加第一个用户',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
```

### 步骤 3：注册路由

```dart
// app_router.dart — 在 ShellRoute.routes 中添加
GoRoute(
  path: '/users',
  pageBuilder: (context, state) => CustomTransitionPage(
    child: const UsersPage(),
    transitionsBuilder: _fadeTransition,
  ),
),
```

### 步骤 4：添加导航项

```dart
// nav_rail.dart — 在 _navItems 列表中添加
const _navItems = [
  _NavItem('/home', LucideIcons.home, '首页'),
  _NavItem('/users', LucideIcons.users, '用户'),     // ← 新增
  _NavItem('/settings', LucideIcons.settings, '设置'),
];
```

### 步骤 5：添加国际化

```json
// lib/l10n/app_zh.arb
{ "users": "用户管理" }

// lib/l10n/app_en.arb
{ "users": "Users" }
```

然后运行 `flutter gen-l10n`。

---

## 七、已知陷阱与注意事项

### 7.1 Text 黄色下划线问题

在 `Overlay`、`OverlayEntry` 中直接使用 `Text` 会出现黄色双下划线。
解决方案：用 `Material(type: MaterialType.transparency)` 或 `DefaultTextStyle` 包裹。

```dart
// OverlayEntry 中的正确写法
DefaultTextStyle(
  style: TextStyle(decoration: TextDecoration.none, ...),
  child: YourWidget(),
)
// 或
Material(
  color: Colors.transparent,
  child: YourWidget(),
)
```

### 7.2 DropdownButton 需要 Material 祖先

`app_shell.dart` 中已用 `Material(type: MaterialType.transparency)` 包裹内容区，
所以页面内可以直接使用 `DropdownButton` 等 Material 组件。

### 7.3 macOS vs Windows 布局差异

- macOS：预留 38px 红绿灯区域，无自定义窗口按钮
- Windows：预留 48px，右上角有自定义最小化/最大化/关闭按钮
- 使用 `ref.watch(isMacProvider)` 判断平台

### 7.4 StorageService 必须先初始化

`StorageService` 在 `main()` 中通过 `await storageService.init()` 初始化，
并通过 `storageServiceProvider.overrideWithValue(storageService)` 注入。
不要在 Provider 中直接 `new StorageService()` 然后使用。

### 7.5 AppConfig 替代硬编码

应用名称、版本等信息统一从 `AppConfig` 读取：

```dart
AppConfig.name              // 'My App'
AppConfig.version           // '0.1.0'
AppConfig.supportedLocales  // [Locale('zh'), Locale('en')]
```

---

## 八、开发命令

```bash
# Flutter 版本管理
fvm use stable

# 开发运行
fvm flutter run -d windows
fvm flutter run -d macos
fvm flutter run -d linux

# 运行测试
fvm flutter test

# 重新生成国际化代码
fvm flutter gen-l10n

# 代码分析
fvm flutter analyze

# 构建发布
fvm flutter build windows
fvm flutter build macos
fvm flutter build linux
```

---

## 九、开发规范（必须遵守）

1. **状态管理**：使用 Riverpod 3.x `Notifier` 模式，禁止 `StateNotifier`
2. **路由**：使用 GoRouter 声明式配置，新页面加入 ShellRoute
3. **页面位置**：所有业务页面放在 `features/功能名/` 下
4. **共享组件**：放在 `core/widgets/`，使用 `GlassContainer` 风格
5. **颜色**：使用 `AppColors` 或 `Theme.of(context)`，不要硬编码 RGB
6. **文本**：使用 ARB 国际化 `AppLocalizations.of(context)!.xxx`，不要硬编码中文
7. **平台检测**：使用 `ref.watch(isMacProvider)` 或 `ref.watch(platformProvider)`
8. **日志**：使用 `AppLogger.info/warn/error`，不要用 `print()`
9. **配置**：使用 `AppConfig` 常量，不要硬编码应用名称/版本
10. **服务注册**：新服务的 Provider 放在 `service_providers.dart`
11. **Overlay 中的 Text**：必须用 `DefaultTextStyle` 或 `Material` 包裹
12. **页面布局**：使用 `ListView` + `ConstrainedBox(maxWidth: 720)` + `Center` 的标准模式
13. **测试**：核心逻辑写属性测试（glados），UI 写 Widget 测试

---

## 十、测试架构

```
test/
├── widget_test.dart                           # 冒烟测试
├── core/
│   ├── config/app_config_test.dart            # 配置测试
│   ├── errors/error_handler_test.dart         # 错误处理测试
│   ├── extensions/context_extensions_test.dart # 扩展测试
│   ├── logger/
│   │   ├── logger_test.dart                   # Logger 单元测试
│   │   └── logger_property_test.dart          # Logger 属性测试
│   ├── providers/service_providers_test.dart   # Provider 测试
│   ├── router/
│   │   ├── app_route_observer_test.dart       # 路由观察器单元测试
│   │   ├── route_observer_property_test.dart  # 路由观察器属性测试
│   │   └── not_found_page_test.dart           # 404 页面测试
│   ├── services/
│   │   ├── event_bus_test.dart                # EventBus 单元测试
│   │   ├── event_bus_property_test.dart       # EventBus 属性测试
│   │   ├── storage_service_test.dart          # Storage 单元测试
│   │   └── storage_service_property_test.dart # Storage 属性测试
│   └── widgets/
│       ├── loading_overlay_test.dart
│       ├── empty_state_test.dart
│       ├── confirm_dialog_test.dart
│       ├── toast_test.dart
│       └── page_header_test.dart
```

属性测试使用 `glados` 包，每个属性至少 100 次迭代。
