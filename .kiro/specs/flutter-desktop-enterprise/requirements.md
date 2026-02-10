# 需求文档

## 简介

将现有的 Flutter 桌面应用（test_app3）从一个基础 UI 演示升级为完整的企业级桌面应用模板。参照 Vue/Electron 参考项目（test-app2）的架构质量，补齐核心基础设施、服务层、工具层和 UI 组件库，同时保持现有的毛玻璃（glassmorphism）设计系统不变。

## 术语表

- **App**：Flutter 桌面应用程序（test_app3）
- **Logger**：结构化日志服务，负责格式化输出和文件持久化
- **ErrorHandler**：全局错误捕获处理器
- **EventBus**：类型化事件总线，用于跨组件松耦合通信
- **AppConfig**：集中式应用配置对象
- **StorageService**：键值对持久化存储服务
- **SystemService**：平台工具服务（URL 打开、文件浏览器、剪贴板等）
- **TrayService**：系统托盘图标与上下文菜单服务
- **RouteObserver**：路由导航观察器，用于日志记录
- **Provider**：Riverpod 3.x 状态管理单元

## 需求

### 需求 1：结构化日志服务

**用户故事：** 作为开发者，我希望应用具备结构化日志能力，以便在开发和生产环境中追踪问题。

#### 验收标准

1. THE Logger SHALL 提供 info、warn、error 三个日志级别方法，每个方法接受模块名和消息参数
2. WHEN Logger 输出日志时，THE Logger SHALL 在每条日志前附加 ISO 8601 时间戳和模块标签，格式为 `[时间戳] [级别] [模块] 消息`
3. WHILE App 运行在调试模式时，THE Logger SHALL 将日志输出到控制台（dart:developer）
4. WHILE App 运行在发布模式时，THE Logger SHALL 将日志追加写入到应用日志目录下以日期命名的文件中
5. WHEN Logger.error 被调用且传入了异常对象时，THE Logger SHALL 在日志消息中包含异常信息和堆栈跟踪
6. IF 日志文件写入失败，THEN THE Logger SHALL 静默忽略写入错误，确保不影响应用正常运行

### 需求 2：全局错误处理

**用户故事：** 作为开发者，我希望应用能捕获所有未处理的异常，以便防止静默崩溃并记录错误信息。

#### 验收标准

1. WHEN Flutter 框架抛出未捕获异常时，THE ErrorHandler SHALL 通过 FlutterError.onError 捕获该异常并调用 Logger 记录
2. WHEN 平台层抛出未捕获异常时，THE ErrorHandler SHALL 通过 PlatformDispatcher.onError 捕获该异常并调用 Logger 记录
3. THE ErrorHandler SHALL 在 main() 函数中通过 runZonedGuarded 包裹应用启动，捕获 Zone 内的所有异步异常
4. WHEN 错误被捕获时，THE ErrorHandler SHALL 记录错误类型、消息和堆栈跟踪信息

### 需求 3：类型化事件总线

**用户故事：** 作为开发者，我希望有一个事件总线机制，以便组件之间可以松耦合地通信。

#### 验收标准

1. THE EventBus SHALL 提供 on、off、emit、once 四个方法用于事件的订阅、取消订阅、发布和一次性订阅
2. WHEN EventBus.emit 被调用时，THE EventBus SHALL 同步通知所有已注册的该事件监听器
3. WHEN EventBus.once 注册的监听器被触发一次后，THE EventBus SHALL 自动移除该监听器
4. THE EventBus SHALL 提供 clear 方法，支持清除指定事件或全部事件的监听器
5. WHEN EventBus.off 被调用时，THE EventBus SHALL 仅移除指定的监听器函数，保留同一事件的其他监听器

### 需求 4：集中式应用配置

**用户故事：** 作为开发者，我希望应用名称、版本等配置集中管理，以便修改时只需改一处。

#### 验收标准

1. THE AppConfig SHALL 包含应用名称、描述、版本号、默认语言和支持的语言列表字段
2. THE AppConfig SHALL 作为不可变常量在编译时确定，供应用各处引用
3. WHEN App 的标题栏、关于页面或其他位置需要显示应用名称时，THE App SHALL 从 AppConfig 读取而非硬编码

### 需求 5：键值对存储服务

**用户故事：** 作为开发者，我希望有一个统一的存储抽象层，以便将来可以替换底层存储实现。

#### 验收标准

1. THE StorageService SHALL 提供 get、set、delete、has 四个方法用于键值对的读取、写入、删除和存在性检查
2. THE StorageService SHALL 使用 JSON 文件作为底层存储实现，文件位于应用数据目录下
3. WHEN StorageService.set 被调用时，THE StorageService SHALL 立即将变更持久化到磁盘
4. WHEN StorageService.get 被调用且键不存在时，THE StorageService SHALL 返回 null
5. IF 存储文件读取失败，THEN THE StorageService SHALL 使用空数据初始化并通过 Logger 记录错误
6. WHEN StorageService 序列化数据到 JSON 文件后再反序列化时，THE StorageService SHALL 产生与原始数据等价的结果（往返一致性）

### 需求 6：平台工具服务

**用户故事：** 作为开发者，我希望有统一的平台工具接口，以便方便地调用系统功能。

#### 验收标准

1. WHEN SystemService.openUrl 被调用时，THE SystemService SHALL 使用系统默认浏览器打开指定 URL
2. WHEN SystemService.showInFolder 被调用时，THE SystemService SHALL 在系统文件管理器中显示指定路径
3. THE SystemService SHALL 提供 readClipboard 和 writeClipboard 方法用于系统剪贴板的读写
4. THE SystemService SHALL 提供 getAppVersion 方法返回应用版本号字符串
5. THE SystemService SHALL 提供 getPlatform 方法返回当前操作系统标识

### 需求 7：系统托盘服务

**用户故事：** 作为用户，我希望应用支持系统托盘，以便可以最小化到托盘并通过托盘菜单操作。

#### 验收标准

1. WHEN App 启动时，THE TrayService SHALL 在系统托盘区域创建应用图标
2. THE TrayService SHALL 提供包含"显示窗口"和"退出"选项的右键上下文菜单
3. WHEN 用户双击托盘图标时，THE TrayService SHALL 显示并聚焦应用窗口
4. WHEN 用户点击"退出"菜单项时，THE TrayService SHALL 关闭应用窗口

### 需求 8：状态管理架构重构

**用户故事：** 作为开发者，我希望状态管理按职责分层组织，以便代码结构清晰且易于维护。

#### 验收标准

1. THE App SHALL 将 Provider 按职责分为三类文件：应用级状态（主题、语言、平台）、服务 Provider（Logger、Storage 等）和功能级状态（各功能模块独立）
2. WHEN 新增一个服务时，THE App SHALL 在服务 Provider 文件中注册该服务的 Provider，无需修改应用级状态文件
3. THE App SHALL 保持现有的 ThemeNotifier、LocaleNotifier 功能不变，仅调整文件组织结构

### 需求 9：路由增强

**用户故事：** 作为开发者，我希望路由系统支持导航观察和 404 页面，以便提升可维护性。

#### 验收标准

1. THE App SHALL 提供一个 RouteObserver，在每次路由导航时通过 Logger 记录来源路径和目标路径
2. WHEN 用户导航到未定义的路径时，THE App SHALL 显示一个 404 未找到页面，包含返回首页的链接
3. THE App SHALL 保持现有的 ShellRoute 结构和淡入过渡动画不变

### 需求 10：可复用工具类

**用户故事：** 作为开发者，我希望有一组常用的工具类，以便在功能开发中快速调用平台能力。

#### 验收标准

1. THE App SHALL 提供 ClipboardUtil 工具类，封装系统剪贴板的读写操作并提供复制成功的反馈
2. THE App SHALL 提供 DialogUtil 工具类，封装文件选择对话框和确认对话框的调用
3. THE App SHALL 提供 KeyboardShortcutUtil 工具类，支持注册和注销全局键盘快捷键
4. THE App SHALL 提供 NotificationUtil 工具类，封装桌面系统通知的发送
5. THE App SHALL 提供 ShellUtil 工具类，封装打开 URL 和在文件管理器中显示文件的操作

### 需求 11：UI 组件库扩展

**用户故事：** 作为开发者，我希望有一组通用的 UI 组件，以便在各功能页面中复用。

#### 验收标准

1. THE App SHALL 提供 LoadingOverlay 组件，在内容区域上方显示半透明加载遮罩和加载指示器
2. THE App SHALL 提供 EmptyState 组件，显示图标、标题和描述文本，用于空数据状态展示
3. THE App SHALL 提供 ConfirmDialog 组件，显示标题、描述和确认/取消按钮，返回用户选择结果
4. THE App SHALL 提供 ToastNotification 服务，支持 success、error、info 三种类型的短暂提示消息
5. THE App SHALL 提供 PageHeader 组件，显示页面标题、副标题和可选的操作按钮区域
6. WHEN 上述 UI 组件被使用时，THE 组件 SHALL 自动适配当前主题（亮色/暗色）并使用毛玻璃设计风格

### 需求 12：项目结构与开发体验

**用户故事：** 作为开发者，我希望项目结构规范且有完善的代码检查规则，以便团队协作高效。

#### 验收标准

1. THE App SHALL 按照以下目录结构组织 core 模块：config/、errors/、logger/、services/、utils/、extensions/
2. THE App SHALL 配置 analysis_options.yaml 文件，启用严格的 lint 规则
3. THE App SHALL 在 pubspec.yaml 中合理组织依赖项，新增必要的系统托盘和路径获取依赖
