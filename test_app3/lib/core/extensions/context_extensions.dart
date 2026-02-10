import 'package:flutter/material.dart';

/// Convenience extensions on [BuildContext] for quick access to
/// commonly used theme and media-query properties.
extension BuildContextExtensions on BuildContext {
  /// The current [ThemeData].
  ThemeData get theme => Theme.of(this);

  /// The current [ColorScheme].
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// The current [TextTheme].
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Whether the current theme brightness is [Brightness.dark].
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  /// Whether the current theme brightness is [Brightness.light].
  bool get isLight => Theme.of(this).brightness == Brightness.light;

  /// The current [MediaQueryData].
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// The current screen size via [MediaQuery.sizeOf].
  Size get screenSize => MediaQuery.sizeOf(this);
}
