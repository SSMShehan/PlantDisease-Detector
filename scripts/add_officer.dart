// ignore_for_file: avoid_print
// Run with: dart run scripts/add_officer.dart

import 'dart:convert';
import 'dart:io';

const String supabaseUrl = 'https://zoqameluujemvtpfbrmm.supabase.co';
const String supabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpvcWFtZWx1dWplbXZ0cGZicm1tIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODk0OTQxNzIsImV4cCI6MjEwNTA3MDE3Mn0.i-zPCIfhKMLCKJXcGzGYsOxJJ0AH7Sd0oxueIPtVWZE';

const String officerEmail = 'officer@gmail.com';
const String officerPassword = 'officer123';

Future<void> main() async {
  print('Creating officer account in Supabase...');

  final client = HttpClient();
  try {
    final uri = Uri.parse('$supabaseUrl/auth/v1/signup');
    final request = await client.postUrl(uri);
    request.headers.set('Content-Type', 'application/json');
    request.headers.set('apikey', supabaseAnonKey);
    request.headers.set('Authorization', 'Bearer $supabaseAnonKey');

    final body = jsonEncode({
      'email': officerEmail,
      'password': officerPassword,
      'data': {
        'full_name': 'Agriculture Officer',
        'district': 'Colombo',
      },
    });
    request.write(body);

    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    final json = jsonDecode(responseBody) as Map<String, dynamic>;

    if (response.statusCode == 200 || response.statusCode == 201) {
      final userId = json['user']?['id'] ?? json['id'];
      print('✅ Officer created successfully!');
      print('   Email   : $officerEmail');
      print('   Password: $officerPassword');
      print('   User ID : $userId');
    } else {
      final errorMsg = json['msg'] ?? json['message'] ?? json['error_description'] ?? json.toString();
      print('❌ Failed to create officer.');
      print('   Status : ${response.statusCode}');
      print('   Message: $errorMsg');
    }
  } catch (e) {
    print('❌ Error: $e');
  } finally {
    client.close();
  }
}
