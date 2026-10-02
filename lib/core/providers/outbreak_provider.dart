import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_disease_detector/models/outbreak_report.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final outbreakProvider = FutureProvider<List<OutbreakReport>>((ref) async {
  final client = Supabase.instance.client;
  
  final response = await client.from('outbreak_reports').select();
  
  return (response as List).map((row) => OutbreakReport.fromJson(row)).toList();
});
