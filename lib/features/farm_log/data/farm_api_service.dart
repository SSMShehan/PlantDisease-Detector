import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:plant_disease_detector/features/farm_log/data/farm_models.dart';

class FarmApiService {
  final SupabaseClient _supabase;

  FarmApiService(this._supabase);

  // Field Blocks
  Future<List<FieldBlock>> getFieldBlocks() async {
    final response = await _supabase.from('field_blocks').select().order('created_at', ascending: true);
    return (response as List).map((json) => FieldBlock.fromJson(json)).toList();
  }

  Future<void> createFieldBlock(Map<String, dynamic> data) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;
    data['user_id'] = user.id;
    await _supabase.from('field_blocks').insert(data);
  }

  Future<void> updateFieldBlock(String id, Map<String, dynamic> updates) async {
    await _supabase.from('field_blocks').update(updates).eq('id', id);
  }

  Future<void> deleteFieldBlock(String id) async {
    await _supabase.from('field_blocks').delete().eq('id', id);
  }

  // Farm Tasks
  Future<List<FarmTask>> getFarmTasks() async {
    final response = await _supabase.from('farm_tasks').select().order('created_at', ascending: false);
    return (response as List).map((json) => FarmTask.fromJson(json)).toList();
  }

  Future<void> createFarmTask(Map<String, dynamic> data) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;
    data['user_id'] = user.id;
    await _supabase.from('farm_tasks').insert(data);
  }

  Future<void> updateFarmTask(String id, Map<String, dynamic> updates) async {
    await _supabase.from('farm_tasks').update(updates).eq('id', id);
  }

  Future<void> toggleTaskStatus(String taskId, bool isDone) async {
    await _supabase.from('farm_tasks').update({'is_done': isDone}).eq('id', taskId);
  }

  Future<void> deleteFarmTask(String id) async {
    await _supabase.from('farm_tasks').delete().eq('id', id);
  }

  // Yield Entries
  Future<List<YieldEntry>> getYieldEntries() async {
    final response = await _supabase.from('yield_entries').select().order('date', ascending: true);
    return (response as List).map((json) => YieldEntry.fromJson(json)).toList();
  }

  Future<void> createYieldEntry(Map<String, dynamic> data) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;
    data['user_id'] = user.id;
    await _supabase.from('yield_entries').insert(data);
  }

  Future<void> updateYieldEntry(String id, Map<String, dynamic> updates) async {
    await _supabase.from('yield_entries').update(updates).eq('id', id);
  }

  Future<void> deleteYieldEntry(String id) async {
    await _supabase.from('yield_entries').delete().eq('id', id);
  }
}
