// lib/features/admin/presentation/widgets/mosta3mal_fields.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class Mosta3malFields extends StatefulWidget {
  final String originalPrice;
  final String price;
  final String discountPercentage;
  final String limitedQuantity;
  final DateTime? expiryDate;
  final String flashSaleType;
  final String couponCode;
  final Function(String) onOriginalPriceChanged;
  final Function(String) onPriceChanged;
  final Function(String) onDiscountPercentageChanged;
  final Function(String) onLimitedQuantityChanged;
  final Function(DateTime?) onExpiryDateChanged;
  final Function(String) onFlashSaleTypeChanged;
  final Function(String) onCouponCodeChanged;

  const Mosta3malFields({
    super.key,
    required this.originalPrice,
    required this.price,
    required this.discountPercentage,
    required this.limitedQuantity,
    required this.expiryDate,
    required this.flashSaleType,
    required this.couponCode,
    required this.onOriginalPriceChanged,
    required this.onPriceChanged,
    required this.onDiscountPercentageChanged,
    required this.onLimitedQuantityChanged,
    required this.onExpiryDateChanged,
    required this.onFlashSaleTypeChanged,
    required this.onCouponCodeChanged,
  });

  @override
  State<Mosta3malFields> createState() => _Mosta3malFieldsState();
}

class _Mosta3malFieldsState extends State<Mosta3malFields> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: VirooColors.surface.withAlpha(51),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: VirooColors.outlet.withAlpha(76)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🔥 تفاصيل العرض والتخفيضات',
              style: TextStyle(
                  color: VirooColors.outlet,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
              child: TextFormField(
                initialValue: widget.originalPrice,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'السعر الأصلي',
                  labelStyle: TextStyle(color: VirooColors.textSecondary),
                ),
                onChanged: widget.onOriginalPriceChanged,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                initialValue: widget.price,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'السعر بعد الخصم',
                  labelStyle: TextStyle(color: VirooColors.textSecondary),
                ),
                onChanged: widget.onPriceChanged,
                validator: (v) =>
                    v == null || v.isEmpty ? 'الرجاء إدخال السعر' : null,
              ),
            ),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
              child: TextFormField(
                initialValue: widget.discountPercentage,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'نسبة الخصم %',
                  labelStyle: TextStyle(color: VirooColors.textSecondary),
                ),
                onChanged: widget.onDiscountPercentageChanged,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                initialValue: widget.limitedQuantity,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'كمية محدودة (اختياري)',
                  labelStyle: TextStyle(color: VirooColors.textSecondary),
                ),
                onChanged: widget.onLimitedQuantityChanged,
              ),
            ),
          ]),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'نوع العرض',
              labelStyle: TextStyle(color: VirooColors.textSecondary),
            ),
            style: const TextStyle(color: Colors.white),
            value: widget.flashSaleType,
            items: const [
              DropdownMenuItem<String>(
                  value: 'normal', child: Text('عرض عادي')),
              DropdownMenuItem<String>(
                  value: 'flash', child: Text('🔥 عرض فلاش')),
              DropdownMenuItem<String>(
                  value: 'limited', child: Text('📦 محدود الكمية')),
            ],
            onChanged: (v) => widget.onFlashSaleTypeChanged(v ?? 'normal'),
            dropdownColor: VirooColors.surface,
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: widget.expiryDate ??
                    DateTime.now().add(const Duration(days: 30)),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (date != null) widget.onExpiryDateChanged(date);
            },
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'تاريخ انتهاء العرض',
                labelStyle: TextStyle(color: VirooColors.textSecondary),
              ),
              child: Text(
                widget.expiryDate != null
                    ? '${widget.expiryDate!.toLocal()}'.split(' ')[0]
                    : 'اختر تاريخ',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: widget.couponCode,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'كود الخصم (اختياري)',
              hintText: 'مثال: SALE50',
              labelStyle: TextStyle(color: VirooColors.textSecondary),
            ),
            onChanged: widget.onCouponCodeChanged,
          ),
        ],
      ),
    );
  }
}
