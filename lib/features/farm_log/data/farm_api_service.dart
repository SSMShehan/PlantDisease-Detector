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

  // Farm Tasks
  Future<List<FarmTask>> getFarmTasks() async {
    final response = await _supabase.from('farm_tasks').select().order('created_at', ascending: false);
    return (response as List).map((json) => FarmTask.fromJson(json)).toList();
  }

  Future<void> toggleTaskStatus(String taskId, bool isDone) async {
    await _supabase.from('farm_tasks').update({'is_done': isDone}).eq('id', taskId);
  }

  // Yield Entries
  Future<List<YieldEntry>> getYieldEntries() async {
    final response = await _supabase.from('yield_entries').select().order('date', ascending: true);
    return (response as List).map((json) => YieldEntry.fromJson(json)).toList();
  }
}
