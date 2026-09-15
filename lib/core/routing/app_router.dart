import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:plant_disease_detector/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:plant_disease_detector/features/auth/presentation/screens/login_screen.dart';
import 'package:plant_disease_detector/features/auth/presentation/screens/signup_screen.dart';
import 'package:plant_disease_detector/features/auth/presentation/screens/otp_verification_screen.dart';
import 'package:plant_disease_detector/features/home/presentation/screens/main_screen.dart';
import 'package:plant_disease_detector/features/home/presentation/screens/home_screen.dart';
import 'package:plant_disease_detector/features/home/presentation/screens/saved_items_screen.dart';
import 'package:plant_disease_detector/features/diagnosis/presentation/screens/camera_capture_screen.dart';
import 'package:plant_disease_detector/features/diagnosis/presentation/screens/scanning_screen.dart';
import 'package:plant_disease_detector/features/diagnosis/presentation/screens/photo_guide_screen.dart';
import 'package:plant_disease_detector/features/diagnosis/presentation/screens/diagnostic_result_screen.dart';
import 'package:plant_disease_detector/features/treatment/presentation/screens/treatment_detail_screen.dart';
import 'package:plant_disease_detector/features/treatment/presentation/screens/treatment_reminder_screen.dart';
import 'package:plant_disease_detector/features/treatment/presentation/screens/disease_catalogue_screen.dart';
import 'package:plant_disease_detector/features/treatment/presentation/screens/disease_comparison_screen.dart';
import 'package:plant_disease_detector/features/history/presentation/screens/history_screen.dart';
import 'package:plant_disease_detector/features/profile/presentation/screens/profile_screen.dart';
import 'package:plant_disease_detector/features/profile/presentation/screens/settings_screen.dart';
import 'package:plant_disease_detector/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:plant_disease_detector/features/weather/presentation/screens/weather_forecast_screen.dart';
import 'package:plant_disease_detector/features/tips/presentation/screens/tips_feed_screen.dart';
import 'package:plant_disease_detector/features/tips/presentation/screens/tip_detail_screen.dart';
import 'package:plant_disease_detector/features/sync/presentation/screens/sync_status_screen.dart';
import 'package:plant_disease_detector/features/farm_log/presentation/screens/farm_screen.dart';
import 'package:plant_disease_detector/features/farm_log/presentation/screens/add_farm_log_screen.dart';
import 'package:plant_disease_detector/features/expert_consult/presentation/screens/expert_consult_screen.dart';
import 'package:plant_disease_detector/features/expert_consult/presentation/screens/consultation_status_screen.dart';

// New Screens
import 'package:plant_disease_detector/features/profile/presentation/screens/language_selection_screen.dart';
import 'package:plant_disease_detector/features/profile/presentation/screens/notifications_screen.dart';
import 'package:plant_disease_detector/features/community/presentation/screens/community_feed_screen.dart';
import 'package:plant_disease_detector/features/farm_log/presentation/screens/yield_tracker_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/language',
  routes: [
    GoRoute(
      path: '/language',
      builder: (context, state) => const LanguageSelectionScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: '/otp',
      builder: (context, state) => const OtpVerificationScreen(),
    ),
    GoRoute(
      path: '/main',
      builder: (context, state) => const MainScreen(),
    ),
    // Additional direct access routes, usually these are handled inside MainScreen (bottom nav), 
    // but useful to have for deep linking or direct navigation.
    GoRoute(
      path: '/camera_capture',
      builder: (context, state) => const CameraCaptureScreen(),
    ),
    GoRoute(
      path: '/scanning',
      builder: (context, state) => const ScanningScreen(),
    ),
    GoRoute(
      path: '/diagnostic_result',
      builder: (context, state) => const DiagnosticResultScreen(),
    ),
    GoRoute(
      path: '/treatment_detail',
      builder: (context, state) => const TreatmentDetailScreen(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: '/community',
      builder: (context, state) => const CommunityFeedScreen(),
    ),
    GoRoute(
      path: '/yield',
      builder: (context, state) => const YieldTrackerScreen(),
    ),
  ],
);
