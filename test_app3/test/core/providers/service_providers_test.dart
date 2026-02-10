import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_app3/core/providers/service_providers.dart';
import 'package:test_app3/core/services/event_bus.dart';
import 'package:test_app3/core/services/storage_service.dart';

void main() {
  group('service_providers', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('eventBusProvider', () {
      test('returns an EventBus instance', () {
        final bus = container.read(eventBusProvider);
        expect(bus, isA<EventBus>());
      });

      test('returns the same singleton instance on multiple reads', () {
        final bus1 = container.read(eventBusProvider);
        final bus2 = container.read(eventBusProvider);
        expect(identical(bus1, bus2), isTrue);
      });

      test('EventBus from provider is functional', () {
        final bus = container.read(eventBusProvider);
        String? received;
        bus.on('test', (data) => received = data as String);
        bus.emit('test', 'hello');
        expect(received, 'hello');
      });
    });

    group('storageServiceProvider', () {
      test('returns a StorageService instance', () {
        final storage = container.read(storageServiceProvider);
        expect(storage, isA<StorageService>());
      });

      test('returns the same singleton instance on multiple reads', () {
        final storage1 = container.read(storageServiceProvider);
        final storage2 = container.read(storageServiceProvider);
        expect(identical(storage1, storage2), isTrue);
      });

      test('StorageService requires init() before use', () {
        final storage = container.read(storageServiceProvider);
        expect(
          () => storage.get<String>('key'),
          throwsA(isA<StateError>()),
        );
      });
    });
  });
}
