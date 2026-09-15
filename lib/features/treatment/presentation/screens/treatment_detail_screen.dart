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
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // ── Premium Image Header ───────────────────────────────────────
              SliverAppBar(
                expandedHeight: 220,
                pinned: true,
                backgroundColor: AppColors.primary,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                  onPressed: () => context.pop(),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  title: const Text('Treatment Detail', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        'https://images.unsplash.com/photo-1592424001815-32e6040ea468?q=80&w=800&auto=format&fit=crop', // Lush healthy tomato field
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: AppColors.primary,
                        ),
                      ),
                      // Dark gradient overlay for text readability
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.4),
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.7),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Circular Progress Card
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 15, offset: const Offset(0, 5)),
                          ],
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 70,
                              height: 70,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  CircularProgressIndicator(
                                    value: 0.6,
                                    strokeWidth: 8,
                                    backgroundColor: Colors.grey.shade100,
                                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                                  ),
                                  Center(child: Text('60%', style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary))),
                                ],
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Recovery Routine', style: AppTextStyles.titleMedium.copyWith(fontSize: 18)),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(Icons.timer_outlined, size: 14, color: AppColors.textSecondary),
                                      const SizedBox(width: 4),
                                      Text('45 mins/day', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                                    ],
                                  ),
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
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: List.generate(_tabs.length, (index) {
                            final isSelected = _selectedTabIndex == index;
                            return Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _selectedTabIndex = index),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  decoration: BoxDecoration(
                                    color: isSelected ? AppColors.secondary.withValues(alpha: 0.1) : Colors.transparent,
                                    borderRadius: BorderRadius.circular(14),
                                    border: isSelected ? Border.all(color: AppColors.secondary.withValues(alpha: 0.3)) : null,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    _tabs[index],
                                    style: AppTextStyles.titleSmall.copyWith(
                                      color: isSelected ? AppColors.secondary : AppColors.textSecondary,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
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
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.15,
                        children: [
                          _buildTaskCard(0, 'Prune', 'Remove infected leaves', '8:00 AM', Icons.content_cut_rounded),
                          _buildTaskCard(1, 'Apply Fungicide', 'Organic Copper Spray', '8:30 AM', Icons.water_drop_outlined),
                          _buildTaskCard(2, 'Fertilize', 'Nitrogen rich', '1:00 PM', Icons.eco_rounded),
                          _buildTaskCard(3, 'Monitor', 'Check for pests', '2:00 PM', Icons.search_rounded),
                          _buildTaskCard(4, 'Water', 'Deep watering', '5:00 PM', Icons.opacity_rounded),
                          _buildTaskCard(5, 'Soil Prep', 'Add compost', '6:00 PM', Icons.grass_rounded),
                        ],
                      ),
                      const SizedBox(height: 40),

                      // Recommended Products
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Recommended Products', style: AppTextStyles.titleMedium),
                          Text('View All', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 110,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          children: [
                            _buildProductCard('Copper Fungicide', '\$12.99', 'https://images.unsplash.com/photo-1584483789066-50ba68dd6531?q=80&w=200&auto=format&fit=crop'),
                            _buildProductCard('Nitrogen Fertilizer', '\$24.50', 'https://images.unsplash.com/photo-1627920769931-50e42f9e403d?q=80&w=200&auto=format&fit=crop'),
                            _buildProductCard('Pure Neem Oil', '\$9.99', 'https://images.unsplash.com/photo-1608687352332-9c3f1debc347?q=80&w=200&auto=format&fit=crop'),
                            _buildProductCard('Pruning Shears', '\$15.00', 'https://images.unsplash.com/photo-1416879598555-46e38bc86445?q=80&w=200&auto=format&fit=crop'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 120), // Space for bottom button
                    ],
                  ),
                ),
              ),
            ],
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
                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, -5)),
                ],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
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
                      BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 6)),
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

  Widget _buildTaskCard(int index, String title, String subtitle, String time, IconData icon) {
    bool isDone = _stepStates[index];
    return GestureDetector(
      onTap: () => setState(() => _stepStates[index] = !isDone),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDone ? AppColors.secondary.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDone ? AppColors.secondary.withValues(alpha: 0.5) : Colors.grey.shade200,
            width: isDone ? 1.5 : 1.0,
          ),
          boxShadow: isDone ? [] : [
            BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: isDone ? AppColors.secondary : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 16, color: isDone ? Colors.white : AppColors.textSecondary),
                ),
                const Spacer(),
                Icon(
                  isDone ? Icons.check_circle_rounded : Icons.circle_outlined,
                  color: isDone ? AppColors.secondary : Colors.grey.shade300,
                  size: 22,
                ),
              ],
            ),
            const Spacer(),
            Text(
              title,
              style: AppTextStyles.titleSmall.copyWith(color: isDone ? AppColors.secondary : AppColors.textPrimary, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(subtitle, style: AppTextStyles.bodySmall.copyWith(fontSize: 10, color: Colors.grey.shade600), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isDone ? AppColors.secondary.withValues(alpha: 0.1) : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(time, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold, fontSize: 10, color: isDone ? AppColors.secondary : Colors.grey.shade700)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(String name, String price, String imageUrl) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 16, bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              imageUrl,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 70,
                height: 70,
                color: Colors.grey.shade100,
                child: Icon(Icons.image_rounded, color: Colors.grey.shade300, size: 30),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(name, style: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.w600, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Text(price, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
