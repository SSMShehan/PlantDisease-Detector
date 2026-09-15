import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class UserData {
  final String fullName;
  final String phoneNumber;
  final String email;
  final String district;
  final String farmName;
  final String farmSize;
  final String bio;
  final List<String> primaryCrops;
  final String? imagePath;

  UserData({
    this.fullName = 'Sunil Perera',
    this.phoneNumber = '+94 77 123 4567',
    this.email = 'sunil.p@farmmail.com',
    this.district = 'Ussapitiya, Sri Lanka',
    this.farmName = 'Sunil Organic Farm',
    this.farmSize = '12.5',
    this.bio = 'Passionate organic farmer with 15 years of experience in sustainable agriculture.',
    this.primaryCrops = const ['Rice', 'Tomato'],
    this.imagePath,
  });

  UserData copyWith({
    String? fullName,
    String? phoneNumber,
    String? email,
    String? district,
    String? farmName,
    String? farmSize,
    String? bio,
    List<String>? primaryCrops,
    String? imagePath,
  }) {
    return UserData(
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      district: district ?? this.district,
      farmName: farmName ?? this.farmName,
      farmSize: farmSize ?? this.farmSize,
      bio: bio ?? this.bio,
      primaryCrops: primaryCrops ?? this.primaryCrops,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}

class UserNotifier extends StateNotifier<UserData> {
  UserNotifier() : super(UserData()) {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final client = Supabase.instance.client;
    final user = client.auth.currentUser;
    if (user != null) {
      try {
        final data = await client.from('profiles').select().eq('id', user.id).maybeSingle();
        if (data != null) {
          state = UserData(
            fullName: data['full_name'] ?? 'Sunil Perera',
            phoneNumber: data['phone'] ?? '+94 77 123 4567',
            email: data['email'] ?? 'sunil.p@farmmail.com',
            district: data['district'] ?? 'Ussapitiya, Sri Lanka',
            farmName: data['farm_name'] ?? 'Sunil Organic Farm',
            farmSize: data['farm_size'] ?? '12.5',
            bio: data['bio'] ?? 'Passionate organic farmer with 15 years of experience.',
            primaryCrops: (data['primary_crops'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? ['Rice', 'Tomato'],
            imagePath: data['avatar_url'],
          );
          return;
        }
      } catch (e) {
        debugPrint('Error loading profile from Supabase: $e');
      }
    }
    // Fallback if not logged in
    state = UserData();
  }

  Future<void> saveUserData(UserData user) async {
    final client = Supabase.instance.client;
    final authUser = client.auth.currentUser;
    
    if (authUser != null) {
      try {
        await client.from('profiles').update({
          'full_name': user.fullName,
          'phone': user.phoneNumber,
          'email': user.email,
          'district': user.district,
          'farm_name': user.farmName,
          'farm_size': user.farmSize,
          'bio': user.bio,
          'primary_crops': user.primaryCrops,
          'avatar_url': user.imagePath,
          'updated_at': DateTime.now().toIso8601String(),
        }).eq('id', authUser.id);
      } catch (e) {
        debugPrint('Error saving profile to Supabase: $e');
      }
    } else {
      debugPrint('No logged in user, could not save to Supabase');
    }

    state = user; // Update the Riverpod state
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserData>((ref) {
  return UserNotifier();
});
