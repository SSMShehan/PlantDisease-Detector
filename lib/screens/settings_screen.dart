import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Settings', style: AppTextStyles.titleMedium),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          Text('General', style: AppTextStyles.titleSmall.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          _buildSettingsTile(Icons.language_rounded, 'Language', 'English'),
          _buildSettingsTile(Icons.notifications_none_rounded, 'Notifications', 'Enabled'),
          _buildSettingsTile(Icons.dark_mode_outlined, 'Dark Mode', 'Off (System)'),
          
          const SizedBox(height: 32),
          Text('Support & Legal', style: AppTextStyles.titleSmall.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          _buildSettingsTile(Icons.help_outline_rounded, 'Help Center', null),
          _buildSettingsTile(Icons.privacy_tip_outlined, 'Privacy Policy', null),
          _buildSettingsTile(Icons.description_outlined, 'Terms of Service', null),

          const SizedBox(height: 48),
          Center(
            child: TextButton.icon(
              onPressed: () {
                // Delete account logic
              },
              icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
              label: Text('Delete Account', style: AppTextStyles.titleMedium.copyWith(color: AppColors.error)),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text('CropGuard LK v1.0.0', style: AppTextStyles.bodySmall),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, String? trailingText) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title, style: AppTextStyles.titleMedium),
        trailing: trailingText != null 
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(trailingText, style: AppTextStyles.bodyMedium),
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
                ],
              )
            : const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
        onTap: () {},
      ),
    );
  }
}
