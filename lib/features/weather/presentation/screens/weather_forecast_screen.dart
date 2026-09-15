import 'package:flutter/material.dart';
import 'package:plant_disease_detector/core/theme/app_theme.dart';

class WeatherForecastScreen extends StatelessWidget {
  const WeatherForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('7-Day Forecast', style: AppTextStyles.titleMedium),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Smart Alert
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.success.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline_rounded, color: AppColors.success),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Good day for spraying', style: AppTextStyles.titleSmall.copyWith(color: AppColors.success)),
                        Text('No rain expected for the next 48 hours.', style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Forecast List
            _buildDayRow('Today', '28°C', 'Sunny', Icons.wb_sunny_rounded, Colors.orange),
            _buildDayRow('Tomorrow', '27°C', 'Partly Cloudy', Icons.cloud_queue_rounded, Colors.grey),
            _buildDayRow('Wednesday', '25°C', 'Rain (60%)', Icons.grain_rounded, Colors.blue),
            _buildDayRow('Thursday', '26°C', 'Rain (80%)', Icons.water_drop_rounded, Colors.blue),
            _buildDayRow('Friday', '28°C', 'Sunny', Icons.wb_sunny_rounded, Colors.orange),
            _buildDayRow('Saturday', '29°C', 'Clear', Icons.wb_sunny_rounded, Colors.orange),
            _buildDayRow('Sunday', '27°C', 'Cloudy', Icons.cloud_rounded, Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildDayRow(String day, String temp, String desc, IconData icon, Color iconColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(day, style: AppTextStyles.titleSmall),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Icon(icon, color: iconColor, size: 20),
                const SizedBox(width: 8),
                Text(desc, style: AppTextStyles.bodyMedium),
              ],
            ),
          ),
          Text(temp, style: AppTextStyles.titleMedium),
        ],
      ),
    );
  }
}
