/// Callback type for event handlers.
typedef EventHandler = void Function(dynamic data);

/// A simple synchronous event bus for loosely-coupled cross-component
/// communication.
///
/// Usage:
/// ```dart
/// final bus = EventBus();
/// bus.on('user:login', (data) => print('Logged in: $data'));
/// bus.emit('user:login', {'name': 'Alice'});
/// ```
class EventBus {
  /// Internal storage: event name → set of handler functions.
  final Map<String, Set<EventHandler>> _listeners = {};

  /// Maps original handlers registered via [once] to their wrapper functions,
  /// so that [off] can correctly remove a once-handler before it fires.
  final Map<String, Map<EventHandler, EventHandler>> _onceWrappers = {};

  /// Register a [handler] for the given [event].
  ///
  /// The handler will be called every time [emit] is invoked for this event.
  void on(String event, EventHandler handler) {
    _listeners.putIfAbsent(event, () => {});
    _listeners[event]!.add(handler);
  }

  /// Remove a specific [handler] from the given [event].
  ///
  /// If the handler was registered via [once], the internal wrapper is also
  /// cleaned up. Other listeners for the same event are not affected.
  void off(String event, EventHandler handler) {
    final handlers = _listeners[event];
    if (handlers == null) return;

    // Check if this handler was registered via `once` and hasn't fired yet.
    final wrappers = _onceWrappers[event];
    if (wrappers != null && wrappers.containsKey(handler)) {
      final wrapper = wrappers.remove(handler)!;
      handlers.remove(wrapper);
      if (wrappers.isEmpty) _onceWrappers.remove(event);
    } else {
      handlers.remove(handler);
    }

    if (handlers.isEmpty) _listeners.remove(event);
  }

  /// Synchronously notify all registered listeners for the given [event].
  ///
  /// Iterates over a snapshot of the listener set to avoid concurrent
  /// modification when once-handlers remove themselves during iteration.
  void emit(String event, [dynamic data]) {
    final handlers = _listeners[event];
    if (handlers == null || handlers.isEmpty) return;

    // Iterate over a copy to avoid concurrent modification.
    for (final handler in handlers.toList()) {
      handler(data);
    }
  }

  /// Register a [handler] that will be called at most once for the given
  /// [event]. After the first invocation the handler is automatically removed.
  void once(String event, EventHandler handler) {
    late final EventHandler wrapper;
    wrapper = (dynamic data) {
      // Remove the wrapper from the listener set.
      _listeners[event]?.remove(wrapper);
      if (_listeners[event]?.isEmpty ?? false) {
        _listeners.remove(event);
      }

      // Clean up the once-wrapper mapping.
      _onceWrappers[event]?.remove(handler);
      if (_onceWrappers[event]?.isEmpty ?? false) {
        _onceWrappers.remove(event);
      }

      // Invoke the original handler.
      handler(data);
    };

    // Track the wrapper so `off` can find it.
    _onceWrappers.putIfAbsent(event, () => {});
    _onceWrappers[event]![handler] = wrapper;

    on(event, wrapper);
  }

  /// Remove all listeners for a specific [event], or all listeners entirely
  /// if [event] is `null`.
  void clear([String? event]) {
    if (event != null) {
      _listeners.remove(event);
      _onceWrappers.remove(event);
    } else {
      _listeners.clear();
      _onceWrappers.clear();
    }
  }
}
