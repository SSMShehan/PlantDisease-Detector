import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_disease_detector/models/disease_result.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ScanHistoryNotifier — holds the list of ScanRecords.
//
// Currently initialises with mockScanHistory for demo purposes.
// When Supabase is wired up, replace the initial data with a
// Supabase query:
//   final rows = await supabase.from('diagnoses')
//       .select('*, diseases(*)')
//       .order('created_at', ascending: false);
// ─────────────────────────────────────────────────────────────────────────────
class ScanHistoryNotifier extends Notifier<List<ScanRecord>> {
  @override
  List<ScanRecord> build() => List.from(mockScanHistory);

  /// Add a new scan at the front of the history list.
  void addScan(ScanRecord scan) {
    state = [scan, ...state];
  }

  /// Remove a scan by id.
  void removeScan(int id) {
    state = state.where((s) => s.id != id).toList();
  }

  /// Replace the full history list (used when loading from Supabase).
  void setHistory(List<ScanRecord> records) {
    state = records;
  }
}

final scanHistoryProvider =
    NotifierProvider<ScanHistoryNotifier, List<ScanRecord>>(
  ScanHistoryNotifier.new,
);
