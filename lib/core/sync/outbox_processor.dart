import 'dart:convert';
import 'package:drift/drift.dart';
import '../database/app_database.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class OutboxProcessor {
  final AppDatabase db;
  bool _isProcessing = false;

  OutboxProcessor(this.db);

  /// Called when network connectivity is restored or periodically.
  Future<void> processOutbox() async {
    if (_isProcessing) return;
    
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return; // No network, skip processing
    }

    _isProcessing = true;
    try {
      // Get all pending or failed items that haven't exceeded retry limits
      final pendingItems = await (db.select(db.outbox)
            ..where((t) => t.status.isIn(['pending', 'failed']))
            ..where((t) => t.retryCount.isSmallerThanValue(5))
            ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.asc)]))
          .get();

      for (final item in pendingItems) {
        await _processSingleItem(item);
      }
    } finally {
      _isProcessing = false;
    }
  }

  Future<void> _processSingleItem(OutboxData item) async {
    // Mark as processing
    await (db.update(db.outbox)..where((t) => t.id.equals(item.id))).write(
      OutboxCompanion(status: const Value('processing')),
    );

    try {
      // Example payload parsing
      final payload = jsonDecode(item.payload);
      
      bool success = false;
      if (item.type == 'diagnosis') {
        success = await _syncDiagnosis(item.clientUuid, payload);
      }

      if (success) {
        // Mark as synced or delete from outbox
        await (db.update(db.outbox)..where((t) => t.id.equals(item.id))).write(
          OutboxCompanion(status: const Value('synced')),
        );
      } else {
        // Increment retry count
        await _markAsFailed(item);
      }
    } catch (e) {
      await _markAsFailed(item);
    }
  }

  Future<void> _markAsFailed(OutboxData item) async {
    await (db.update(db.outbox)..where((t) => t.id.equals(item.id))).write(
      OutboxCompanion(
        status: const Value('failed'),
        retryCount: Value(item.retryCount + 1),
      ),
    );
  }

  Future<bool> _syncDiagnosis(String clientUuid, Map<String, dynamic> payload) async {
    // TODO: Implement actual Supabase sync logic
    // This is where you would upload the image and insert into Supabase
    
    // For now, simulate success
    await Future.delayed(const Duration(milliseconds: 500));
    return true; 
  }
}
