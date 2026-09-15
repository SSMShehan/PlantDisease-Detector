import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_disease_detector/core/theme/app_theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text('Notifications', style: AppTextStyles.titleMedium),
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
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Today', style: AppTextStyles.titleSmall.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          _buildNotificationCard(
            type: 'alert',
            title: 'Heavy Rain Warning',
            message: 'Expect heavy showers this evening. Delay chemical spraying.',
            time: '2 hours ago',
            isUnread: true,
          ),
          _buildNotificationCard(
            type: 'reminder',
            title: 'Fungicide Spray Due',
            message: 'It has been 7 days since your last application for Early Blight.',
            time: '5 hours ago',
            isUnread: true,
          ),
          const SizedBox(height: 24),
          Text('Yesterday', style: AppTextStyles.titleSmall.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          _buildNotificationCard(
            type: 'success',
            title: 'Consultation Replied',
            message: 'Dr. Bandara has answered your query regarding the tomato leaf spots.',
            time: '1 day ago',
            isUnread: false,
          ),
          _buildNotificationCard(
            type: 'info',
            title: 'New Article Published',
            message: 'Learn the best organic methods to prepare soil for Yala season.',
            time: '1 day ago',
            isUnread: false,
          ),
        ],
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
        bgColor = AppColors.error.withOpacity(0.1);
        break;
      case 'reminder':
        icon = Icons.medication_liquid_rounded;
        iconColor = AppColors.secondary;
        bgColor = AppColors.secondary.withOpacity(0.1);
        break;
      case 'success':
        icon = Icons.check_circle_outline_rounded;
        iconColor = AppColors.success;
        bgColor = AppColors.success.withOpacity(0.1);
        break;
      default:
        icon = Icons.info_outline_rounded;
        iconColor = AppColors.primary;
        bgColor = AppColors.primary.withOpacity(0.1);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnread ? Colors.white : Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnread ? AppColors.primary.withOpacity(0.2) : Colors.transparent,
          width: 1,
        ),
        boxShadow: [
          if (isUnread)
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
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
}
