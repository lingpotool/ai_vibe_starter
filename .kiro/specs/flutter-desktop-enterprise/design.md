# 设计文档

## 概述

本设计将 test_app3 从基础 UI 演示升级为企业级 Flutter 桌面模板。核心策略是在不修改现有 UI 文件的前提下，逐层补齐基础设施（Logger、ErrorHandler、EventBus、AppConfig）、服务层（Storage、System、Tray）、工具层和 UI 组件库。所有新增代码遵循 Riverpod 3.x 模式，使用 Notifier 而非 StateNotifier。

## 架构

```
┌─────────────────────────────────────────────┐
│                  App (main.dart)             │
│  ErrorHandler → runZonedGuarded 包裹启动     │
├─────────────────────────────────────────────┤
│              Features Layer                  │
│  home/ │ settings/ │ (future features)       │
├─────────────────────────────────────────────┤
│              Core Layer                      │
│  ┌─────────┬──────────┬──────────┐          │
│  │ config/ │ errors/  │ logger/  │          │
│  ├─────────┼──────────┼──────────┤          │
│  │services/│  utils/  │extensions│          │
│  ├─────────┼──────────┼──────────┤          │
│  │ theme/  │ layout/  │ widgets/ │ (现有)   │
│  ├─────────┼──────────┼──────────┤          │
│  │providers│ router/  │          │          │
│  └─────────┴──────────┴──────────┘          │
└─────────────────────────────────────────────┘
```

### 依赖方向

- Features → Core（单向依赖）
- Core 内部：services 依赖 logger；errors 依赖 logger；utils 依赖 services；providers 聚合所有 provider
- 现有 UI 层（theme/layout/widgets）保持不变

### 新增依赖包

```yaml
dependencies:
  tray_manager: ^0.2.3        # 系统托盘
  path_provider: ^2.1.5       # 应用数据目录
  url_launcher: ^6.3.1        # 打开 URL
  local_notifier: ^0.1.6      # 桌面通知
```

## 组件与接口

### 1. Logger（lib/core/logger/logger.dart）

```dart
class AppLogger {
  static void info(String module, String message);
  static void warn(String module, String message);
  static void error(String module, String message, [Object? error, StackTrace? stackTrace]);
}
```

- 调试模式：使用 `dart:developer` 的 `log()` 输出到控制台
- 发布模式：追加写入 `{appLogsDir}/{yyyy-MM-dd}.log`
- 日志格式：`[2025-01-15 10:30:00] [INFO] [storage] 消息内容`
- 使用 `kIsDebug`（`kDebugMode` from foundation）区分模式

### 2. ErrorHandler（lib/core/errors/error_handler.dart）

```dart
class ErrorHandler {
  static void init();
  static void _handleFlutterError(FlutterErrorDetails details);
  static bool _handlePlatformError(Object error, StackTrace stack);
}
```

- `init()` 在 main() 中调用，设置 FlutterError.onError 和 PlatformDispatcher.instance.onError
- main() 使用 `runZonedGuarded` 包裹 `runApp`
- 所有捕获的错误通过 AppLogger.error 记录

### 3. EventBus（lib/core/services/event_bus.dart）

```dart
class EventBus {
  void on(String event, EventHandler handler);
  void off(String event, EventHandler handler);
  void emit(String event, [dynamic data]);
  void once(String event, EventHandler handler);
  void clear([String? event]);
}

typedef EventHandler = void Function(dynamic data);
```

- 使用 `Map<String, Set<EventHandler>>` 存储监听器
- `once` 通过包装函数实现自动移除
- 通过 Riverpod Provider 提供单例访问

### 4. AppConfig（lib/core/config/app_config.dart）

```dart
class AppConfig {
  static const name = 'My App';
  static const description = 'A beautiful desktop application';
  static const version = '0.1.0';
  static const defaultLocale = 'zh';
  static const supportedLocales = [Locale('zh'), Locale('en')];
}
```

### 5. StorageService（lib/core/services/storage_service.dart）

```dart
class StorageService {
  Future<void> init();
  T? get<T>(String key);
  Future<void> set(String key, dynamic value);
  Future<void> delete(String key);
  bool has(String key);
}
```

- 底层使用 JSON 文件（`{appDataDir}/app-storage.json`）
- `init()` 在应用启动时调用，读取已有文件或创建空 Map
- `set` 和 `delete` 操作后立即写入磁盘
- 通过 `path_provider` 获取应用数据目录

### 6. SystemService（lib/core/services/system_service.dart）

```dart
class SystemService {
  static Future<void> openUrl(String url);
  static Future<void> showInFolder(String path);
  static Future<String> readClipboard();
  static Future<void> writeClipboard(String text);
  static String getAppVersion();
  static String getPlatform();
}
```

- `openUrl` 使用 `url_launcher` 包
- `showInFolder` 使用 `Process.run` 调用平台命令（macOS: `open -R`，Windows: `explorer /select,`，Linux: `xdg-open`）
- 剪贴板使用 Flutter 的 `Clipboard` 类

### 7. TrayService（lib/core/services/tray_service.dart）

```dart
class TrayService {
  static Future<void> init();
  static Future<void> dispose();
}
```

- 使用 `tray_manager` 包创建系统托盘
- 上下文菜单：显示窗口、分隔线、退出
- 双击事件：显示并聚焦窗口

### 8. RouteObserver（lib/core/router/app_route_observer.dart）

```dart
class AppRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute);
  @override
  void didPop(Route route, Route? previousRoute);
}
```

- 在 didPush/didPop 中通过 Logger 记录路由变化
- 集成到 GoRouter 的 observers 列表

### 9. 404 页面（lib/core/router/not_found_page.dart）

- 显示 404 图标、提示文本和"返回首页"按钮
- 使用毛玻璃设计风格
- 在 GoRouter 的 errorBuilder 中使用

### 10. Provider 重构

```
lib/core/providers/
  app_providers.dart      → 仅保留 ThemeNotifier、LocaleNotifier、平台检测
  service_providers.dart  → Logger、StorageService、EventBus、SystemService 的 Provider
```

### 11. 工具类（lib/core/utils/）

```dart
// clipboard_util.dart
class ClipboardUtil {
  static Future<String> read();
  static Future<void> write(String text);
}

// dialog_util.dart
class DialogUtil {
  static Future<String?> pickFile(BuildContext context, {List<String>? extensions});
  static Future<bool> confirm(BuildContext context, {required String title, String? message});
}

// keyboard_util.dart
class KeyboardShortcutUtil {
  static void register(Map<ShortcutActivator, VoidCallback> shortcuts);
}

// notification_util.dart
class NotificationUtil {
  static Future<void> show({required String title, required String body});
}

// shell_util.dart
class ShellUtil {
  static Future<void> openUrl(String url);
  static Future<void> showInFolder(String path);
}
```

### 12. UI 组件库（lib/core/widgets/）

```dart
// loading_overlay.dart
class LoadingOverlay extends StatelessWidget { ... }

// empty_state.dart
class EmptyState extends StatelessWidget { ... }

// confirm_dialog.dart
class ConfirmDialog extends StatelessWidget { ... }

// toast.dart
class ToastService { ... }

// page_header.dart
class PageHeader extends StatelessWidget { ... }
```

所有组件使用 GlassContainer 风格，自动适配亮色/暗色主题。

## 数据模型

### 日志条目（内部使用，不持久化为对象）

```dart
// 日志格式为纯文本行，不需要数据模型
// 格式: [timestamp] [LEVEL] [module] message
```

### 存储数据

```dart
// StorageService 内部使用 Map<String, dynamic>
// JSON 文件格式:
// {
//   "key1": value1,
//   "key2": value2
// }
```

### 应用配置

```dart
class AppConfig {
  static const String name = 'My App';
  static const String description = 'A beautiful desktop application';
  static const String version = '0.1.0';
  static const String defaultLocale = 'zh';
  static const List<Locale> supportedLocales = [Locale('zh'), Locale('en')];
}
```

### 事件总线事件

```dart
typedef EventHandler = void Function(dynamic data);
// 事件以字符串名称标识，数据为 dynamic 类型
```

### Toast 消息类型

```dart
enum ToastType { success, error, info }
```


## 正确性属性

*属性是一种在系统所有有效执行中都应成立的特征或行为——本质上是关于系统应该做什么的形式化陈述。属性是人类可读规范与机器可验证正确性保证之间的桥梁。*

### Property 1: 日志格式化一致性

*For any* 日志级别（info/warn/error）、任意模块名和任意消息字符串，Logger 的格式化输出 SHALL 包含 `[时间戳]`（ISO 8601 格式）、`[级别]`、`[模块]` 和消息内容。当级别为 error 且传入了异常对象时，输出还 SHALL 包含异常消息和堆栈跟踪字符串。

**Validates: Requirements 1.1, 1.2, 1.5**

### Property 2: EventBus emit 通知所有监听器

*For any* 事件名称和任意数量（≥1）的已注册监听器，当 EventBus.emit 被调用时，所有已注册的监听器 SHALL 被调用恰好一次，且接收到正确的事件数据。

**Validates: Requirements 3.2**

### Property 3: EventBus once 自动移除

*For any* 事件名称，通过 EventBus.once 注册的监听器在第一次 emit 后 SHALL 被自动移除。第二次 emit 同一事件时，该监听器 SHALL 不再被调用。

**Validates: Requirements 3.3**

### Property 4: EventBus clear 清除监听器

*For any* EventBus 状态，调用 clear(event) SHALL 仅移除指定事件的所有监听器，其他事件的监听器 SHALL 保持不变。调用 clear()（无参数）SHALL 移除所有事件的所有监听器。

**Validates: Requirements 3.4**

### Property 5: EventBus off 精确移除

*For any* 事件上注册的 N 个监听器（N ≥ 2），调用 off 移除其中一个特定监听器后，emit 该事件 SHALL 仅调用剩余的 N-1 个监听器。

**Validates: Requirements 3.5**

### Property 6: StorageService 往返一致性

*For any* 有效的 `Map<String, dynamic>`（值为 JSON 可序列化类型），StorageService 将其序列化写入 JSON 文件后再反序列化读取，SHALL 产生与原始数据等价的 Map。

**Validates: Requirements 5.6, 5.3**

### Property 7: RouteObserver 记录导航

*For any* 路由导航事件（push 或 pop），RouteObserver SHALL 通过 Logger 记录包含来源路径和目标路径的日志条目。

**Validates: Requirements 9.1**

## 错误处理

### 全局错误捕获层次

1. **FlutterError.onError**：捕获 Flutter 框架内的同步异常（Widget build 错误、布局错误等）
2. **PlatformDispatcher.instance.onError**：捕获平台层异常
3. **runZonedGuarded**：捕获 Zone 内的异步异常

所有捕获的错误统一通过 `AppLogger.error('error_handler', ...)` 记录。

### 服务级错误处理

| 服务 | 错误场景 | 处理策略 |
|------|---------|---------|
| Logger | 文件写入失败 | try-catch 静默忽略，不影响应用运行 |
| StorageService | JSON 文件读取/解析失败 | 使用空 Map 初始化，Logger 记录错误 |
| StorageService | JSON 文件写入失败 | Logger 记录错误，内存数据保持不变 |
| TrayService | 托盘创建失败 | Logger 记录错误，应用继续运行（托盘为非关键功能） |
| SystemService | URL 打开失败 | Logger 记录错误，向调用方抛出异常 |

## 测试策略

### 属性测试（Property-Based Testing）

使用 **dart_quickcheck**（或 `glados` 包）作为属性测试库。每个属性测试运行至少 100 次迭代。

每个正确性属性对应一个独立的属性测试：

| 属性 | 测试文件 | 标签 |
|------|---------|------|
| Property 1 | test/core/logger/logger_test.dart | Feature: flutter-desktop-enterprise, Property 1: 日志格式化一致性 |
| Property 2 | test/core/services/event_bus_test.dart | Feature: flutter-desktop-enterprise, Property 2: EventBus emit 通知所有监听器 |
| Property 3 | test/core/services/event_bus_test.dart | Feature: flutter-desktop-enterprise, Property 3: EventBus once 自动移除 |
| Property 4 | test/core/services/event_bus_test.dart | Feature: flutter-desktop-enterprise, Property 4: EventBus clear 清除监听器 |
| Property 5 | test/core/services/event_bus_test.dart | Feature: flutter-desktop-enterprise, Property 5: EventBus off 精确移除 |
| Property 6 | test/core/services/storage_service_test.dart | Feature: flutter-desktop-enterprise, Property 6: StorageService 往返一致性 |
| Property 7 | test/core/router/route_observer_test.dart | Feature: flutter-desktop-enterprise, Property 7: RouteObserver 记录导航 |

### 单元测试

单元测试覆盖具体示例和边界情况：

- Logger：验证各级别输出、空模块名、空消息
- EventBus：验证无监听器时 emit 不报错、重复注册同一监听器
- StorageService：验证键不存在返回 null、文件损坏时的恢复
- AppConfig：验证所有字段存在且类型正确
- UI 组件：Widget 测试验证渲染和主题适配

### 测试不覆盖的范围

- 系统托盘交互（需要桌面环境）
- URL 打开、文件管理器显示（需要系统进程）
- 桌面通知发送（需要系统通知服务）
- 剪贴板操作（需要平台支持）
