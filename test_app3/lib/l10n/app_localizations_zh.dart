// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => 'My App';

  @override
  String get home => '首页';

  @override
  String get settings => '设置';

  @override
  String get welcome => '欢迎使用';

  @override
  String get appDescription => '一个精致的桌面应用模板，基于 Flutter 构建。';

  @override
  String get quickStart => '快速开始';

  @override
  String get step1 => '在 lib/features/ 下创建新的功能模块';

  @override
  String get step2 => '在 router.dart 中添加路由配置';

  @override
  String get step3 => '侧边栏菜单根据路由自动生成';

  @override
  String get step4 => '使用 Riverpod 管理状态';

  @override
  String get activeToday => '今日活跃';

  @override
  String get totalTasks => '总任务数';

  @override
  String get completion => '完成率';

  @override
  String get pending => '待处理';

  @override
  String get darkMode => '暗色模式';

  @override
  String get darkModeDesc => '切换应用的亮色/暗色主题';

  @override
  String get language => '语言';

  @override
  String get languageDesc => '切换应用显示语言';

  @override
  String get about => '关于';

  @override
  String get appVersion => '应用版本';

  @override
  String get currentPlatform => '当前平台';

  @override
  String get appearance => '外观';
}
