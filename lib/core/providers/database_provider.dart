import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../sync/outbox_processor.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final outboxProcessorProvider = Provider<OutboxProcessor>((ref) {
  final db = ref.watch(databaseProvider);
  return OutboxProcessor(db);
});
