import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final announcementsProvider = StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
  final supabase = Supabase.instance.client;
  return supabase
      .from('announcements')
      .stream(primaryKey: ['id'])
      .eq('is_published', true)
      .order('created_at', ascending: false);
});
