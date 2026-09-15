import 'package:flutter/material.dart';
import 'package:plant_disease_detector/core/theme/app_theme.dart';
import 'package:plant_disease_detector/features/treatment/presentation/screens/disease_comparison_screen.dart';

class DiseaseCatalogueScreen extends StatelessWidget {
  const DiseaseCatalogueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Disease Catalogue', style: AppTextStyles.titleMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.compare_arrows_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DiseaseComparisonScreen()),
              );
            },
            tooltip: 'Compare Diseases',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                style: AppTextStyles.bodyLarge,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary),
                  hintText: 'Search diseases...',
                  hintStyle: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
            ),
          ),
          
          // List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: 6,
              itemBuilder: (context, index) {
                return _buildDiseaseCard();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiseaseCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: Image.network(
              'https://images.unsplash.com/photo-1558227091-62d499ba5620?w=100&h=100&fit=crop',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 100,
                height: 100,
                color: Colors.grey.shade200,
                child: const Icon(Icons.image_not_supported_rounded, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Early Blight', style: AppTextStyles.titleMedium),
                const SizedBox(height: 4),
                Text('Tomato', style: AppTextStyles.bodySmall),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Medium Severity',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.warning,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
