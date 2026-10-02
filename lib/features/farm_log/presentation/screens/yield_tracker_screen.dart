import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_disease_detector/core/theme/app_theme.dart';
import 'package:plant_disease_detector/core/localization/app_strings.dart';
import 'package:plant_disease_detector/core/widgets/language_selector_button.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_disease_detector/features/farm_log/application/farm_provider.dart';
import 'package:intl/intl.dart';

class YieldTrackerScreen extends ConsumerStatefulWidget {
  const YieldTrackerScreen({super.key});

  @override
  ConsumerState<YieldTrackerScreen> createState() => _YieldTrackerScreenState();
}

class _YieldTrackerScreenState extends ConsumerState<YieldTrackerScreen> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['All Time', 'This Year', 'This Month', 'Custom'];

  // Colors
  final Color _goldAccent = const Color(0xFFF5C842);
  final Color _darkGreen = const Color(0xFF0F3820);
  final Color _textLight = Colors.white;

  @override
  Widget build(BuildContext context) {
    final yieldsAsync = ref.watch(yieldEntriesProvider);

    return Scaffold(
      backgroundColor: _darkGreen,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F3820), Color(0xFF05130B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom AppBar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                      onPressed: () => context.pop(),
                    ),
                    Text(
                      context.tr(en: 'Yield Tracker', si: 'අස්වැන්න ලුහුබැඳීම', ta: 'விளைச்சல் கண்காணிப்பாளர்'),
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const LanguageSelectorButton(isCompact: true),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Date Range Header
                      Text(
                        context.tr(en: 'Date Range', si: 'දින පරාසය', ta: 'தேதி வரம்பு'),
                        style: const TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      
                      // Custom Scrollable Tabs
                      SizedBox(
                        height: 40,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _tabs.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final isSelected = _selectedTabIndex == index;
                            final tabLabels = [
                              context.tr(en: 'All Time', si: 'සියලු කාල', ta: 'எல்லா நேரமும்'),
                              context.tr(en: 'This Year', si: 'මෙම වසරේ', ta: 'இந்த ஆண்டு'),
                              context.tr(en: 'This Month', si: 'මෙම මාසයේ', ta: 'இந்த மாதம்'),
                              context.tr(en: 'Custom', si: 'වෙනත්', ta: 'தனிப்பயன்'),
                            ];
                            return GestureDetector(
                              onTap: () => setState(() => _selectedTabIndex = index),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: isSelected ? _goldAccent : Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: isSelected ? null : Border.all(color: Colors.white.withOpacity(0.2)),
                                  boxShadow: [
                                    if (isSelected)
                                      BoxShadow(color: _goldAccent.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 4)),
                                  ],
                                ),
                                child: Text(
                                  tabLabels[index],
                                  style: TextStyle(
                                    color: isSelected ? _darkGreen : Colors.white,
                                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Chart Container (Glassmorphic)
                      _buildGlassContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.tr(en: 'Yield Over Time (kg)', si: 'කාලය අනුව අස්වැන්න (kg)', ta: 'காலப்போக்கில் விளைச்சல் (kg)'),
                              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
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
                                              child: Text(
                                                titles[value.toInt()],
                                                style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold),
                                              ),
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
                                        reservedSize: 35,
                                        interval: 50,
                                        getTitlesWidget: (value, meta) {
                                          return Text(
                                            value.toInt().toString(),
                                            style: const TextStyle(color: Colors.white54, fontSize: 10),
                                          );
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
                                    getDrawingHorizontalLine: (value) => FlLine(color: Colors.white.withOpacity(0.1), strokeWidth: 1),
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
                          Expanded(child: _buildSummaryCard(Icons.shopping_bag_outlined, context.tr(en: 'Total Harvest', si: 'මුළු අස්වැන්න', ta: 'மொத்த அறுவடை'), '2,450 kg')),
                          const SizedBox(width: 16),
                          Expanded(child: _buildSummaryCard(Icons.emoji_events_outlined, context.tr(en: 'Avg Yield/Crop', si: 'සාමාන්‍ය අස්වැන්න', ta: 'சராசரி விளைச்சல்'), '310 kg')),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: _buildSummaryCard(Icons.grass_rounded, context.tr(en: 'Best Crop', si: 'හොඳම බෝගය', ta: 'சிறந்த பயிர்'), 'Wheat\n820 kg')),
                          const SizedBox(width: 16),
                          Expanded(child: _buildSummaryCard(Icons.calendar_today_outlined, context.tr(en: 'Last Entry', si: 'අවසන් සටහන', ta: 'கடைசி பதிவு'), 'Jun 12\n180 kg')),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Yield Entries List
                      Text(
                        context.tr(en: 'Yield Entries', si: 'අස්වනු සටහන්', ta: 'விளைச்சல் பதிவுகள்'),
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      _buildGlassContainer(
                        padding: const EdgeInsets.all(0),
                        child: yieldsAsync.when(
                          data: (entries) {
                            if (entries.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.all(20),
                                child: Center(child: Text("No yield entries found.", style: TextStyle(color: Colors.white70))),
                              );
                            }
                            return Column(
                              children: [
                                _buildListHeader(),
                                ...entries.asMap().entries.map((e) {
                                  final i = e.key;
                                  final entry = e.value;
                                  final dateStr = DateFormat('MMM dd').format(entry.date);
                                  final isLast = i == entries.length - 1;
                                  
                                  return Column(
                                    children: [
                                      _buildListItem(dateStr, entry.cropName, entry.fieldId, '${entry.yieldAmount} kg', isLast: isLast),
                                      if (!isLast) _buildDivider(),
                                    ],
                                  );
                                }),
                              ],
                            );
                          },
                          loading: () => const Padding(padding: EdgeInsets.all(30), child: Center(child: CircularProgressIndicator(color: Colors.white))),
                          error: (err, _) => Padding(padding: const EdgeInsets.all(20), child: Text('Error: $err', style: const TextStyle(color: Colors.redAccent))),
                        ),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassContainer({required Widget child, EdgeInsetsGeometry? padding}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: padding ?? const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: child,
        ),
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: _goldAccent,
          width: 14,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          ),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 250,
            color: Colors.white.withOpacity(0.05),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(IconData icon, String title, String value) {
    return _buildGlassContainer(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _goldAccent.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: _goldAccent, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(context.tr(en: 'Date', si: 'දිනය', ta: 'தேதி'), style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold))),
          Expanded(flex: 3, child: Text(context.tr(en: 'Crop', si: 'බෝගය', ta: 'பயிர்'), style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: Text(context.tr(en: 'Field ID', si: 'ක්ෂේත්‍රය', ta: 'நிலம்'), style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: Text(context.tr(en: 'Yield', si: 'අස්වැන්න', ta: 'விளைச்சல்'), textAlign: TextAlign.right, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildListItem(String date, String crop, String field, String yieldVal, {bool isLast = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(date, style: const TextStyle(color: Colors.white, fontSize: 13))),
          Expanded(flex: 3, child: Text(context.trCrop(crop), style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600))),
          Expanded(flex: 2, child: Text(field, style: const TextStyle(color: Colors.white, fontSize: 13))),
          Expanded(flex: 2, child: Text(yieldVal, textAlign: TextAlign.right, style: TextStyle(color: _goldAccent, fontSize: 13, fontWeight: FontWeight.w900))),
        ],
      ),
    );
  }

  Widget _buildDivider() => Divider(height: 1, color: Colors.white.withOpacity(0.1), indent: 16, endIndent: 16);
}
