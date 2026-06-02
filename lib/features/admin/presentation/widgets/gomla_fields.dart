// lib/features/admin/presentation/widgets/gomla_fields.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class GomlaFields extends StatelessWidget {
  final String wholesalePrice;
  final String minQuantity;
  final String maxQuantity;
  final Function(String) onWholesalePriceChanged;
  final Function(String) onMinQuantityChanged;
  final Function(String) onMaxQuantityChanged;

  const GomlaFields({
    super.key,
    required this.wholesalePrice,
    required this.minQuantity,
    required this.maxQuantity,
    required this.onWholesalePriceChanged,
    required this.onMinQuantityChanged,
    required this.onMaxQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: VirooColors.surface.withAlpha(51),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: VirooColors.wholesale.withAlpha(76)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🏪 تفاصيل البيع بالجملة',
              style: TextStyle(
                  color: VirooColors.wholesale,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
              child: TextFormField(
                initialValue: wholesalePrice,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'سعر الجملة (ج.م)',
                  labelStyle: TextStyle(color: VirooColors.textSecondary),
                ),
                onChanged: onWholesalePriceChanged,
                validator: (v) =>
                    v == null || v.isEmpty ? 'الرجاء إدخال السعر' : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                initialValue: minQuantity,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'أقل كمية للشراء',
                  labelStyle: TextStyle(color: VirooColors.textSecondary),
                ),
                onChanged: onMinQuantityChanged,
                validator: (v) =>
                    v == null || v.isEmpty ? 'الرجاء إدخال أقل كمية' : null,
              ),
            ),
          ]),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: maxQuantity,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'أقصى كمية متاحة (اختياري)',
              labelStyle: TextStyle(color: VirooColors.textSecondary),
            ),
            onChanged: onMaxQuantityChanged,
          ),
          const SizedBox(height: 8),
          const Text('خصومات حسب الكمية (سيتم إضافتها لاحقاً)',
              style: TextStyle(color: VirooColors.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }
}
