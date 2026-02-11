import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:creatorino/core/services/event_bus.dart';
import 'package:creatorino/core/services/storage_service.dart';

final eventBusProvider = Provider<EventBus>((ref) => EventBus());

final storageServiceProvider = Provider<StorageService>((ref) => StorageService());
