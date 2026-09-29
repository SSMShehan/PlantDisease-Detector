import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_disease_detector/core/providers/locale_provider.dart';
import 'package:plant_disease_detector/core/theme/app_theme.dart';

/// A reusable top-right Language Selector Dropdown button.
/// Clicking it opens a dropdown popup menu with the 3 languages (English, සිංහල, தமிழ்).
/// It changes the language instantly in-place without navigating away.
class LanguageSelectorButton extends ConsumerWidget {
  final bool isDark;
  final bool isCompact;
  final EdgeInsetsGeometry? padding;

  const LanguageSelectorButton({
    super.key,
    this.isDark = false,
    this.isCompact = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch locale so the current language label updates dynamically
    final locale = ref.watch(localeProvider);
    final currentLang = locale.languageCode;

    final String displayLabel = switch (currentLang) {
      'si' => 'සිංහල',
      'ta' => 'தமிழ்',
      _ => 'English',
    };

    final Color foregroundColor = isDark ? Colors.white : AppColors.textPrimary;
    final Color iconColor = isDark ? Colors.white : AppColors.primary;
    final Color arrowColor = isDark ? Colors.white70 : AppColors.textSecondary;
    final Color backgroundColor = isDark
        ? Colors.black.withValues(alpha: 0.4)
        : AppColors.primary.withValues(alpha: 0.08);
    final Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.25)
        : AppColors.primary.withValues(alpha: 0.2);

    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      child: Theme(
        // Ensure popup menu theme is crisp and modern
        data: Theme.of(context).copyWith(
          popupMenuTheme: PopupMenuThemeData(
            color: Colors.white,
            surfaceTintColor: Colors.transparent,
            elevation: 10,
            shadowColor: Colors.black.withValues(alpha: 0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(
                color: Colors.black.withValues(alpha: 0.06),
                width: 1,
              ),
            ),
          ),
        ),
        child: PopupMenuButton<String>(
          tooltip: 'Select Language / භාෂාව තෝරන්න',
          offset: const Offset(0, 42),
          position: PopupMenuPosition.under,
          onSelected: (String langCode) async {
            if (langCode != currentLang) {
              await ref.read(localeProvider.notifier).setLocale(Locale(langCode));
            }
          },
          itemBuilder: (BuildContext popupContext) => [
            _buildPopupItem(
              code: 'en',
              title: 'English',
              badge: 'EN',
              isSelected: currentLang == 'en',
            ),
            const PopupMenuDivider(height: 1),
            _buildPopupItem(
              code: 'si',
              title: 'සිංහල',
              badge: 'SI',
              isSelected: currentLang == 'si',
            ),
            const PopupMenuDivider(height: 1),
            _buildPopupItem(
              code: 'ta',
              title: 'தமிழ்',
              badge: 'TA',
              isSelected: currentLang == 'ta',
            ),
          ],
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isCompact ? 10 : 12,
              vertical: isCompact ? 6 : 7,
            ),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor, width: 1.2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.language_rounded,
                  size: isCompact ? 16 : 18,
                  color: iconColor,
                ),
                const SizedBox(width: 5),
                Text(
                  displayLabel,
                  style: TextStyle(
                    fontSize: isCompact ? 12 : 13,
                    fontWeight: FontWeight.w700,
                    color: foregroundColor,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: isCompact ? 16 : 18,
                  color: arrowColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildPopupItem({
    required String code,
    required String title,
    required String badge,
    required bool isSelected,
  }) {
    return PopupMenuItem<String>(
      value: code,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              badge,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 16),
          if (isSelected)
            const Icon(
              Icons.check_circle_rounded,
              size: 18,
              color: AppColors.primary,
            )
          else
            const SizedBox(width: 18),
        ],
      ),
    );
  }
}
