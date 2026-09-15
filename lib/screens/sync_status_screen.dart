import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SyncStatusScreen extends StatelessWidget {
  const SyncStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Offline Sync Status', style: AppTextStyles.titleMedium),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Banner
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.wifi_off_rounded, color: AppColors.warning, size: 32),
                  ),
                  const SizedBox(height: 16),
                  Text('Waiting for Connection', style: AppTextStyles.headlineMedium),
                  const SizedBox(height: 8),
                  Text(
                    'You have 2 items waiting to be uploaded. They will sync automatically when you connect to the internet.',
                    style: AppTextStyles.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            Text('Pending Queue', style: AppTextStyles.titleMedium),
            const SizedBox(height: 16),
            
            _buildQueueItem(
              title: 'Diagnosis Image Upload',
              subtitle: 'Scan #102 • 4.2 MB',
              status: 'Waiting...',
            ),
            _buildQueueItem(
              title: 'New Farm Log Entry',
              subtitle: 'Fertilizer Applied • 2 KB',
              status: 'Waiting...',
            ),
            
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                // Manually trigger sync
              },
              icon: const Icon(Icons.sync_rounded, color: Colors.white),
              label: Text('Sync Now', style: AppTextStyles.titleMedium.copyWith(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQueueItem({required String title, required String subtitle, required String status}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.cloud_upload_outlined, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.titleSmall),
                const SizedBox(height: 4),
                Text(subtitle, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          Text(status, style: AppTextStyles.bodySmall.copyWith(color: AppColors.warning, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
