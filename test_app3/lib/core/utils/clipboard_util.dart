import 'package:flutter/services.dart';

/// Utility wrapper around system clipboard operations.
///
/// Delegates to Flutter's [Clipboard] class for platform-agnostic
/// clipboard access.
///
/// **Validates: Requirements 10.1**
class ClipboardUtil {
  // Private constructor – all members are static.
  ClipboardUtil._();

  /// Reads the current text content from the system clipboard.
  ///
  /// Returns an empty string if the clipboard is empty or contains
  /// non-text data.
  static Future<String> read() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    return data?.text ?? '';
  }

  /// Writes [text] to the system clipboard.
  static Future<void> write(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }
}
