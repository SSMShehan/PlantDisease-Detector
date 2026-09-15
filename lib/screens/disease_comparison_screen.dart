import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DiseaseComparisonScreen extends StatelessWidget {
  const DiseaseComparisonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Compare Diseases', style: AppTextStyles.titleMedium),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              'Visually similar symptoms can be confusing. Compare them side-by-side.',
              style: AppTextStyles.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _buildDiseaseColumn(
                    'Early Blight',
                    'https://images.unsplash.com/photo-1558227091-62d499ba5620?w=200&h=200&fit=crop',
                    'Brown spots with concentric rings like a target board. Starts on older leaves.',
                  ),
                ),
                Container(width: 1, color: AppColors.divider),
                Expanded(
                  child: _buildDiseaseColumn(
                    'Late Blight',
                    'https://images.unsplash.com/photo-1523348837708-15d4a09cfac2?w=200&h=200&fit=crop',
                    'Large, irregular brown patches without rings. Often has white mold underneath.',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiseaseColumn(String name, String imageUrl, String symptoms) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              imageUrl,
              height: 160,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),
          Text(name, style: AppTextStyles.titleMedium, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              symptoms,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
