import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:test_app3/core/logger/logger.dart';

/// Key-value storage service backed by a JSON file.
///
/// Uses `{appDataDir}/app-storage.json` as the underlying storage.
/// Supports dependency injection of a custom [filePath] for testing.
///
/// **Requirements:** 5.1, 5.2, 5.3, 5.4, 5.5
class StorageService {
  /// Creates a [StorageService].
  ///
  /// If [filePath] is provided it is used directly (useful for testing).
  /// Otherwise [init] will resolve the path via `path_provider`.
  StorageService({String? filePath}) : _customFilePath = filePath;

  final String? _customFilePath;

  /// The resolved path to the JSON storage file.
  late String _filePath;

  /// In-memory cache of the stored key-value pairs.
  Map<String, dynamic> _data = {};

  /// Whether [init] has been called successfully.
  bool _initialized = false;

  // ------------------------------------------------------------------
  // Public API
  // ------------------------------------------------------------------

  /// Initialises the storage service.
  ///
  /// Reads the existing JSON file or creates an empty map if the file
  /// does not exist. If reading fails the service initialises with empty
  /// data and logs the error (Requirement 5.5).
  Future<void> init() async {
    if (_customFilePath != null) {
      _filePath = _customFilePath!;
    } else {
      final dir = await getApplicationSupportDirectory();
      _filePath = '${dir.path}/app-storage.json';
    }

    try {
      final file = File(_filePath);
      if (file.existsSync()) {
        final contents = file.readAsStringSync();
        final decoded = jsonDecode(contents);
        if (decoded is Map<String, dynamic>) {
          _data = decoded;
        } else {
          _data = {};
        }
      } else {
        _data = {};
      }
    } catch (e, stack) {
      // Requirement 5.5 – initialise with empty data and log the error.
      _data = {};
      AppLogger.error('storage', 'Failed to read storage file', e, stack);
    }

    _initialized = true;
  }

  /// Returns the value associated with [key], or `null` if the key does
  /// not exist (Requirement 5.4).
  T? get<T>(String key) {
    _assertInitialized();
    final value = _data[key];
    if (value is T) {
      return value;
    }
    return null;
  }

  /// Stores [value] under [key] and immediately persists to disk
  /// (Requirement 5.3).
  Future<void> set(String key, dynamic value) async {
    _assertInitialized();
    _data[key] = value;
    await _persist();
  }

  /// Removes [key] from storage and immediately persists to disk.
  Future<void> delete(String key) async {
    _assertInitialized();
    _data.remove(key);
    await _persist();
  }

  /// Returns `true` if [key] exists in storage.
  bool has(String key) {
    _assertInitialized();
    return _data.containsKey(key);
  }

  // ------------------------------------------------------------------
  // Internal helpers
  // ------------------------------------------------------------------

  /// Writes the current in-memory data to the JSON file.
  Future<void> _persist() async {
    try {
      final file = File(_filePath);
      final parent = file.parent;
      if (!parent.existsSync()) {
        parent.createSync(recursive: true);
      }
      file.writeAsStringSync(jsonEncode(_data), flush: true);
    } catch (e, stack) {
      AppLogger.error('storage', 'Failed to write storage file', e, stack);
    }
  }

  /// Throws a [StateError] if [init] has not been called.
  void _assertInitialized() {
    if (!_initialized) {
      throw StateError(
        'StorageService has not been initialized. Call init() first.',
      );
    }
  }
}
