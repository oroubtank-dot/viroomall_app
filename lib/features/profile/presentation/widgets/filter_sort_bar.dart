// Filter Sort Bar
// lib/features/profile/presentation/widgets/filter_sort_bar.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';

class FilterSortBar extends StatelessWidget {
  final String filterStatus;
  final String sortBy;
  final Function(String) onFilterChanged;
  final Function(String) onSortChanged;
  final Color themeColor;

  const FilterSortBar({
    super.key,
    required this.filterStatus,
    required this.sortBy,
    required this.onFilterChanged,
    required this.onSortChanged,
    required this.themeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: GlassContainer(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              borderRadius: BorderRadius.circular(20),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: filterStatus,
                  isExpanded: true,
                  dropdownColor: VirooColors.surface,
                  icon: Icon(Icons.filter_list_rounded,
                      color: themeColor, size: 20),
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'Cairo', fontSize: 13),
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('الكل')),
                    DropdownMenuItem(value: 'active', child: Text('✅ نشطة')),
                    DropdownMenuItem(
                        value: 'expiring', child: Text('⏳ تنتهي قريباً')),
                    DropdownMenuItem(
                        value: 'expired', child: Text('🔴 منتهية')),
                  ],
                  onChanged: (val) => onFilterChanged(val!),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GlassContainer(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              borderRadius: BorderRadius.circular(20),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: sortBy,
                  isExpanded: true,
                  dropdownColor: VirooColors.surface,
                  icon: Icon(Icons.sort_rounded, color: themeColor, size: 20),
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'Cairo', fontSize: 13),
                  items: const [
                    DropdownMenuItem(value: 'default', child: Text('الأحدث')),
                    DropdownMenuItem(
                        value: 'views', child: Text('👁️ الأكثر مشاهدة')),
                    DropdownMenuItem(
                        value: 'clicks', child: Text('👆 الأكثر نقراً')),
                    DropdownMenuItem(
                        value: 'sales', child: Text('🛒 الأكثر مبيعاً')),
                  ],
                  onChanged: (val) => onSortChanged(val!),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
