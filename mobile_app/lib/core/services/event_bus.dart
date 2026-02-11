typedef EventHandler = void Function(dynamic data);

/// A simple synchronous event bus for loosely-coupled communication.
class EventBus {
  final Map<String, Set<EventHandler>> _listeners = {};
  final Map<String, Map<EventHandler, EventHandler>> _onceWrappers = {};

  void on(String event, EventHandler handler) {
    _listeners.putIfAbsent(event, () => {});
    _listeners[event]!.add(handler);
  }

  void off(String event, EventHandler handler) {
    final handlers = _listeners[event];
    if (handlers == null) return;
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

  void emit(String event, [dynamic data]) {
    final handlers = _listeners[event];
    if (handlers == null || handlers.isEmpty) return;
    for (final handler in handlers.toList()) {
      handler(data);
    }
  }

  void once(String event, EventHandler handler) {
    late final EventHandler wrapper;
    wrapper = (dynamic data) {
      _listeners[event]?.remove(wrapper);
      if (_listeners[event]?.isEmpty ?? false) _listeners.remove(event);
      _onceWrappers[event]?.remove(handler);
      if (_onceWrappers[event]?.isEmpty ?? false) _onceWrappers.remove(event);
      handler(data);
    };
    _onceWrappers.putIfAbsent(event, () => {});
    _onceWrappers[event]![handler] = wrapper;
    on(event, wrapper);
  }

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
