import 'package:flutter/material.dart';
import 'package:plant_disease_detector/core/theme/app_theme.dart';

class PhotoGuideScreen extends StatelessWidget {
  const PhotoGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('How to take a good photo', style: AppTextStyles.titleMedium),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Help our AI give you the best result by following these simple rules.',
              style: AppTextStyles.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            _buildGuideItem(
              title: 'Get close to the leaf',
              description: 'Focus on a single infected leaf rather than the whole plant.',
              isGood: true,
              icon: Icons.filter_center_focus_rounded,
            ),
            _buildGuideItem(
              title: 'Avoid blurry photos',
              description: 'Keep your hands steady. Tap the screen to focus before shooting.',
              isGood: false,
              icon: Icons.blur_on_rounded,
            ),
            _buildGuideItem(
              title: 'Good lighting is key',
              description: 'Avoid harsh shadows or taking photos against the sun.',
              isGood: true,
              icon: Icons.wb_sunny_rounded,
            ),
            _buildGuideItem(
              title: 'One leaf at a time',
              description: 'Multiple leaves overlapping can confuse the AI model.',
              isGood: false,
              icon: Icons.content_copy_rounded,
            ),
            
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text('Got it, let\'s scan!', style: AppTextStyles.titleMedium.copyWith(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideItem({required String title, required String description, required bool isGood, required IconData icon}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isGood ? AppColors.secondary.withOpacity(0.5) : AppColors.error.withOpacity(0.5)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isGood ? AppColors.secondary.withOpacity(0.1) : AppColors.error.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: isGood ? AppColors.secondary : AppColors.error),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isGood ? Icons.check_circle_rounded : Icons.cancel_rounded,
                      color: isGood ? AppColors.secondary : AppColors.error,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(title, style: AppTextStyles.titleSmall),
                  ],
                ),
                const SizedBox(height: 4),
                Text(description, style: AppTextStyles.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
