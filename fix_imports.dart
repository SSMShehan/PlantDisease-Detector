import 'dart:io';

void main() {
  final baseDir = Directory('lib');
  
  final screenMoves = {
    "onboarding_screen.dart": "features/onboarding/presentation/screens/onboarding_screen.dart",
    "login_screen.dart": "features/auth/presentation/screens/login_screen.dart",
    "otp_verification_screen.dart": "features/auth/presentation/screens/otp_verification_screen.dart",
    "signup_screen.dart": "features/auth/presentation/screens/signup_screen.dart",
    "camera_capture_screen.dart": "features/diagnosis/presentation/screens/camera_capture_screen.dart",
    "scanning_screen.dart": "features/diagnosis/presentation/screens/scanning_screen.dart",
    "diagnostic_result_screen.dart": "features/diagnosis/presentation/screens/diagnostic_result_screen.dart",
    "photo_guide_screen.dart": "features/diagnosis/presentation/screens/photo_guide_screen.dart",
    "history_screen.dart": "features/history/presentation/screens/history_screen.dart",
    "treatment_detail_screen.dart": "features/treatment/presentation/screens/treatment_detail_screen.dart",
    "treatment_reminder_screen.dart": "features/treatment/presentation/screens/treatment_reminder_screen.dart",
    "disease_catalogue_screen.dart": "features/treatment/presentation/screens/disease_catalogue_screen.dart",
    "disease_comparison_screen.dart": "features/treatment/presentation/screens/disease_comparison_screen.dart",
    "expert_consult_screen.dart": "features/expert_consult/presentation/screens/expert_consult_screen.dart",
    "consultation_status_screen.dart": "features/expert_consult/presentation/screens/consultation_status_screen.dart",
    "farm_screen.dart": "features/farm_log/presentation/screens/farm_screen.dart",
    "add_farm_log_screen.dart": "features/farm_log/presentation/screens/add_farm_log_screen.dart",
    "weather_forecast_screen.dart": "features/weather/presentation/screens/weather_forecast_screen.dart",
    "tips_feed_screen.dart": "features/tips/presentation/screens/tips_feed_screen.dart",
    "tip_detail_screen.dart": "features/tips/presentation/screens/tip_detail_screen.dart",
    "profile_screen.dart": "features/profile/presentation/screens/profile_screen.dart",
    "edit_profile_screen.dart": "features/profile/presentation/screens/edit_profile_screen.dart",
    "settings_screen.dart": "features/profile/presentation/screens/settings_screen.dart",
    "sync_status_screen.dart": "features/sync/presentation/screens/sync_status_screen.dart",
    "main_screen.dart": "features/home/presentation/screens/main_screen.dart",
    "home_screen.dart": "features/home/presentation/screens/home_screen.dart",
    "saved_items_screen.dart": "features/home/presentation/screens/saved_items_screen.dart",
  };

  final files = baseDir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));

  for (final file in files) {
    String content = file.readAsStringSync();
    String newContent = content;

    for (final entry in screenMoves.entries) {
      newContent = newContent.replaceAll(
        "package:plant_disease_detector/screens/${entry.key}",
        "package:plant_disease_detector/${entry.value}"
      );
    }

    newContent = newContent.replaceAll(
      "package:plant_disease_detector/theme/",
      "package:plant_disease_detector/core/theme/"
    );
    newContent = newContent.replaceAll(
      "package:plant_disease_detector/widgets/",
      "package:plant_disease_detector/shared/widgets/"
    );
    newContent = newContent.replaceAll(
      "package:plant_disease_detector/utils/",
      "package:plant_disease_detector/shared/utils/"
    );

    if (newContent != content) {
      file.writeAsStringSync(newContent);
      print('Updated imports in ${file.path}');
    }
  }

  print('Import fixing complete.');
}
