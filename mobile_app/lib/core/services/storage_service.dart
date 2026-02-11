import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:mobile_app/core/logger/logger.dart';

/// Key-value storage service backed by a JSON file.
class StorageService {
  StorageService({String? filePath}) : _customFilePath = filePath;

  final String? _customFilePath;
  late String _filePath;
  Map<String, dynamic> _data = {};
  bool _initialized = false;

  Future<void> init() async {
    if (_customFilePath != null) {
      _filePath = _customFilePath;
    } else {
      final dir = await getApplicationSupportDirectory();
      _filePath = '${dir.path}/app-storage.json';
    }
    try {
      final file = File(_filePath);
      if (file.existsSync()) {
        final decoded = jsonDecode(file.readAsStringSync());
        _data = decoded is Map<String, dynamic> ? decoded : {};
      }
    } catch (e, stack) {
      _data = {};
      AppLogger.error('storage', 'Failed to read storage file', e, stack);
    }
    _initialized = true;
  }

  T? get<T>(String key) { _assertInit(); final v = _data[key]; return v is T ? v : null; }
  Future<void> set(String key, dynamic value) async { _assertInit(); _data[key] = value; await _persist(); }
  Future<void> delete(String key) async { _assertInit(); _data.remove(key); await _persist(); }
  bool has(String key) { _assertInit(); return _data.containsKey(key); }

  Future<void> _persist() async {
    try {
      final file = File(_filePath);
      if (!file.parent.existsSync()) file.parent.createSync(recursive: true);
      file.writeAsStringSync(jsonEncode(_data), flush: true);
    } catch (e, stack) {
      AppLogger.error('storage', 'Failed to write storage file', e, stack);
    }
  }

  void _assertInit() {
    if (!_initialized) throw StateError('StorageService not initialized. Call init() first.');
  }
}
