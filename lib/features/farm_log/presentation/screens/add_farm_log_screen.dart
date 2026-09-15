import 'package:flutter/material.dart';
import 'package:plant_disease_detector/core/theme/app_theme.dart';

class AddFarmLogScreen extends StatefulWidget {
  const AddFarmLogScreen({super.key});

  @override
  State<AddFarmLogScreen> createState() => _AddFarmLogScreenState();
}

class _AddFarmLogScreenState extends State<AddFarmLogScreen> {
  String _selectedActivity = 'Watering';
  final List<Map<String, dynamic>> _activities = [
    {'name': 'Watering', 'icon': Icons.water_drop_outlined, 'color': Colors.blue},
    {'name': 'Fertilizer', 'icon': Icons.eco_outlined, 'color': Colors.green},
    {'name': 'Spraying', 'icon': Icons.pest_control_outlined, 'color': AppColors.primary},
    {'name': 'Harvesting', 'icon': Icons.shopping_basket_outlined, 'color': Colors.orange},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('New Farm Log', style: AppTextStyles.titleMedium),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Select Activity', style: AppTextStyles.titleSmall),
                    const SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.5,
                      ),
                      itemCount: _activities.length,
                      itemBuilder: (context, index) {
                        final act = _activities[index];
                        final isSelected = _selectedActivity == act['name'];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedActivity = act['name'];
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected ? (act['color'] as Color).withOpacity(0.1) : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? act['color'] as Color : Colors.transparent,
                                width: 2,
                              ),
                              boxShadow: isSelected ? [] : [
                                BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(act['icon'] as IconData, color: isSelected ? act['color'] as Color : AppColors.textSecondary),
                                const SizedBox(height: 8),
                                Text(
                                  act['name'] as String,
                                  style: AppTextStyles.titleSmall.copyWith(
                                    color: isSelected ? act['color'] as Color : AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 32),

                    Text('Date', style: AppTextStyles.titleSmall),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Today, Oct 12', style: AppTextStyles.titleMedium),
                          const Icon(Icons.calendar_today_rounded, color: AppColors.textSecondary),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    Text('Notes (Optional)', style: AppTextStyles.titleSmall),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
                        ],
                      ),
                      child: TextField(
                        maxLines: 4,
                        style: AppTextStyles.bodyLarge,
                        decoration: InputDecoration(
                          hintText: 'e.g., Used NPK 15-15-15 on plot A...',
                          hintStyle: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  minimumSize: const Size(double.infinity, 56),
                ),
                child: Text('Save Log Entry', style: AppTextStyles.titleMedium.copyWith(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
