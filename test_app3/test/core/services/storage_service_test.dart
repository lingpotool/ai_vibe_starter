import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:test_app3/core/services/storage_service.dart';

void main() {
  late Directory tempDir;
  late String filePath;
  late StorageService service;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('storage_test_');
    filePath = '${tempDir.path}/app-storage.json';
    service = StorageService(filePath: filePath);
  });

  tearDown(() {
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  group('StorageService', () {
    group('init', () {
      test('initialises with empty data when file does not exist', () async {
        await service.init();

        expect(service.has('anything'), isFalse);
      });

      test('reads existing JSON file on init', () async {
        // Pre-populate the file.
        File(filePath).writeAsStringSync(jsonEncode({'name': 'Alice'}));

        await service.init();

        expect(service.get<String>('name'), 'Alice');
      });

      test('initialises with empty data when file contains invalid JSON',
          () async {
        File(filePath).writeAsStringSync('not valid json!!!');

        await service.init();

        // Requirement 5.5 – should recover with empty data.
        expect(service.has('anything'), isFalse);
      });

      test(
          'initialises with empty data when file contains a JSON array instead of object',
          () async {
        File(filePath).writeAsStringSync(jsonEncode([1, 2, 3]));

        await service.init();

        expect(service.has('anything'), isFalse);
      });
    });

    group('get', () {
      test('returns null when key does not exist (Requirement 5.4)', () async {
        await service.init();

        expect(service.get<String>('missing'), isNull);
      });

      test('returns the stored value with correct type', () async {
        await service.init();
        await service.set('count', 42);

        expect(service.get<int>('count'), 42);
      });

      test('returns null when type does not match', () async {
        await service.init();
        await service.set('count', 42);

        // Requesting as String when the value is int.
        expect(service.get<String>('count'), isNull);
      });

      test('returns stored string value', () async {
        await service.init();
        await service.set('greeting', 'hello');

        expect(service.get<String>('greeting'), 'hello');
      });

      test('returns stored boolean value', () async {
        await service.init();
        await service.set('enabled', true);

        expect(service.get<bool>('enabled'), isTrue);
      });

      test('returns stored list value', () async {
        await service.init();
        await service.set('items', [1, 2, 3]);

        expect(service.get<List>('items'), [1, 2, 3]);
      });

      test('returns stored map value', () async {
        await service.init();
        await service.set('nested', {'a': 1});

        final result = service.get<Map>('nested');
        expect(result, {'a': 1});
      });
    });

    group('set', () {
      test('stores a value that can be retrieved', () async {
        await service.init();
        await service.set('key', 'value');

        expect(service.get<String>('key'), 'value');
      });

      test('overwrites an existing value', () async {
        await service.init();
        await service.set('key', 'old');
        await service.set('key', 'new');

        expect(service.get<String>('key'), 'new');
      });

      test('immediately persists to disk (Requirement 5.3)', () async {
        await service.init();
        await service.set('persisted', 'yes');

        // Read the file directly to verify persistence.
        final contents = File(filePath).readAsStringSync();
        final decoded = jsonDecode(contents) as Map<String, dynamic>;
        expect(decoded['persisted'], 'yes');
      });

      test('persists multiple values correctly', () async {
        await service.init();
        await service.set('a', 1);
        await service.set('b', 'two');
        await service.set('c', true);

        final contents = File(filePath).readAsStringSync();
        final decoded = jsonDecode(contents) as Map<String, dynamic>;
        expect(decoded['a'], 1);
        expect(decoded['b'], 'two');
        expect(decoded['c'], true);
      });
    });

    group('delete', () {
      test('removes a key from storage', () async {
        await service.init();
        await service.set('key', 'value');
        await service.delete('key');

        expect(service.has('key'), isFalse);
        expect(service.get<String>('key'), isNull);
      });

      test('persists deletion to disk', () async {
        await service.init();
        await service.set('key', 'value');
        await service.delete('key');

        final contents = File(filePath).readAsStringSync();
        final decoded = jsonDecode(contents) as Map<String, dynamic>;
        expect(decoded.containsKey('key'), isFalse);
      });

      test('deleting a non-existent key does not throw', () async {
        await service.init();

        expect(() => service.delete('nonexistent'), returnsNormally);
      });

      test('does not affect other keys', () async {
        await service.init();
        await service.set('a', 1);
        await service.set('b', 2);
        await service.delete('a');

        expect(service.has('a'), isFalse);
        expect(service.get<int>('b'), 2);
      });
    });

    group('has', () {
      test('returns false for non-existent key', () async {
        await service.init();

        expect(service.has('missing'), isFalse);
      });

      test('returns true for existing key', () async {
        await service.init();
        await service.set('key', 'value');

        expect(service.has('key'), isTrue);
      });

      test('returns false after key is deleted', () async {
        await service.init();
        await service.set('key', 'value');
        await service.delete('key');

        expect(service.has('key'), isFalse);
      });

      test('returns true for key with null value', () async {
        await service.init();
        await service.set('key', null);

        expect(service.has('key'), isTrue);
      });
    });

    group('uninitialized access', () {
      test('get throws StateError before init', () {
        expect(() => service.get<String>('key'), throwsStateError);
      });

      test('set throws StateError before init', () {
        expect(() => service.set('key', 'value'), throwsStateError);
      });

      test('delete throws StateError before init', () {
        expect(() => service.delete('key'), throwsStateError);
      });

      test('has throws StateError before init', () {
        expect(() => service.has('key'), throwsStateError);
      });
    });

    group('persistence across instances', () {
      test('new instance reads data written by previous instance', () async {
        await service.init();
        await service.set('persistent', 'data');

        // Create a new instance pointing to the same file.
        final service2 = StorageService(filePath: filePath);
        await service2.init();

        expect(service2.get<String>('persistent'), 'data');
      });
    });
  });
}
