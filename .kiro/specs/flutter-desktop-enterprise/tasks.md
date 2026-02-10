# 实施计划：Flutter 桌面企业级模板

## 概述

将 test_app3 从基础 UI 演示升级为完整的企业级 Flutter 桌面模板。按照依赖顺序逐层实现：项目配置 → 核心基础设施 → 服务层 → 路由增强 → 工具类 → UI 组件库 → 集成接线。

## 任务

- [x] 1. 项目配置与基础结构
  - [x] 1.1 更新 pubspec.yaml，添加 tray_manager、path_provider、url_launcher、local_notifier 依赖，添加 glados（属性测试库）到 dev_dependencies
    - _Requirements: 12.3_
  - [x] 1.2 创建 analysis_options.yaml，配置严格 lint 规则（prefer_const_constructors、avoid_print、prefer_final_locals 等）
    - _Requirements: 12.2_
  - [x] 1.3 创建 lib/core/config/app_config.dart，定义 AppConfig 常量类（name、description、version、defaultLocale、supportedLocales）
    - _Requirements: 4.1, 4.2_

- [x] 2. Logger 服务
  - [x] 2.1 创建 lib/core/logger/logger.dart，实现 AppLogger 类（info/warn/error 方法，调试模式用 dart:developer，发布模式写文件，格式 [timestamp] [LEVEL] [module] message）
    - _Requirements: 1.1, 1.2, 1.3, 1.4, 1.5, 1.6_
  - [x] 2.2 编写 Logger 格式化属性测试
    - **Property 1: 日志格式化一致性**
    - **Validates: Requirements 1.1, 1.2, 1.5**

- [x] 3. 全局错误处理
  - [x] 3.1 创建 lib/core/errors/error_handler.dart，实现 ErrorHandler.init()（设置 FlutterError.onError、PlatformDispatcher.onError），修改 main.dart 使用 runZonedGuarded 包裹 runApp
    - _Requirements: 2.1, 2.2, 2.3, 2.4_

- [x] 4. EventBus 服务
  - [x] 4.1 创建 lib/core/services/event_bus.dart，实现 EventBus 类（on/off/emit/once/clear 方法，使用 Map<String, Set<EventHandler>> 存储）
    - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5_
  - [x] 4.2 编写 EventBus emit 属性测试
    - **Property 2: EventBus emit 通知所有监听器**
    - **Validates: Requirements 3.2**
  - [x] 4.3 编写 EventBus once 属性测试
    - **Property 3: EventBus once 自动移除**
    - **Validates: Requirements 3.3**
  - [x] 4.4 编写 EventBus clear 属性测试
    - **Property 4: EventBus clear 清除监听器**
    - **Validates: Requirements 3.4**
  - [x] 4.5 编写 EventBus off 属性测试
    - **Property 5: EventBus off 精确移除**
    - **Validates: Requirements 3.5**

- [x] 5. Checkpoint - 确保核心基础设施测试通过
  - 确保所有测试通过，如有问题请询问用户。

- [x] 6. StorageService
  - [x] 6.1 创建 lib/core/services/storage_service.dart，实现 StorageService 类（init/get/set/delete/has 方法，JSON 文件持久化，使用 path_provider 获取目录）
    - _Requirements: 5.1, 5.2, 5.3, 5.4, 5.5_
  - [x] 6.2 编写 StorageService 往返一致性属性测试
    - **Property 6: StorageService 往返一致性**
    - **Validates: Requirements 5.6, 5.3**

- [x] 7. SystemService
  - [x] 7.1 创建 lib/core/services/system_service.dart，实现 SystemService 类（openUrl、showInFolder、readClipboard、writeClipboard、getAppVersion、getPlatform）
    - _Requirements: 6.1, 6.2, 6.3, 6.4, 6.5_

- [x] 8. TrayService
  - [x] 8.1 创建 lib/core/services/tray_service.dart，实现 TrayService（init/dispose，使用 tray_manager 创建托盘图标和上下文菜单）
    - _Requirements: 7.1, 7.2, 7.3, 7.4_

- [x] 9. Provider 重构与服务注册
  - [x] 9.1 创建 lib/core/providers/service_providers.dart，注册 StorageService、EventBus 的 Provider；重构 app_providers.dart 仅保留主题/语言/平台 Provider
    - _Requirements: 8.1, 8.2, 8.3_

- [x] 10. 路由增强
  - [x] 10.1 创建 lib/core/router/app_route_observer.dart（NavigatorObserver，在 didPush/didPop 中通过 Logger 记录路由变化）；创建 lib/core/router/not_found_page.dart（404 页面，毛玻璃风格）；更新 app_router.dart 集成 observer 和 errorBuilder
    - _Requirements: 9.1, 9.2, 9.3_
  - [x] 10.2 编写 RouteObserver 属性测试
    - **Property 7: RouteObserver 记录导航**
    - **Validates: Requirements 9.1**

- [x] 11. Checkpoint - 确保服务层和路由测试通过
  - 确保所有测试通过，如有问题请询问用户。

- [x] 12. 工具类
  - [x] 12.1 创建 lib/core/utils/ 目录下的工具类：clipboard_util.dart、dialog_util.dart、keyboard_util.dart、notification_util.dart、shell_util.dart
    - _Requirements: 10.1, 10.2, 10.3, 10.4, 10.5_

- [x] 13. UI 组件库
  - [x] 13.1 创建 lib/core/widgets/loading_overlay.dart（半透明遮罩 + 加载指示器，使用 GlassContainer 风格）
    - _Requirements: 11.1, 11.6_
  - [x] 13.2 创建 lib/core/widgets/empty_state.dart（图标 + 标题 + 描述，毛玻璃风格）
    - _Requirements: 11.2, 11.6_
  - [x] 13.3 创建 lib/core/widgets/confirm_dialog.dart（标题 + 描述 + 确认/取消按钮，毛玻璃风格）
    - _Requirements: 11.3, 11.6_
  - [x] 13.4 创建 lib/core/widgets/toast.dart（ToastService + ToastOverlay，支持 success/error/info 类型）
    - _Requirements: 11.4, 11.6_
  - [x] 13.5 创建 lib/core/widgets/page_header.dart（标题 + 副标题 + 操作按钮区域）
    - _Requirements: 11.5, 11.6_

- [x] 14. 集成接线
  - [x] 14.1 更新 lib/main.dart：集成 ErrorHandler.init()、StorageService 初始化、TrayService 初始化、AppConfig 引用替换硬编码字符串；确保 runZonedGuarded 包裹启动流程
    - _Requirements: 2.3, 4.3, 7.1, 8.1_
  - [x] 14.2 创建 lib/core/extensions/ 目录，添加 context_extensions.dart（BuildContext 扩展方法：快捷访问 theme、colorScheme、isDark 等）
    - _Requirements: 12.1_

- [x] 15. Final Checkpoint - 确保所有测试通过
  - 确保所有测试通过，如有问题请询问用户。

## 备注

- 标记 `*` 的任务为可选任务，可跳过以加速 MVP
- 每个任务引用了具体的需求编号以确保可追溯性
- Checkpoint 任务确保增量验证
- 属性测试使用 glados 包，每个测试至少运行 100 次迭代
- 现有 UI 文件（theme/layout/widgets/features）不做修改，仅在 main.dart 中添加初始化逻辑
