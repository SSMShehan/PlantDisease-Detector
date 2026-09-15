import 'package:flutter/material.dart';
import 'package:plant_disease_detector/core/theme/app_theme.dart';

class SavedItemsScreen extends StatelessWidget {
  const SavedItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text('Saved Items', style: AppTextStyles.titleMedium),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                indicator: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.textSecondary,
                labelStyle: AppTextStyles.titleSmall,
                tabs: const [
                  Tab(text: 'Treatments'),
                  Tab(text: 'Farming Tips'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _buildTreatmentsList(),
            _buildTipsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTreatmentsList() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _buildSavedCard('Early Blight Treatment', 'Tomato • Chemical', Icons.medication_liquid_rounded),
        _buildSavedCard('Powdery Mildew Control', 'Chilli • Organic', Icons.eco_rounded),
      ],
    );
  }

  Widget _buildTipsList() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _buildSavedCard('Soil Preparation for Yala', '5 min read', Icons.article_rounded),
      ],
    );
  }

  Widget _buildSavedCard(String title, String subtitle, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.secondary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.titleMedium),
                const SizedBox(height: 4),
                Text(subtitle, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          const Icon(Icons.bookmark_rounded, color: AppColors.primary),
        ],
      ),
    );
  }
}
