/// Property-based tests for StorageService round-trip consistency.
///
/// **Validates: Requirements 5.6, 5.3**
///
/// Property 6: StorageService 往返一致性
///
/// *For any* valid `Map<String, dynamic>` (values are JSON-serializable types),
/// StorageService serializing it to a JSON file and then deserializing it SHALL
/// produce a Map equivalent to the original data.
import 'dart:io';

import 'package:glados/glados.dart';
import 'package:test_app3/core/services/storage_service.dart';

/// Generator for simple JSON-serializable values (int, String, bool, double).
extension StorageGenerators on Any {
  /// Generates a value type index (0..15), then maps to a concrete value.
  Generator<dynamic> get jsonValue =>
      any.choose([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]).map(
        (index) {
          const values = <dynamic>[
            // int values (indices 0-5)
            0,
            1,
            -1,
            42,
            -100,
            999999,
            // String values (indices 6-9)
            '',
            'hello',
            'world',
            'test value',
            // bool values (indices 10-11)
            true,
            false,
            // double values (indices 12-15)
            1.5,
            -3.14,
            99.99,
            0.5,
          ];
          return values[index];
        },
      );

  /// Generates a non-empty key string suitable for storage keys.
  Generator<String> get storageKey => any.choose([
        'key',
        'name',
        'count',
        'enabled',
        'score',
        'title',
        'description',
        'setting_1',
        'user_pref',
        'app_theme',
        'lang',
        'version',
        'debug',
        'max_retries',
        'timeout_ms',
      ]);

  /// Generates a count of key-value pairs to store (1 to 8).
  Generator<int> get pairCount => any.choose([1, 2, 3, 4, 5, 6, 7, 8]);
}

void main() {
  late Directory tempDir;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('storage_pbt_');
  });

  tearDown(() {
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  group('Property 6: StorageService 往返一致性', () {
    /// **Validates: Requirements 5.6, 5.3**

    Glados2(any.storageKey, any.jsonValue, ExploreConfig(numRuns: 100)).test(
      'single key-value round-trip: set then read from new instance produces equivalent value',
      (String key, dynamic value) async {
        final filePath = '${tempDir.path}/rt_single_${key.hashCode}.json';

        // Write phase: create a service, init, and set the value.
        final writer = StorageService(filePath: filePath);
        await writer.init();
        await writer.set(key, value);

        // Read phase: create a NEW service instance pointing to the same file.
        final reader = StorageService(filePath: filePath);
        await reader.init();

        // Verify the value round-trips correctly.
        expect(reader.has(key), isTrue,
            reason: 'Key "$key" should exist after round-trip');

        final retrieved = reader.get<dynamic>(key);

        if (value is int) {
          // JSON round-trip may convert int to num; compare as num.
          expect(retrieved, isA<num>());
          expect((retrieved as num).toInt(), equals(value),
              reason:
                  'int value should be equivalent after round-trip: expected $value, got $retrieved');
        } else if (value is double) {
          expect(retrieved, isA<num>());
          expect((retrieved as num).toDouble(), closeTo(value, 1e-10),
              reason:
                  'double value should be equivalent after round-trip: expected $value, got $retrieved');
        } else {
          expect(retrieved, equals(value),
              reason:
                  'Value should be equivalent after round-trip: expected $value, got $retrieved');
        }

        // Clean up this specific file for the next iteration.
        final file = File(filePath);
        if (file.existsSync()) {
          file.deleteSync();
        }
      },
    );

    Glados(any.pairCount, ExploreConfig(numRuns: 100)).test(
      'multiple key-value pairs round-trip: all values preserved across instances',
      (int count) async {
        final filePath = '${tempDir.path}/rt_multi_$count.json';

        // Build a map of key-value pairs to store.
        final keys = <String>[];
        final values = <dynamic>[];
        final sampleValues = [
          42,
          'hello',
          true,
          3.14,
          -7,
          'world',
          false,
          99.5,
        ];
        final sampleKeys = [
          'alpha',
          'beta',
          'gamma',
          'delta',
          'epsilon',
          'zeta',
          'eta',
          'theta',
        ];

        for (var i = 0; i < count; i++) {
          keys.add(sampleKeys[i]);
          values.add(sampleValues[i]);
        }

        // Write phase: store all key-value pairs.
        final writer = StorageService(filePath: filePath);
        await writer.init();
        for (var i = 0; i < count; i++) {
          await writer.set(keys[i], values[i]);
        }

        // Read phase: create a NEW service instance and verify all values.
        final reader = StorageService(filePath: filePath);
        await reader.init();

        for (var i = 0; i < count; i++) {
          expect(reader.has(keys[i]), isTrue,
              reason: 'Key "${keys[i]}" should exist after round-trip');

          final retrieved = reader.get<dynamic>(keys[i]);
          final original = values[i];

          if (original is int) {
            expect(retrieved, isA<num>());
            expect((retrieved as num).toInt(), equals(original),
                reason:
                    'int value for "${keys[i]}" should be equivalent after round-trip');
          } else if (original is double) {
            expect(retrieved, isA<num>());
            expect(
                (retrieved as num).toDouble(), closeTo(original, 1e-10),
                reason:
                    'double value for "${keys[i]}" should be equivalent after round-trip');
          } else {
            expect(retrieved, equals(original),
                reason:
                    'Value for "${keys[i]}" should be equivalent after round-trip');
          }
        }

        // Clean up this specific file.
        final file = File(filePath);
        if (file.existsSync()) {
          file.deleteSync();
        }
      },
    );

    Glados(any.storageKey, ExploreConfig(numRuns: 100)).test(
      'overwritten value round-trips correctly: only latest value persists',
      (String key) async {
        final filePath = '${tempDir.path}/rt_overwrite_${key.hashCode}.json';

        // Write phase: set a value, then overwrite it.
        final writer = StorageService(filePath: filePath);
        await writer.init();
        await writer.set(key, 'initial');
        await writer.set(key, 'overwritten');

        // Read phase: new instance should see only the latest value.
        final reader = StorageService(filePath: filePath);
        await reader.init();

        expect(reader.has(key), isTrue,
            reason: 'Key "$key" should exist after overwrite round-trip');
        expect(reader.get<dynamic>(key), equals('overwritten'),
            reason:
                'Only the latest value should persist after round-trip');

        // Clean up.
        final file = File(filePath);
        if (file.existsSync()) {
          file.deleteSync();
        }
      },
    );
  });
}
