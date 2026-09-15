import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final prefs = await SharedPreferences.getInstance();
    setState(UserData(
      fullName: prefs.getString('fullName') ?? 'Sunil Perera',
      phoneNumber: prefs.getString('phoneNumber') ?? '+94 77 123 4567',
      email: prefs.getString('email') ?? 'sunil.p@farmmail.com',
      district: prefs.getString('district') ?? 'Ussapitiya, Sri Lanka',
      farmName: prefs.getString('farmName') ?? 'Sunil Organic Farm',
      farmSize: prefs.getString('farmSize') ?? '12.5',
      bio: prefs.getString('bio') ?? 'Passionate organic farmer with 15 years of experience in sustainable agriculture.',
      primaryCrops: prefs.getStringList('primaryCrops') ?? ['Rice', 'Tomato'],
      imagePath: prefs.getString('imagePath'),
    ));
  }

  Future<void> saveUserData(UserData user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fullName', user.fullName);
    await prefs.setString('phoneNumber', user.phoneNumber);
    await prefs.setString('email', user.email);
    await prefs.setString('district', user.district);
    await prefs.setString('farmName', user.farmName);
    await prefs.setString('farmSize', user.farmSize);
    await prefs.setString('bio', user.bio);
    await prefs.setStringList('primaryCrops', user.primaryCrops);
    if (user.imagePath != null) {
      await prefs.setString('imagePath', user.imagePath!);
    } else {
      await prefs.remove('imagePath');
    }

    state = user; // Update the Riverpod state
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserData>((ref) {
  return UserNotifier();
});
