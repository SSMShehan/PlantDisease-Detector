import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_disease_detector/models/disease_result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ScanHistoryNotifier extends AsyncNotifier<List<ScanRecord>> {
  @override
  Future<List<ScanRecord>> build() async {
    return _fetchScans();
  }

  Future<List<ScanRecord>> _fetchScans() async {
    final client = Supabase.instance.client;
    final user = client.auth.currentUser;
    if (user == null) return [];
    
    final data = await client
        .from('scans')
        .select()
        .eq('user_id', user.id)
        .order('scanned_at', ascending: false);
        
    return (data as List).map((row) => ScanRecord.fromJson(row)).toList();
  }

  Future<void> addScan(ScanRecord scan) async {
    final previousState = await future;
    state = AsyncValue.data([scan, ...previousState]);
  }

  Future<void> removeScan(String id) async {
    final previousState = await future;
    state = AsyncValue.data(previousState.where((s) => s.id != id).toList());
    
    try {
      await Supabase.instance.client.from('scans').delete().eq('id', id);
    } catch (e) {
      // Revert if delete fails
      state = AsyncValue.data(previousState);
    }
  }
}

final scanHistoryProvider =
    AsyncNotifierProvider<ScanHistoryNotifier, List<ScanRecord>>(
  ScanHistoryNotifier.new,
);
