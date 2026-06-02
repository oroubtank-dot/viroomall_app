// lib/features/admin/presentation/widgets/tasawok_fields.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class TasawokFields extends StatefulWidget {
  final String price;
  final String condition;
  final String defects;
  final String reasonForSelling;
  final String usageDuration;
  final bool hasOriginalBox;
  final String originalReceipt;
  final Function(String) onPriceChanged;
  final Function(String) onConditionChanged;
  final Function(String) onDefectsChanged;
  final Function(String) onReasonForSellingChanged;
  final Function(String) onUsageDurationChanged;
  final Function(bool) onHasOriginalBoxChanged;
  final Function(String) onOriginalReceiptChanged;

  const TasawokFields({
    super.key,
    required this.price,
    required this.condition,
    required this.defects,
    required this.reasonForSelling,
    required this.usageDuration,
    required this.hasOriginalBox,
    required this.originalReceipt,
    required this.onPriceChanged,
    required this.onConditionChanged,
    required this.onDefectsChanged,
    required this.onReasonForSellingChanged,
    required this.onUsageDurationChanged,
    required this.onHasOriginalBoxChanged,
    required this.onOriginalReceiptChanged,
  });

  @override
  State<TasawokFields> createState() => _TasawokFieldsState();
}

class _TasawokFieldsState extends State<TasawokFields> {
  final List<Map<String, dynamic>> _conditions = [
    {'id': 'new', 'name': 'جديد بالكرتون'},
    {'id': 'like_new', 'name': 'مثل جديد'},
    {'id': 'good', 'name': 'جيد'},
    {'id': 'acceptable', 'name': 'مقبول'},
  ];

  final List<String> _sellingReasons = [
    'ترقية لمنتج أحدث',
    'لا أحتاجه بعد الآن',
    'هدية ولم يعجبني',
    'استخدام محدود',
    'أخرى',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: VirooColors.surface.withAlpha(51),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: VirooColors.used.withAlpha(76)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('♻️ تفاصيل المنتج المستعمل',
              style: TextStyle(
                  color: VirooColors.used,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: widget.price,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'السعر المطلوب (ج.م)',
              labelStyle: TextStyle(color: VirooColors.textSecondary),
            ),
            onChanged: widget.onPriceChanged,
            validator: (v) =>
                v == null || v.isEmpty ? 'الرجاء إدخال السعر' : null,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'حالة المنتج',
              labelStyle: TextStyle(color: VirooColors.textSecondary),
            ),
            style: const TextStyle(color: Colors.white),
            value: widget.condition,
            items: _conditions
                .map<DropdownMenuItem<String>>(
                  (c) => DropdownMenuItem<String>(
                    value: c['id'] as String,
                    child: Text(c['name'] as String),
                  ),
                )
                .toList(),
            onChanged: (v) => widget.onConditionChanged(v ?? 'good'),
            dropdownColor: VirooColors.surface,
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: widget.defects,
            maxLines: 2,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'العيوب (إن وجدت)',
              hintText: 'اذكر أي عيوب أو مشاكل في المنتج',
              labelStyle: TextStyle(color: VirooColors.textSecondary),
            ),
            onChanged: widget.onDefectsChanged,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'سبب البيع',
              labelStyle: TextStyle(color: VirooColors.textSecondary),
            ),
            style: const TextStyle(color: Colors.white),
            value: widget.reasonForSelling.isEmpty
                ? null
                : widget.reasonForSelling,
            items: _sellingReasons
                .map((r) => DropdownMenuItem<String>(value: r, child: Text(r)))
                .toList(),
            onChanged: (v) => widget.onReasonForSellingChanged(v ?? ''),
            dropdownColor: VirooColors.surface,
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: widget.usageDuration,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'مدة الاستخدام',
              hintText: 'مثال: 6 أشهر',
              labelStyle: TextStyle(color: VirooColors.textSecondary),
            ),
            onChanged: widget.onUsageDurationChanged,
          ),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
              child: CheckboxListTile(
                title: const Text('يوجد علبة أصلية',
                    style: TextStyle(color: Colors.white, fontSize: 12)),
                value: widget.hasOriginalBox,
                onChanged: (v) => widget.onHasOriginalBoxChanged(v ?? false),
                contentPadding: EdgeInsets.zero,
                activeColor: VirooColors.used,
                checkColor: Colors.white,
              ),
            ),
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'الفاتورة',
                  labelStyle: TextStyle(color: VirooColors.textSecondary),
                ),
                style: const TextStyle(color: Colors.white),
                value: widget.originalReceipt,
                items: const [
                  DropdownMenuItem<String>(value: 'yes', child: Text('متوفرة')),
                  DropdownMenuItem<String>(
                      value: 'no', child: Text('غير متوفرة')),
                  DropdownMenuItem<String>(value: 'lost', child: Text('ضائعة')),
                ],
                onChanged: (v) => widget.onOriginalReceiptChanged(v ?? 'no'),
                dropdownColor: VirooColors.surface,
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
