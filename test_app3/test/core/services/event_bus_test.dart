import 'package:flutter_test/flutter_test.dart';
import 'package:test_app3/core/services/event_bus.dart';

void main() {
  late EventBus bus;

  setUp(() {
    bus = EventBus();
  });

  group('EventBus', () {
    group('on / emit', () {
      test('handler receives emitted data', () {
        dynamic received;
        bus.on('test', (data) => received = data);

        bus.emit('test', 'hello');

        expect(received, 'hello');
      });

      test('handler receives null when emit called without data', () {
        dynamic received = 'sentinel';
        bus.on('test', (data) => received = data);

        bus.emit('test');

        expect(received, isNull);
      });

      test('multiple handlers all receive the event', () {
        final calls = <int>[];
        bus.on('evt', (_) => calls.add(1));
        bus.on('evt', (_) => calls.add(2));
        bus.on('evt', (_) => calls.add(3));

        bus.emit('evt');

        expect(calls, [1, 2, 3]);
      });

      test('handlers for different events are independent', () {
        final aCalls = <String>[];
        final bCalls = <String>[];
        bus.on('a', (data) => aCalls.add(data as String));
        bus.on('b', (data) => bCalls.add(data as String));

        bus.emit('a', 'alpha');
        bus.emit('b', 'beta');

        expect(aCalls, ['alpha']);
        expect(bCalls, ['beta']);
      });

      test('emit with no listeners does not throw', () {
        expect(() => bus.emit('nonexistent', 42), returnsNormally);
      });

      test('emit passes complex data correctly', () {
        dynamic received;
        bus.on('data', (data) => received = data);

        final payload = {'key': 'value', 'count': 42};
        bus.emit('data', payload);

        expect(received, payload);
      });
    });

    group('off', () {
      test('removes only the specified handler', () {
        final calls = <String>[];
        void handlerA(dynamic _) => calls.add('A');
        void handlerB(dynamic _) => calls.add('B');

        bus.on('evt', handlerA);
        bus.on('evt', handlerB);

        bus.off('evt', handlerA);
        bus.emit('evt');

        expect(calls, ['B']);
      });

      test('off for non-existent event does not throw', () {
        void handler(dynamic _) {}
        expect(() => bus.off('nope', handler), returnsNormally);
      });

      test('off for non-registered handler does not affect others', () {
        final calls = <String>[];
        void handlerA(dynamic _) => calls.add('A');
        void handlerB(dynamic _) => calls.add('B');

        bus.on('evt', handlerA);
        bus.off('evt', handlerB); // handlerB was never registered
        bus.emit('evt');

        expect(calls, ['A']);
      });

      test('handler is not called after being removed', () {
        var count = 0;
        void handler(dynamic _) => count++;

        bus.on('evt', handler);
        bus.emit('evt');
        expect(count, 1);

        bus.off('evt', handler);
        bus.emit('evt');
        expect(count, 1); // not called again
      });
    });

    group('once', () {
      test('handler is called on first emit', () {
        var count = 0;
        bus.once('evt', (_) => count++);

        bus.emit('evt');

        expect(count, 1);
      });

      test('handler is NOT called on second emit', () {
        var count = 0;
        bus.once('evt', (_) => count++);

        bus.emit('evt');
        bus.emit('evt');

        expect(count, 1);
      });

      test('once handler receives correct data', () {
        dynamic received;
        bus.once('evt', (data) => received = data);

        bus.emit('evt', 'payload');

        expect(received, 'payload');
      });

      test('once handler can be removed via off before firing', () {
        var count = 0;
        void handler(dynamic _) => count++;

        bus.once('evt', handler);
        bus.off('evt', handler);
        bus.emit('evt');

        expect(count, 0);
      });

      test('once handler does not interfere with regular handlers', () {
        final calls = <String>[];
        bus.on('evt', (_) => calls.add('regular'));
        bus.once('evt', (_) => calls.add('once'));

        bus.emit('evt');
        expect(calls, ['regular', 'once']);

        calls.clear();
        bus.emit('evt');
        expect(calls, ['regular']); // once handler removed
      });

      test('multiple once handlers on same event each fire once', () {
        var countA = 0;
        var countB = 0;
        bus.once('evt', (_) => countA++);
        bus.once('evt', (_) => countB++);

        bus.emit('evt');
        expect(countA, 1);
        expect(countB, 1);

        bus.emit('evt');
        expect(countA, 1);
        expect(countB, 1);
      });
    });

    group('clear', () {
      test('clear(event) removes all listeners for that event', () {
        var count = 0;
        bus.on('evt', (_) => count++);
        bus.on('evt', (_) => count++);

        bus.clear('evt');
        bus.emit('evt');

        expect(count, 0);
      });

      test('clear(event) does not affect other events', () {
        var aCount = 0;
        var bCount = 0;
        bus.on('a', (_) => aCount++);
        bus.on('b', (_) => bCount++);

        bus.clear('a');
        bus.emit('a');
        bus.emit('b');

        expect(aCount, 0);
        expect(bCount, 1);
      });

      test('clear() removes all listeners for all events', () {
        var aCount = 0;
        var bCount = 0;
        bus.on('a', (_) => aCount++);
        bus.on('b', (_) => bCount++);

        bus.clear();
        bus.emit('a');
        bus.emit('b');

        expect(aCount, 0);
        expect(bCount, 0);
      });

      test('clear for non-existent event does not throw', () {
        expect(() => bus.clear('nonexistent'), returnsNormally);
      });

      test('clear also removes once handlers', () {
        var count = 0;
        bus.once('evt', (_) => count++);

        bus.clear('evt');
        bus.emit('evt');

        expect(count, 0);
      });
    });

    group('edge cases', () {
      test('emit during emit (handler registers new handler)', () {
        final calls = <int>[];
        bus.on('evt', (_) {
          calls.add(1);
          // Register a new handler during emit — should NOT be called
          // in this iteration since we iterate over a copy.
          bus.on('evt', (_) => calls.add(2));
        });

        bus.emit('evt');
        expect(calls, [1]);

        calls.clear();
        bus.emit('evt');
        // Now both handlers should fire
        expect(calls, [1, 2]);
      });

      test('off during emit does not skip remaining handlers', () {
        final calls = <String>[];
        void handlerA(dynamic _) => calls.add('A');
        void handlerB(dynamic _) {
          calls.add('B');
          bus.off('evt', handlerA); // remove A during iteration
        }

        bus.on('evt', handlerA);
        bus.on('evt', handlerB);

        // Both should still fire because we iterate over a copy
        bus.emit('evt');
        expect(calls, contains('A'));
        expect(calls, contains('B'));
      });

      test('re-registering same handler after off works', () {
        var count = 0;
        void handler(dynamic _) => count++;

        bus.on('evt', handler);
        bus.off('evt', handler);
        bus.on('evt', handler);
        bus.emit('evt');

        expect(count, 1);
      });
    });
  });
}
