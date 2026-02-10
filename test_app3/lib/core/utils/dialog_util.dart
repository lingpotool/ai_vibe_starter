import 'package:flutter/material.dart';

/// Utility wrapper for common dialog operations.
///
/// Provides static helpers for file-picker and confirmation dialogs,
/// keeping call-sites concise.
///
/// **Validates: Requirements 10.2**
class DialogUtil {
  // Private constructor – all members are static.
  DialogUtil._();

  /// Shows a simple file-picker dialog that lets the user select a file.
  ///
  /// [extensions] optionally restricts the selectable file types
  /// (e.g. `['png', 'jpg']`).
  ///
  /// Returns the selected file path, or `null` if the user cancelled.
  ///
  /// > **Note:** This is a placeholder implementation using a simple
  /// > text-input dialog. Replace with `file_picker` or native dialog
  /// > integration for production use.
  static Future<String?> pickFile(
    BuildContext context, {
    List<String>? extensions,
  }) async {
    final controller = TextEditingController();
    final extensionHint =
        extensions != null && extensions.isNotEmpty
            ? 'Allowed: ${extensions.join(', ')}'
            : 'All files';

    final result = await showDialog<String>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Select File'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(extensionHint),
                const SizedBox(height: 8),
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: 'Enter file path',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(null),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(controller.text),
                child: const Text('OK'),
              ),
            ],
          ),
    );

    controller.dispose();
    return (result != null && result.isNotEmpty) ? result : null;
  }

  /// Shows a confirmation dialog with [title] and optional [message].
  ///
  /// Returns `true` if the user confirmed, `false` otherwise.
  static Future<bool> confirm(
    BuildContext context, {
    required String title,
    String? message,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(title),
            content: message != null ? Text(message) : null,
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Confirm'),
              ),
            ],
          ),
    );
    return result ?? false;
  }
}
