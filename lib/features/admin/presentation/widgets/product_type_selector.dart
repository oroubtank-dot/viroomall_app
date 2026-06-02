// lib/features/admin/presentation/widgets/product_type_selector.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ProductTypeSelector extends StatelessWidget {
  final String selectedType;
  final Function(String) onTypeChanged;

  const ProductTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> modes = [
      {
        'id': 'farz',
        'name': '🛍️ تسوق فردي',
        'desc': 'منتج جديد',
        'color': VirooColors.shopping
      },
      {
        'id': 'gomla',
        'name': '🏪 جملة',
        'desc': 'بيع بالجملة',
        'color': VirooColors.wholesale
      },
      {
        'id': 'tasawok',
        'name': '♻️ مستعمل',
        'desc': 'منتج مستعمل',
        'color': VirooColors.used
      },
      {
        'id': 'mosta3mal',
        'name': '🔥 تخفيضات',
        'desc': 'عروض وتصفيات',
        'color': VirooColors.outlet
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('نوع المنتج',
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
            children: modes.map((mode) {
          final isSelected = selectedType == mode['id'];
          return Expanded(
            child: GestureDetector(
              onTap: () => onTypeChanged(mode['id']),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (mode['color'] as Color).withAlpha(25)
                      : VirooColors.glassDark,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color:
                          isSelected ? mode['color'] : VirooColors.glassBorder),
                ),
                child: Column(children: [
                  Text(mode['name'],
                      style: TextStyle(
                          color: isSelected ? mode['color'] : Colors.white70,
                          fontSize: 12)),
                  const SizedBox(height: 2),
                  Text(mode['desc'],
                      style: TextStyle(
                          color: isSelected ? mode['color'] : Colors.white54,
                          fontSize: 9)),
                ]),
              ),
            ),
          );
        }).toList()),
      ],
    );
  }
}
