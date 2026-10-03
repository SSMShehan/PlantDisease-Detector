import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_disease_detector/models/outbreak_report.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final outbreakProvider = FutureProvider<List<OutbreakReport>>((ref) async {
  final client = Supabase.instance.client;
  final response = await client.from('outbreak_reports').select();
  return (response as List).map((row) => OutbreakReport.fromJson(row)).toList();
});

class OutbreakService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<void> createOutbreak(Map<String, dynamic> data) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Not logged in');
    data['reporter_id'] = user.id;
    await _client.from('outbreak_reports').insert(data);
  }

  Future<void> updateOutbreak(String id, Map<String, dynamic> updates) async {
    await _client.from('outbreak_reports').update(updates).eq('id', id);
  }

  Future<void> deleteOutbreak(String id) async {
    await _client.from('outbreak_reports').delete().eq('id', id);
  }
}
