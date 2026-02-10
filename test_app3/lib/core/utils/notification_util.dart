import 'package:local_notifier/local_notifier.dart';

/// Utility wrapper for sending desktop system notifications.
///
/// Uses the `local_notifier` package to display native OS notifications.
///
/// **Validates: Requirements 10.4**
class NotificationUtil {
  // Private constructor – all members are static.
  NotificationUtil._();

  /// Sends a desktop notification with the given [title] and [body].
  static Future<void> show({
    required String title,
    required String body,
  }) async {
    final notification = LocalNotification(title: title, body: body);
    await notification.show();
  }
}
