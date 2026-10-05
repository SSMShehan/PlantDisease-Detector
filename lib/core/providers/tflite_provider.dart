import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/diagnosis/data/tflite_service.dart';

final tfliteProvider = Provider<TfLiteService>((ref) {
  return TfLiteService();
});

final tfliteInitProvider = FutureProvider<void>((ref) async {
  final service = ref.read(tfliteProvider);
  await service.initialize();
});
