import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_disease_detector/core/theme/app_theme.dart';

import 'package:plant_disease_detector/core/localization/app_strings.dart';
import 'package:plant_disease_detector/core/widgets/language_selector_button.dart';
import 'package:plant_disease_detector/shared/widgets/premium_app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_disease_detector/core/providers/announcements_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcementsAsync = ref.watch(announcementsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PremiumAppBar(
        title: Text(context.tr(en: 'Notifications', si: 'දැනුම්දීම්', ta: 'அறிவிப்புகள்')),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all_rounded, color: AppColors.primary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All marked as read')),
              );
            },
            tooltip: 'Mark all as read',
          ),
          const LanguageSelectorButton(),
        ],
      ),
      body: announcementsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (announcements) {
          if (announcements.isEmpty) {
            return Center(
              child: Text(
                'No new announcements.',
                style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: announcements.length,
            itemBuilder: (context, index) {
              final a = announcements[index];
              return _buildNotificationCard(
                type: 'alert',
                title: a['title'] ?? 'Announcement',
                message: a['content'] ?? '',
                time: _timeAgo(DateTime.parse(a['created_at'])),
                isUnread: true,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard({
    required String type,
    required String title,
    required String message,
    required String time,
    required bool isUnread,
  }) {
    IconData icon;
    Color iconColor;
    Color bgColor;

    switch (type) {
      case 'alert':
        icon = Icons.warning_amber_rounded;
        iconColor = AppColors.error;
        bgColor = AppColors.error.withValues(alpha: 0.1);
        break;
      case 'reminder':
        icon = Icons.medication_liquid_rounded;
        iconColor = AppColors.secondary;
        bgColor = AppColors.secondary.withValues(alpha: 0.1);
        break;
      case 'success':
        icon = Icons.check_circle_outline_rounded;
        iconColor = AppColors.success;
        bgColor = AppColors.success.withValues(alpha: 0.1);
        break;
      default:
        icon = Icons.info_outline_rounded;
        iconColor = AppColors.primary;
        bgColor = AppColors.primary.withValues(alpha: 0.1);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnread ? Colors.white : Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnread ? AppColors.primary.withValues(alpha: 0.2) : Colors.transparent,
          width: 1,
        ),
        boxShadow: [
          if (isUnread)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppTextStyles.titleSmall.copyWith(
                          fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                        ),
                      ),
                    ),
                    if (isUnread)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  time,
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _timeAgo(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inDays > 0) return '${diff.inDays} days ago';
    if (diff.inHours > 0) return '${diff.inHours} hours ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes} mins ago';
    return 'Just now';
  }
}

