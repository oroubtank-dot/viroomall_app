// lib/features/profile/presentation/widgets/dashboard/dashboard_chart.dart
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_widgets.dart';

class DashboardChart extends StatelessWidget {
  final Map<String, int> salesByDay;

  const DashboardChart({super.key, required this.salesByDay});

  @override
  Widget build(BuildContext context) {
    final maxValue = salesByDay.values.isEmpty
        ? 1
        : salesByDay.values.reduce((a, b) => a > b ? a : b);
    final sortedKeys = salesByDay.keys.toList().reversed.toList();

    return GlassContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📈 أداء المبيعات (آخر 7 أيام)',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 150,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: sortedKeys.map((key) {
                final value = salesByDay[key] ?? 0;
                final height = maxValue > 0 ? (value / maxValue) * 120 : 0;

                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: height.toDouble(),
                        width: 20,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              VirooColors.amberPrimary,
                              VirooColors.amberPrimary.withAlpha(150),
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        key,
                        style: const TextStyle(
                          fontSize: 9,
                          color: VirooColors.textSecondary,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
