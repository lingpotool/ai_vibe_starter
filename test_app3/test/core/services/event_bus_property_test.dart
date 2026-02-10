/// Property-based tests for EventBus emit behavior.
///
/// **Validates: Requirements 3.2**
///
/// Property 2: EventBus emit 通知所有监听器
///
/// *For any* event name and any number (≥1) of registered listeners, when
/// EventBus.emit is called, all registered listeners SHALL be called exactly
/// once, and receive the correct event data.
import 'package:glados/glados.dart';
import 'package:test_app3/core/services/event_bus.dart';

/// Custom generator for listener counts between 1 and 10.
extension EventBusGenerators on Any {
  Generator<int> get listenerCount => choose([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
}

void main() {
  group('Property 2: EventBus emit 通知所有监听器', () {
    /// **Validates: Requirements 3.2**

    Glados2(any.letterOrDigits, any.listenerCount,
            ExploreConfig(numRuns: 100))
        .test(
      'all N registered listeners are called exactly once on emit',
      (String eventName, int count) {
        final bus = EventBus();

        // Track how many times each listener is called.
        final callCounts = List<int>.filled(count, 0);

        // Register N listeners.
        for (var i = 0; i < count; i++) {
          final index = i;
          bus.on(eventName, (_) {
            callCounts[index]++;
          });
        }

        // Emit the event once.
        bus.emit(eventName);

        // Each listener should have been called exactly once.
        for (var i = 0; i < count; i++) {
          expect(callCounts[i], equals(1),
              reason: 'Listener $i should be called exactly once, '
                  'but was called ${callCounts[i]} times');
        }
      },
    );

    Glados3(any.letterOrDigits, any.listenerCount, any.int,
            ExploreConfig(numRuns: 100))
        .test(
      'all listeners receive the correct event data',
      (String eventName, int count, int eventData) {
        final bus = EventBus();

        // Track the data each listener receives.
        final receivedData = List<int?>.filled(count, null);

        // Register N listeners that capture the received data.
        for (var i = 0; i < count; i++) {
          final index = i;
          bus.on(eventName, (data) {
            receivedData[index] = data as int;
          });
        }

        // Emit the event with data.
        bus.emit(eventName, eventData);

        // Each listener should have received the correct data.
        for (var i = 0; i < count; i++) {
          expect(receivedData[i], equals(eventData),
              reason: 'Listener $i should receive $eventData, '
                  'but received ${receivedData[i]}');
        }
      },
    );

    Glados2(any.letterOrDigits, any.listenerCount,
            ExploreConfig(numRuns: 100))
        .test(
      'emit with null data delivers null to all listeners',
      (String eventName, int count) {
        final bus = EventBus();

        // Use a sentinel value to distinguish "not called" from "called with null".
        const sentinel = 'NOT_CALLED';
        final receivedData = List<dynamic>.filled(count, sentinel);

        for (var i = 0; i < count; i++) {
          final index = i;
          bus.on(eventName, (data) {
            receivedData[index] = data;
          });
        }

        // Emit without data (data defaults to null).
        bus.emit(eventName);

        for (var i = 0; i < count; i++) {
          expect(receivedData[i], isNull,
              reason: 'Listener $i should receive null when emit is called '
                  'without data, but received ${receivedData[i]}');
        }
      },
    );
  });

  /// **Validates: Requirements 3.3**
  ///
  /// Property 3: EventBus once 自动移除
  ///
  /// *For any* event name, a handler registered via EventBus.once SHALL be
  /// auto-removed after the first emit. The second emit of the same event
  /// SHALL NOT call that handler.
  group('Property 3: EventBus once 自动移除', () {
    /// **Validates: Requirements 3.3**

    Glados(any.letterOrDigits, ExploreConfig(numRuns: 100)).test(
      'once handler is called exactly once on first emit and not on second emit',
      (String eventName) {
        final bus = EventBus();
        var callCount = 0;

        // Register a handler via once.
        bus.once(eventName, (_) {
          callCount++;
        });

        // First emit — handler should be called.
        bus.emit(eventName);
        expect(callCount, equals(1),
            reason: 'once handler should be called exactly once after first '
                'emit, but was called $callCount times');

        // Second emit — handler should NOT be called again.
        bus.emit(eventName);
        expect(callCount, equals(1),
            reason: 'once handler should not be called on second emit, '
                'but total call count is $callCount');
      },
    );

    Glados2(any.letterOrDigits, any.int, ExploreConfig(numRuns: 100)).test(
      'once handler receives correct data on first emit',
      (String eventName, int eventData) {
        final bus = EventBus();
        dynamic receivedData;
        var callCount = 0;

        bus.once(eventName, (data) {
          receivedData = data;
          callCount++;
        });

        // First emit with data.
        bus.emit(eventName, eventData);
        expect(callCount, equals(1),
            reason: 'once handler should be called exactly once');
        expect(receivedData, equals(eventData),
            reason: 'once handler should receive $eventData, '
                'but received $receivedData');

        // Second emit — handler should not fire again.
        bus.emit(eventName, eventData + 1);
        expect(callCount, equals(1),
            reason: 'once handler should not be called on second emit');
        expect(receivedData, equals(eventData),
            reason: 'receivedData should still be $eventData from first emit');
      },
    );

    Glados(any.letterOrDigits, ExploreConfig(numRuns: 100)).test(
      'once handler removal does not affect other persistent listeners',
      (String eventName) {
        final bus = EventBus();
        var onceCallCount = 0;
        var persistentCallCount = 0;

        // Register a persistent listener via on().
        bus.on(eventName, (_) {
          persistentCallCount++;
        });

        // Register a one-time listener via once().
        bus.once(eventName, (_) {
          onceCallCount++;
        });

        // First emit — both should fire.
        bus.emit(eventName);
        expect(onceCallCount, equals(1),
            reason: 'once handler should fire on first emit');
        expect(persistentCallCount, equals(1),
            reason: 'persistent handler should fire on first emit');

        // Second emit — only persistent should fire.
        bus.emit(eventName);
        expect(onceCallCount, equals(1),
            reason: 'once handler should NOT fire on second emit');
        expect(persistentCallCount, equals(2),
            reason: 'persistent handler should fire on second emit');
      },
    );
  });

  /// **Validates: Requirements 3.4**
  ///
  /// Property 4: EventBus clear 清除监听器
  ///
  /// *For any* EventBus state, calling clear(event) SHALL only remove all
  /// listeners for the specified event, other events' listeners SHALL remain
  /// unchanged. Calling clear() (no argument) SHALL remove all listeners for
  /// all events.
  group('Property 4: EventBus clear 清除监听器', () {
    /// **Validates: Requirements 3.4**

    Glados2(any.letterOrDigits, any.letterOrDigits,
            ExploreConfig(numRuns: 100))
        .test(
      'clear(eventA) removes eventA listeners but eventB listeners remain',
      (String rawA, String rawB) {
        // Ensure two distinct event names.
        final eventA = 'a_$rawA';
        final eventB = 'b_$rawB';

        final bus = EventBus();
        var callCountA = 0;
        var callCountB = 0;

        // Register listeners on both events.
        bus.on(eventA, (_) {
          callCountA++;
        });
        bus.on(eventB, (_) {
          callCountB++;
        });

        // Verify both listeners work before clear.
        bus.emit(eventA);
        bus.emit(eventB);
        expect(callCountA, equals(1),
            reason: 'eventA listener should fire before clear');
        expect(callCountB, equals(1),
            reason: 'eventB listener should fire before clear');

        // Clear only eventA.
        bus.clear(eventA);

        // Reset counters.
        callCountA = 0;
        callCountB = 0;

        // Emit both events again.
        bus.emit(eventA);
        bus.emit(eventB);

        expect(callCountA, equals(0),
            reason: 'eventA listener should NOT fire after clear(eventA)');
        expect(callCountB, equals(1),
            reason: 'eventB listener should still fire after clear(eventA)');
      },
    );

    Glados(any.listenerCount, ExploreConfig(numRuns: 100)).test(
      'clear() with no argument removes all listeners for all events',
      (int eventCount) {
        final bus = EventBus();
        final callCounts = List<int>.filled(eventCount, 0);

        // Register a listener on each distinct event.
        for (var i = 0; i < eventCount; i++) {
          final index = i;
          bus.on('event_$i', (_) {
            callCounts[index]++;
          });
        }

        // Verify all listeners work before clear.
        for (var i = 0; i < eventCount; i++) {
          bus.emit('event_$i');
        }
        for (var i = 0; i < eventCount; i++) {
          expect(callCounts[i], equals(1),
              reason: 'event_$i listener should fire before clear()');
        }

        // Clear all events.
        bus.clear();

        // Reset counters.
        for (var i = 0; i < eventCount; i++) {
          callCounts[i] = 0;
        }

        // Emit all events again.
        for (var i = 0; i < eventCount; i++) {
          bus.emit('event_$i');
        }

        // No listener should fire.
        for (var i = 0; i < eventCount; i++) {
          expect(callCounts[i], equals(0),
              reason:
                  'event_$i listener should NOT fire after clear()');
        }
      },
    );
  });

  /// **Validates: Requirements 3.5**
  ///
  /// Property 5: EventBus off 精确移除
  ///
  /// *For any* event with N registered listeners (N ≥ 2), calling off to
  /// remove one specific listener, then emitting that event SHALL only call
  /// the remaining N-1 listeners. The removed listener SHALL NOT be called.
  group('Property 5: EventBus off 精确移除', () {
    /// **Validates: Requirements 3.5**

    /// Custom generator for listener counts ≥ 2 (between 2 and 10).
    final listenerCountAtLeast2 = any.choose([2, 3, 4, 5, 6, 7, 8, 9, 10]);

    Glados3(any.letterOrDigits, listenerCountAtLeast2, any.int,
            ExploreConfig(numRuns: 100))
        .test(
      'off removes exactly one listener; remaining N-1 are still called',
      (String eventName, int count, int rawIndex) {
        // Ensure the removal index is valid for the generated count (0..count-1).
        final removeIndex = rawIndex.abs() % count;

        final bus = EventBus();

        // Track how many times each listener is called.
        final callCounts = List<int>.filled(count, 0);

        // Create and register N listeners, keeping references for off().
        final handlers = <EventHandler>[];
        for (var i = 0; i < count; i++) {
          final index = i;
          void handler(dynamic _) {
            callCounts[index]++;
          }
          handlers.add(handler);
          bus.on(eventName, handler);
        }

        // Remove the listener at removeIndex.
        bus.off(eventName, handlers[removeIndex]);

        // Emit the event.
        bus.emit(eventName);

        // The removed listener should NOT have been called.
        expect(callCounts[removeIndex], equals(0),
            reason: 'Listener at index $removeIndex was removed via off() '
                'but was still called ${callCounts[removeIndex]} times');

        // All other listeners should have been called exactly once.
        for (var i = 0; i < count; i++) {
          if (i == removeIndex) continue;
          expect(callCounts[i], equals(1),
              reason: 'Listener $i should be called exactly once, '
                  'but was called ${callCounts[i]} times');
        }
      },
    );
  });
}
