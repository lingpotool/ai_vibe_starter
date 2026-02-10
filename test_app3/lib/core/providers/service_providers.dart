import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app3/core/services/event_bus.dart';
import 'package:test_app3/core/services/storage_service.dart';

/// Singleton [EventBus] instance.
///
/// Provides a single shared event bus for loosely-coupled cross-component
/// communication throughout the application.
///
/// Usage:
/// ```dart
/// final bus = ref.read(eventBusProvider);
/// bus.emit('user:login', {'name': 'Alice'});
/// ```
final eventBusProvider = Provider<EventBus>((ref) {
  return EventBus();
});

/// Singleton [StorageService] instance.
///
/// **Important:** The [StorageService.init] method must be called before
/// the service is used (typically during application startup in `main()`).
/// This provider only creates the instance; initialisation is a separate step.
///
/// Usage:
/// ```dart
/// // In main.dart, after creating the ProviderContainer:
/// final storage = container.read(storageServiceProvider);
/// await storage.init();
///
/// // Elsewhere in the app:
/// final storage = ref.read(storageServiceProvider);
/// final value = storage.get<String>('key');
/// ```
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});
