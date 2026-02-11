import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/services/event_bus.dart';
import 'package:mobile_app/core/services/storage_service.dart';

final eventBusProvider = Provider<EventBus>((ref) => EventBus());

final storageServiceProvider = Provider<StorageService>((ref) => StorageService());
