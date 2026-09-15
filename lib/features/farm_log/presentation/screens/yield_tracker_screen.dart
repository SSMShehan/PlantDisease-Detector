import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_disease_detector/core/theme/app_theme.dart';

class YieldTrackerScreen extends StatelessWidget {
  const YieldTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text('Yield & Expenses', style: AppTextStyles.titleMedium),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildFinancialOverview(),
            const SizedBox(height: 32),
            Text('Expense Breakdown', style: AppTextStyles.titleMedium),
            const SizedBox(height: 16),
            _buildExpenseBar('Fertilizer', 15000, 35, Colors.green),
            _buildExpenseBar('Fungicide/Pesticide', 8500, 20, AppColors.secondary),
            _buildExpenseBar('Labor', 12000, 25, Colors.orange),
            _buildExpenseBar('Seeds/Plants', 4000, 10, AppColors.primary),
            _buildExpenseBar('Other', 2500, 10, Colors.grey),
            
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add_rounded, color: Colors.white),
              label: Text('Log New Expense', style: AppTextStyles.titleSmall.copyWith(color: Colors.white)),
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

  Widget _buildFinancialOverview() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFF679580)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text('Expected Revenue (LKR)', style: AppTextStyles.bodyMedium.copyWith(color: Colors.white.withOpacity(0.9))),
          const SizedBox(height: 8),
          Text('120,000', style: AppTextStyles.headlineLarge.copyWith(color: Colors.white, fontSize: 40)),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text('Total Expenses', style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withOpacity(0.8))),
                    const SizedBox(height: 4),
                    Text('42,000', style: AppTextStyles.titleMedium.copyWith(color: Colors.white)),
                  ],
                ),
              ),
              Container(width: 1, height: 40, color: Colors.white.withOpacity(0.2)),
              Expanded(
                child: Column(
                  children: [
                    Text('Est. Profit', style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withOpacity(0.8))),
                    const SizedBox(height: 4),
                    Text('78,000', style: AppTextStyles.titleMedium.copyWith(color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseBar(String label, int amount, int percentage, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: AppTextStyles.titleSmall),
              Text('LKR $amount', style: AppTextStyles.titleSmall),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 12,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(6),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
