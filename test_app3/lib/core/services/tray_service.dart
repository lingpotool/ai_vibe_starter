import 'dart:io';

import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

import '../config/app_config.dart';
import '../logger/logger.dart';

const String _kModule = 'tray';

/// System tray icon and context menu service.
///
/// Uses the `tray_manager` package to create a tray icon with a right-click
/// context menu ("显示窗口" / "退出") and handles double-click to show and
/// focus the application window via `window_manager`.
///
/// Call [init] during application startup and [dispose] before shutdown.
class TrayService with TrayListener {
  TrayService._();

  static final TrayService _instance = TrayService._();

  /// Whether the tray has been initialised successfully.
  static bool _initialised = false;

  // ------------------------------------------------------------------
  // Menu item keys
  // ------------------------------------------------------------------
  static const String _kShowWindowKey = 'show_window';
  static const String _kExitKey = 'exit';

  // ------------------------------------------------------------------
  // Public API
  // ------------------------------------------------------------------

  /// Initialise the system tray icon and context menu.
  ///
  /// - Requirement 7.1: Creates a tray icon on app startup.
  /// - Requirement 7.2: Provides "显示窗口" and "退出" context menu items.
  /// - Requirement 7.3: Double-click shows and focuses the window.
  /// - Requirement 7.4: "退出" closes the application window.
  ///
  /// Errors are logged via [AppLogger] and silently swallowed so that a
  /// tray failure never prevents the application from running.
  static Future<void> init() async {
    try {
      // Set the tray icon.
      await trayManager.setIcon(_iconPath());

      // Set tooltip to the application name.
      await trayManager.setToolTip(AppConfig.name);

      // Build the context menu.
      final menu = Menu(
        items: [
          MenuItem(
            key: _kShowWindowKey,
            label: '显示窗口',
          ),
          MenuItem.separator(),
          MenuItem(
            key: _kExitKey,
            label: '退出',
          ),
        ],
      );
      await trayManager.setContextMenu(menu);

      // Register the listener for tray events.
      trayManager.addListener(_instance);

      _initialised = true;
      AppLogger.info(_kModule, 'System tray initialised');
    } catch (e, st) {
      // Tray is non-critical – log and continue.
      AppLogger.error(_kModule, 'Failed to initialise system tray', e, st);
    }
  }

  /// Tear down the system tray icon and remove the event listener.
  static Future<void> dispose() async {
    if (!_initialised) return;
    try {
      trayManager.removeListener(_instance);
      await trayManager.destroy();
      _initialised = false;
      AppLogger.info(_kModule, 'System tray disposed');
    } catch (e, st) {
      AppLogger.error(_kModule, 'Failed to dispose system tray', e, st);
    }
  }

  // ------------------------------------------------------------------
  // TrayListener overrides
  // ------------------------------------------------------------------

  /// Requirement 7.3: Double-click (mouse-up after mouse-down) shows and
  /// focuses the application window.
  @override
  void onTrayIconMouseDown() {
    _showAndFocusWindow();
  }

  /// Requirement 7.2 / 7.4: Handle context menu item clicks.
  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    switch (menuItem.key) {
      case _kShowWindowKey:
        _showAndFocusWindow();
        break;
      case _kExitKey:
        _closeWindow();
        break;
    }
  }

  /// Right-click on the tray icon pops up the context menu.
  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
  }

  // ------------------------------------------------------------------
  // Internal helpers
  // ------------------------------------------------------------------

  /// Shows and focuses the application window.
  static Future<void> _showAndFocusWindow() async {
    try {
      await windowManager.show();
      await windowManager.focus();
    } catch (e, st) {
      AppLogger.error(_kModule, 'Failed to show/focus window', e, st);
    }
  }

  /// Closes the application window (Requirement 7.4).
  static Future<void> _closeWindow() async {
    try {
      await windowManager.close();
    } catch (e, st) {
      AppLogger.error(_kModule, 'Failed to close window', e, st);
    }
  }

  /// Returns the platform-appropriate icon path for the tray icon.
  ///
  /// On Windows the `.ico` format is preferred; on other platforms `.png`
  /// is used. The icon is expected to reside in the Flutter assets folder.
  /// If no dedicated tray icon exists, falls back to the app icon bundled
  /// with the runner.
  static String _iconPath() {
    if (Platform.isWindows) {
      return 'assets/app_icon.ico';
    }
    return 'assets/app_icon.png';
  }
}
