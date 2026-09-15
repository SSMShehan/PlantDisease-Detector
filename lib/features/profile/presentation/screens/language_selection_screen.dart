import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_disease_detector/core/theme/app_theme.dart';
import 'package:plant_disease_detector/core/providers/locale_provider.dart';

class LanguageSelectionScreen extends ConsumerStatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  ConsumerState<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState
    extends ConsumerState<LanguageSelectionScreen> {
  String _selectedCode = 'en';

  final List<Map<String, String>> _languages = [
    {'code': 'en', 'name': 'English', 'localName': 'English'},
    {'code': 'si', 'name': 'Sinhala', 'localName': 'සිංහල'},
    {'code': 'ta', 'name': 'Tamil', 'localName': 'தமிழ்'},
  ];

  @override
  void initState() {
    super.initState();
    // Reflect whatever locale is already saved
    _selectedCode = ref.read(localeProvider).languageCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () {
            if (context.canPop()) context.pop();
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
              ..._languages.map((lang) =>
                  _buildLanguageCard(lang['code']!, lang['name']!, lang['localName']!)),
              const Spacer(),
              ElevatedButton(
                onPressed: () async {
                  // Persist & propagate the chosen locale via Riverpod
                  await ref
                      .read(localeProvider.notifier)
                      .setLocale(Locale(_selectedCode));
                  if (mounted) {
                    context.go('/onboarding');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  minimumSize: const Size(double.infinity, 56),
                ),
                child: Text('Continue',
                    style: AppTextStyles.titleMedium
                        .copyWith(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageCard(String code, String name, String localName) {
    final bool isSelected = _selectedCode == code;

    return GestureDetector(
      onTap: () => setState(() => _selectedCode = code),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
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
                Text(
                  localName,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    fontSize: 18,
                  ),
                ),
                if (name != localName) ...[
                  const SizedBox(height: 4),
                  Text(
                    name,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.8)
                          : AppColors.textSecondary,
                    ),
                  ),
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
