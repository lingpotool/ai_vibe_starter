import '../services/system_service.dart';

/// Utility wrapper for shell / OS-level operations.
///
/// Delegates to [SystemService] for the actual platform calls, keeping
/// call-sites concise and decoupled from the service layer.
///
/// **Validates: Requirements 10.5**
class ShellUtil {
  // Private constructor – all members are static.
  ShellUtil._();

  /// Opens [url] in the system default browser.
  static Future<void> openUrl(String url) async {
    await SystemService.openUrl(url);
  }

  /// Reveals the file or folder at [path] in the native file manager.
  static Future<void> showInFolder(String path) async {
    await SystemService.showInFolder(path);
  }
}
