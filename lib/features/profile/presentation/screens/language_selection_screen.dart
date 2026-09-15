import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_disease_detector/core/theme/app_theme.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String _selectedLanguage = 'English';

  final List<Map<String, String>> _languages = [
    {'name': 'English', 'localName': 'English'},
    {'name': 'Sinhala', 'localName': 'සිංහල'},
    {'name': 'Tamil', 'localName': 'தமிழ்'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            }
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Choose your language\nභාෂාව තෝරන්න',
                style: AppTextStyles.headlineMedium.copyWith(height: 1.4),
              ),
              const SizedBox(height: 8),
              Text(
                'You can always change this later in settings.',
                style: AppTextStyles.bodyLarge,
              ),
              const SizedBox(height: 40),
              ..._languages.map((lang) => _buildLanguageCard(lang['name']!, lang['localName']!)).toList(),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  // In a real app, save to shared_preferences / Riverpod
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/onboarding');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  minimumSize: const Size(double.infinity, 56),
                ),
                child: Text('Continue', style: AppTextStyles.titleMedium.copyWith(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageCard(String id, String localName) {
    final bool isSelected = _selectedLanguage == id;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedLanguage = id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(localName, style: AppTextStyles.titleMedium.copyWith(
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                  fontSize: 18,
                )),
                if (id != localName) ...[
                  const SizedBox(height: 4),
                  Text(id, style: AppTextStyles.bodySmall.copyWith(
                    color: isSelected ? AppColors.primary.withOpacity(0.8) : AppColors.textSecondary,
                  )),
                ],
              ],
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, color: AppColors.primary)
            else
              const Icon(Icons.circle_outlined, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
