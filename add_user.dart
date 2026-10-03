import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );

  final supabase = Supabase.instance.client;

  try {
    final response = await supabase.auth.signUp(
      email: 'officer@gmail.com',
      password: 'officer123',
      data: {
        'full_name': 'Agriculture Officer',
        'district': 'Colombo',
      },
    );
    print('User added successfully: ${response.user?.id}');
  } catch (e) {
    print('Failed to add user: $e');
  }
  exit(0);
}
