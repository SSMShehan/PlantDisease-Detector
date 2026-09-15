import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_disease_detector/core/theme/app_theme.dart';

class TreatmentDetailScreen extends StatefulWidget {
  const TreatmentDetailScreen({super.key});

  @override
  State<TreatmentDetailScreen> createState() => _TreatmentDetailScreenState();
}

class _TreatmentDetailScreenState extends State<TreatmentDetailScreen> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['Morning', 'Evening', 'Weekly'];

  // Mock states for checkboxes
  final List<bool> _stepStates = [true, true, true, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text('Treatment Detail', style: AppTextStyles.titleMedium),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Circular Progress Header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CircularProgressIndicator(
                              value: 0.6,
                              strokeWidth: 8,
                              backgroundColor: Colors.grey.shade100,
                              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                            ),
                            Center(
                              child: Text('60%', style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Treatment Routine', style: AppTextStyles.titleMedium),
                            const SizedBox(height: 4),
                            Text('12 Steps (45 mins)', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Routine Tabs
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: List.generate(_tabs.length, (index) {
                      final isSelected = _selectedTabIndex == index;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedTabIndex = index),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.grey.shade100 : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              border: isSelected ? Border.all(color: Colors.grey.shade300) : null,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              _tabs[index],
                              style: AppTextStyles.titleSmall.copyWith(
                                color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 24),

                // Tasks Grid
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: [
                    _buildTaskCard(0, '1. Prune', 'Remove infected leaves', '8:00 AM'),
                    _buildTaskCard(1, '2. Apply Fungicide', 'Organic Copper Spray', '8:30 AM'),
                    _buildTaskCard(2, '3. Fertilize', 'Nitrogen rich', '1:00 PM'),
                    _buildTaskCard(3, '4. Monitor', 'Check for pests', '2:00 PM'),
                    _buildTaskCard(4, '5. Water', 'Deep watering', '5:00 PM'),
                    _buildTaskCard(5, '6. Soil Prep', 'Add compost', '6:00 PM'),
                  ],
                ),
                const SizedBox(height: 32),

                // Recommended Products
                Text('Recommended Products', style: AppTextStyles.titleMedium),
                const SizedBox(height: 16),
                SizedBox(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildProductCard('Fungicide A', '\$12.99'),
                      _buildProductCard('Fertilizer B', '\$24.50'),
                      _buildProductCard('Neem Oil', '\$9.99'),
                      _buildProductCard('Pruning Shears', '\$15.00'),
                    ],
                  ),
                ),
                const SizedBox(height: 100), // Space for bottom button
              ],
            ),
          ),

          // Bottom Action Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: AppGradients.primary,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.alarm_rounded, color: Colors.white),
                    label: Text('Set Reminder', style: AppTextStyles.titleMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(int index, String title, String subtitle, String time) {
    bool isDone = _stepStates[index];
    return GestureDetector(
      onTap: () => setState(() => _stepStates[index] = !isDone),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDone ? AppColors.secondary.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDone ? AppColors.secondary : Colors.grey.shade200,
            width: isDone ? 1.5 : 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  isDone ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                  color: isDone ? AppColors.secondary : Colors.grey.shade400,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.titleSmall.copyWith(
                      color: isDone ? AppColors.secondary : AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 28.0),
              child: Text(subtitle, style: AppTextStyles.bodySmall.copyWith(fontSize: 11), maxLines: 2, overflow: TextOverflow.ellipsis),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(time, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold, fontSize: 10)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(String name, String price) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.image_rounded, color: Colors.grey.shade300, size: 30),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(name, style: AppTextStyles.titleSmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(price, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
