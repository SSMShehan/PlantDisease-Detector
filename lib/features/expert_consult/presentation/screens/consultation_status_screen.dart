import 'package:flutter/material.dart';
import 'package:plant_disease_detector/core/theme/app_theme.dart';

class ConsultationStatusScreen extends StatelessWidget {
  const ConsultationStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Consultation Status', style: AppTextStyles.titleMedium),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_circle_rounded, color: AppColors.secondary, size: 32),
                  ),
                  const SizedBox(height: 16),
                  Text('Submitted Successfully', style: AppTextStyles.headlineMedium),
                  const SizedBox(height: 8),
                  Text(
                    'Your case has been forwarded to an agricultural officer. You will receive a notification when they reply.',
                    style: AppTextStyles.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            Text('Timeline', style: AppTextStyles.titleMedium),
            const SizedBox(height: 16),
            _buildTimelineStep(title: 'Request Submitted', time: 'Today, 10:45 AM', isCompleted: true, isLast: false),
            _buildTimelineStep(title: 'Under Review by Officer', time: 'Pending', isCompleted: false, isLast: false),
            _buildTimelineStep(title: 'Diagnosis & Advice Ready', time: 'Pending', isCompleted: false, isLast: true),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineStep({required String title, required String time, required bool isCompleted, required bool isLast}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCompleted ? AppColors.secondary : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: isCompleted ? AppColors.secondary : AppColors.divider, width: 2),
              ),
              child: isCompleted ? const Icon(Icons.check_rounded, color: Colors.white, size: 14) : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 48,
                color: isCompleted ? AppColors.secondary : AppColors.divider,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.titleSmall.copyWith(color: isCompleted ? AppColors.textPrimary : AppColors.textSecondary)),
            const SizedBox(height: 2),
            Text(time, style: AppTextStyles.bodySmall),
          ],
        ),
      ],
    );
  }
}
