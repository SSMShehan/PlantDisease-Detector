import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:plant_disease_detector/features/farm_log/data/farm_api_service.dart';
import 'package:plant_disease_detector/features/farm_log/data/farm_models.dart';

final farmApiServiceProvider = Provider<FarmApiService>((ref) {
  final supabase = Supabase.instance.client;
  return FarmApiService(supabase);
});

// Providers for each data set
final fieldBlocksProvider = FutureProvider<List<FieldBlock>>((ref) async {
  final api = ref.watch(farmApiServiceProvider);
  return api.getFieldBlocks();
});

final farmTasksProvider = FutureProvider<List<FarmTask>>((ref) async {
  final api = ref.watch(farmApiServiceProvider);
  return api.getFarmTasks();
});

final yieldEntriesProvider = FutureProvider<List<YieldEntry>>((ref) async {
  final api = ref.watch(farmApiServiceProvider);
  return api.getYieldEntries();
});

// A notifier to manage farm task toggling
class FarmTaskNotifier extends StateNotifier<AsyncValue<List<FarmTask>>> {
  final FarmApiService _api;

  FarmTaskNotifier(this._api) : super(const AsyncValue.loading()) {
    refresh();
  }

  Future<void> refresh() async {
    try {
      state = const AsyncValue.loading();
      final tasks = await _api.getFarmTasks();
      state = AsyncValue.data(tasks);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggleTask(String taskId, bool isDone) async {
    // Optimistic update
    if (state.value != null) {
      final oldTasks = state.value!;
      final newTasks = oldTasks.map((t) => t.id == taskId ? t.copyWith(isDone: isDone) : t).toList();
      state = AsyncValue.data(newTasks);
    }
    
    try {
      await _api.toggleTaskStatus(taskId, isDone);
    } catch (e) {
      // Revert on error
      refresh();
    }
  }
}

final farmTaskNotifierProvider = StateNotifierProvider<FarmTaskNotifier, AsyncValue<List<FarmTask>>>((ref) {
  return FarmTaskNotifier(ref.watch(farmApiServiceProvider));
});
