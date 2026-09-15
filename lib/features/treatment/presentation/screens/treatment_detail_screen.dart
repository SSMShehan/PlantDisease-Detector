import 'package:flutter/material.dart';
import 'package:plant_disease_detector/core/theme/app_theme.dart';

class TreatmentDetailScreen extends StatelessWidget {
  const TreatmentDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('Treatment Plan', style: AppTextStyles.titleMedium),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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
              child: TabBar(
                indicator: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.textSecondary,
                labelStyle: AppTextStyles.titleSmall.copyWith(fontSize: 13),
                unselectedLabelStyle: AppTextStyles.titleSmall.copyWith(fontSize: 13),
                tabs: const [
                  Tab(text: 'Organic'),
                  Tab(text: 'Chemical'),
                  Tab(text: 'Cultural'),
                ],
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            _TreatmentTabContent(type: 'Organic'),
            _TreatmentTabContent(type: 'Chemical'),
            _TreatmentTabContent(type: 'Cultural'),
          ],
        ),
      ),
    );
  }
}

class _TreatmentTabContent extends StatelessWidget {
  final String type;
  const _TreatmentTabContent({required this.type});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$type Treatment', style: AppTextStyles.headlineMedium),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.account_balance_wallet_outlined, size: 16, color: AppColors.secondary),
                    const SizedBox(width: 4),
                    Text('Est. LKR 2500', style: AppTextStyles.bodySmall.copyWith(color: AppColors.secondary, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Precautions Alert
          if (type == 'Chemical')
            Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.error.withOpacity(0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.warning_amber_rounded, color: AppColors.error),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Precautions', style: AppTextStyles.titleSmall.copyWith(color: AppColors.error)),
                        const SizedBox(height: 4),
                        Text(
                          'Wear gloves and mask. Keep away from children. Do not apply right before rain.',
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Steps
          Text('Step-by-step Guide', style: AppTextStyles.titleMedium),
          const SizedBox(height: 16),
          _buildStep(1, 'Remove infected leaves', 'Carefully prune all leaves showing brown spots. Do not leave them on the soil.'),
          _buildStep(2, 'Prepare mixture', 'Mix 5ml of the fungicide with 10 liters of water.'),
          _buildStep(3, 'Spray application', 'Spray uniformly over the entire plant, focusing on the underside of leaves.'),
          _buildStep(4, 'Repeat', 'Repeat the process every 7 days until symptoms clear.'),
        ],
      ),
    );
  }

  Widget _buildStep(int number, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: AppTextStyles.titleMedium.copyWith(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.titleSmall),
                  const SizedBox(height: 4),
                  Text(description, style: AppTextStyles.bodyMedium),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
