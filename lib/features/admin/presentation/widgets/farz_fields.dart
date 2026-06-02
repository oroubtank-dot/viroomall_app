// lib/features/admin/presentation/widgets/farz_fields.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class FarzFields extends StatefulWidget {
  final String price;
  final String originalPrice;
  final bool hasWarranty;
  final String warrantyMonths;
  final bool priceIncludesTax;
  final Function(String) onPriceChanged;
  final Function(String) onOriginalPriceChanged;
  final Function(bool) onHasWarrantyChanged;
  final Function(String) onWarrantyMonthsChanged;
  final Function(bool) onPriceIncludesTaxChanged;

  const FarzFields({
    super.key,
    required this.price,
    required this.originalPrice,
    required this.hasWarranty,
    required this.warrantyMonths,
    required this.priceIncludesTax,
    required this.onPriceChanged,
    required this.onOriginalPriceChanged,
    required this.onHasWarrantyChanged,
    required this.onWarrantyMonthsChanged,
    required this.onPriceIncludesTaxChanged,
  });

  @override
  State<FarzFields> createState() => _FarzFieldsState();
}

class _FarzFieldsState extends State<FarzFields> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: VirooColors.surface.withAlpha(51),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: VirooColors.shopping.withAlpha(76)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🛍️ تفاصيل المنتج الجديد',
              style: TextStyle(
                  color: VirooColors.shopping,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
              child: TextFormField(
                initialValue: widget.price,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'السعر (ج.م)',
                  labelStyle: TextStyle(color: VirooColors.textSecondary),
                ),
                onChanged: widget.onPriceChanged,
                validator: (v) =>
                    v == null || v.isEmpty ? 'الرجاء إدخال السعر' : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                initialValue: widget.originalPrice,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'السعر الأصلي (اختياري)',
                  labelStyle: TextStyle(color: VirooColors.textSecondary),
                ),
                onChanged: widget.onOriginalPriceChanged,
              ),
            ),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
              child: CheckboxListTile(
                title: const Text('يوجد ضمان',
                    style: TextStyle(color: Colors.white, fontSize: 12)),
                value: widget.hasWarranty,
                onChanged: (v) => widget.onHasWarrantyChanged(v ?? false),
                contentPadding: EdgeInsets.zero,
                activeColor: VirooColors.shopping,
                checkColor: Colors.white,
              ),
            ),
            if (widget.hasWarranty)
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'مدة الضمان',
                    labelStyle: TextStyle(color: VirooColors.textSecondary),
                  ),
                  style: const TextStyle(color: Colors.white),
                  value: widget.warrantyMonths,
                  items: ['3', '6', '12', '24', '36']
                      .map((m) => DropdownMenuItem<String>(
                          value: m, child: Text('$m شهر')))
                      .toList(),
                  onChanged: (v) => widget.onWarrantyMonthsChanged(v ?? '12'),
                  dropdownColor: VirooColors.surface,
                ),
              ),
          ]),
          CheckboxListTile(
            title: const Text('السعر شامل الضريبة',
                style: TextStyle(color: Colors.white, fontSize: 12)),
            value: widget.priceIncludesTax,
            onChanged: (v) => widget.onPriceIncludesTaxChanged(v ?? true),
            contentPadding: EdgeInsets.zero,
            activeColor: VirooColors.shopping,
            checkColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
