import 'package:flutter/widgets.dart';

/// Utility for managing global keyboard shortcuts.
///
/// Works with Flutter's [Shortcuts] / [Actions] system by maintaining
/// a mutable map of shortcut activators to callbacks that can be
/// registered and unregistered at runtime.
///
/// **Validates: Requirements 10.3**
class KeyboardShortcutUtil {
  // Private constructor – all members are static.
  KeyboardShortcutUtil._();

  /// The currently registered shortcuts.
  ///
  /// Consumers can wrap their widget tree with a [Shortcuts] widget
  /// that references these bindings via [CallbackAction].
  static final Map<ShortcutActivator, VoidCallback> _shortcuts = {};

  /// Returns an unmodifiable view of the currently registered shortcuts.
  static Map<ShortcutActivator, VoidCallback> get shortcuts =>
      Map.unmodifiable(_shortcuts);

  /// Registers one or more keyboard shortcuts.
  ///
  /// If a shortcut with the same activator already exists it will be
  /// overwritten.
  static void register(Map<ShortcutActivator, VoidCallback> shortcuts) {
    _shortcuts.addAll(shortcuts);
  }

  /// Unregisters the shortcut for the given [activator].
  static void unregister(ShortcutActivator activator) {
    _shortcuts.remove(activator);
  }

  /// Removes all registered shortcuts.
  static void clear() {
    _shortcuts.clear();
  }
}
