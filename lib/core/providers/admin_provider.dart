import 'package:supabase_flutter/supabase_flutter.dart';

class Announcement {
  final String id;
  final String title;
  final String content;
  final String priority;

  Announcement({required this.id, required this.title, required this.content, required this.priority});
  factory Announcement.fromJson(Map<String, dynamic> json) => Announcement(
    id: json['id'] as String,
    title: json['title'] as String,
    content: json['content'] as String,
    priority: json['priority'] as String,
  );
}

class FeedbackEntry {
  final String id;
  final String userId;
  final String category;
  final String content;

  FeedbackEntry({required this.id, required this.userId, required this.category, required this.content});
  factory FeedbackEntry.fromJson(Map<String, dynamic> json) => FeedbackEntry(
    id: json['id'] as String,
    userId: json['user_id'] as String,
    category: json['category'] as String,
    content: json['content'] as String,
  );
}

class AdminApiService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Announcements CRUD
  Future<List<Announcement>> getAnnouncements() async {
    final response = await _supabase.from('announcements').select().order('created_at', ascending: false);
    return (response as List).map((json) => Announcement.fromJson(json)).toList();
  }

  Future<void> createAnnouncement(Map<String, dynamic> data) async {
    await _supabase.from('announcements').insert(data);
  }

  Future<void> updateAnnouncement(String id, Map<String, dynamic> updates) async {
    await _supabase.from('announcements').update(updates).eq('id', id);
  }

  Future<void> deleteAnnouncement(String id) async {
    await _supabase.from('announcements').delete().eq('id', id);
  }

  // Feedback CRUD
  Future<List<FeedbackEntry>> getFeedback() async {
    final response = await _supabase.from('feedback').select().order('created_at', ascending: false);
    return (response as List).map((json) => FeedbackEntry.fromJson(json)).toList();
  }

  Future<void> submitFeedback(Map<String, dynamic> data) async {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      data['user_id'] = user.id;
    }
    await _supabase.from('feedback').insert(data);
  }

  Future<void> updateFeedback(String id, Map<String, dynamic> updates) async {
    await _supabase.from('feedback').update(updates).eq('id', id);
  }

  Future<void> deleteFeedback(String id) async {
    await _supabase.from('feedback').delete().eq('id', id);
  }
}
