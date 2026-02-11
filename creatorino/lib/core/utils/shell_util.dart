import '../services/system_service.dart';

class ShellUtil {
  ShellUtil._();
  static Future<void> openUrl(String url) async => SystemService.openUrl(url);
}
