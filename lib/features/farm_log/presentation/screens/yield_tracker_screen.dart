import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_disease_detector/core/theme/app_theme.dart';
import 'package:fl_chart/fl_chart.dart';

class YieldTrackerScreen extends StatefulWidget {
  const YieldTrackerScreen({super.key});

  @override
  State<YieldTrackerScreen> createState() => _YieldTrackerScreenState();
}

class _YieldTrackerScreenState extends State<YieldTrackerScreen> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['All Time', 'This Year', 'This Month', 'Custom'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text('Yield Tracker', style: AppTextStyles.titleMedium),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Date Range Header
              Text('Date Range', style: AppTextStyles.titleMedium),
              const SizedBox(height: 12),
              
              // Custom Scrollable Tabs
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _tabs.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final isSelected = _selectedTabIndex == index;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedTabIndex = index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            if (isSelected)
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                          ],
                          border: isSelected ? null : Border.all(color: Colors.grey.shade300),
                        ),
                        child: Text(
                          _tabs[index],
                          style: AppTextStyles.titleSmall.copyWith(
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),

              // Chart Container
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Yield Over Time (kg)', style: AppTextStyles.titleMedium),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 200,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: 250,
                          barTouchData: BarTouchData(enabled: false),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  const titles = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL'];
                                  if (value.toInt() >= 0 && value.toInt() < titles.length) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(titles[value.toInt()], style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                                reservedSize: 30,
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                interval: 50,
                                getTitlesWidget: (value, meta) {
                                  return Text(value.toInt().toString(), style: AppTextStyles.bodySmall);
                                },
                              ),
                            ),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: 50,
                            getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.shade200, strokeWidth: 1),
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: [
                            _buildBarGroup(0, 50),
                            _buildBarGroup(1, 120),
                            _buildBarGroup(2, 85),
                            _buildBarGroup(3, 195),
                            _buildBarGroup(4, 160),
                            _buildBarGroup(5, 210),
                            _buildBarGroup(6, 180),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Summary Cards
              Row(
                children: [
                  Expanded(child: _buildSummaryCard(Icons.shopping_bag_outlined, 'Total Harvest', '2,450 kg')),
                  const SizedBox(width: 16),
                  Expanded(child: _buildSummaryCard(Icons.emoji_events_outlined, 'Average Yield/Crop', '310 kg')),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildSummaryCard(Icons.grass_rounded, 'Best Crop', 'Wheat - 820 kg')),
                  const SizedBox(width: 16),
                  Expanded(child: _buildSummaryCard(Icons.calendar_today_outlined, 'Last Entry', 'Jun 12 - 180 kg')),
                ],
              ),
              const SizedBox(height: 32),

              // Yield Entries List
              Text('Yield Entries', style: AppTextStyles.titleMedium),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildListHeader(),
                    _buildListItem('Jun 12', 'Wheat', 'F1', '180 kg'),
                    _buildDivider(),
                    _buildListItem('Jun 05', 'Corn', 'F3', '210 kg'),
                    _buildDivider(),
                    _buildListItem('May 28', 'Soybeans', 'F2', '195 kg'),
                    _buildDivider(),
                    _buildListItem('May 15', 'Wheat', 'F1', '160 kg', isLast: true),
                  ],
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      
      // We assume Bottom Navigation is handled globally, but here we can add a FAB or similar if needed
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: AppColors.primary,
          width: 16,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 250,
            color: AppColors.primary.withValues(alpha: 0.1),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.secondary, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(value, style: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.bold, fontSize: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text('Date', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold))),
          Expanded(flex: 3, child: Text('Crop Name', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: Text('Field ID', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: Text('Yield', textAlign: TextAlign.right, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildListItem(String date, String crop, String field, String yieldVal, {bool isLast = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(date, style: AppTextStyles.bodyMedium)),
          Expanded(flex: 3, child: Text(crop, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600))),
          Expanded(flex: 2, child: Text(field, style: AppTextStyles.bodyMedium)),
          Expanded(flex: 2, child: Text(yieldVal, textAlign: TextAlign.right, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600, color: AppColors.primary))),
        ],
      ),
    );
  }

  Widget _buildDivider() => Divider(height: 1, color: Colors.grey.shade200, indent: 16, endIndent: 16);
}
