// lib/features/admin/presentation/widgets/product_form_sections.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';
import 'product_form_base.dart';

/// =============================================
/// 📦 أقسام خاصة بكل وضع
/// =============================================
class ProductFormSections {
  /// 🏪 قسم الجملة
  static Widget wholesaleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text('📦 تفاصيل الجملة',
            style: TextStyle(
                color: VirooColors.wholesale,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo')),
        const SizedBox(height: 12),
        ProductFormBase.buildTextField(
          controller: ProductFormBase.minQuantityController,
          hint: 'الحد الأدنى للطلب (مثال: 10) *',
          icon: Icons.inventory_2_rounded,
          keyboardType: TextInputType.number,
          required: true,
        ),
        const SizedBox(height: 12),
        GlassContainer(
          padding: const EdgeInsets.all(14),
          borderRadius: BorderRadius.circular(16),
          child: Column(
            children: [
              _priceRow('10+ قطع', 'خصم 10%'),
              _priceRow('50+ قطعة', 'خصم 20%'),
              _priceRow('100+ قطعة', 'خصم 30%'),
            ],
          ),
        ),
      ],
    );
  }

  /// ♻️ قسم المستعمل
  static Widget usedSection(
      String condition,
      Function(String) onConditionChanged,
      bool negotiable,
      Function(bool) onNegotiableChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text('♻️ تفاصيل المستعمل',
            style: TextStyle(
                color: VirooColors.used,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo')),
        const SizedBox(height: 12),
        const Text('حالة المنتج *',
            style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo')),
        const SizedBox(height: 8),
        Row(
          children: [
            _conditionChip('new', '⭐ جديد', condition, onConditionChanged),
            _conditionChip(
                'like_new', '🟢 مثل الجديد', condition, onConditionChanged),
            _conditionChip('good', '🟡 جيد', condition, onConditionChanged),
            _conditionChip(
                'acceptable', '🟠 مقبول', condition, onConditionChanged),
          ],
        ),
        const SizedBox(height: 16),
        ProductFormBase.buildTextField(
          controller: ProductFormBase.defectsController,
          hint: 'وصف العيوب (اختياري)',
          icon: Icons.warning_amber_rounded,
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        ProductFormBase.buildTextField(
          controller: ProductFormBase.originalPriceController,
          hint: 'السعر الأصلي (قبل الاستعمال) *',
          icon: Icons.money_rounded,
          keyboardType: TextInputType.number,
          required: true,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.handshake_rounded,
                color: VirooColors.warning, size: 20),
            const SizedBox(width: 8),
            const Text('قابل للتفاوض',
                style: TextStyle(
                    color: Colors.white, fontSize: 14, fontFamily: 'Cairo')),
            const Spacer(),
            Switch(
              value: negotiable,
              onChanged: onNegotiableChanged,
              activeColor: VirooColors.warning,
            ),
          ],
        ),
      ],
    );
  }

  /// 🔥 قسم الفرز
  static Widget outletSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text('🔥 تفاصيل الفرز والتصفية',
            style: TextStyle(
                color: VirooColors.outlet,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo')),
        const SizedBox(height: 12),
        ProductFormBase.buildTextField(
          controller: ProductFormBase.originalPriceController,
          hint: 'السعر الأصلي (قبل التصفية) *',
          icon: Icons.money_rounded,
          keyboardType: TextInputType.number,
          required: true,
        ),
        const SizedBox(height: 12),
        ProductFormBase.buildTextField(
          controller: ProductFormBase.outletReasonController,
          hint: 'سبب التصفية (مثال: نهاية الموسم) *',
          icon: Icons.info_outline_rounded,
          required: true,
        ),
        const SizedBox(height: 12),
        ProductFormBase.buildTextField(
          controller: ProductFormBase.outletQuantityController,
          hint: 'الكمية المتاحة *',
          icon: Icons.inventory_2_rounded,
          keyboardType: TextInputType.number,
          required: true,
        ),
      ],
    );
  }

  static Widget _conditionChip(
      String value, String label, String selected, Function(String) onChanged) {
    final isSelected = selected == value;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? VirooColors.used.withAlpha(51)
              : VirooColors.glassDark,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: isSelected ? VirooColors.used : VirooColors.glassBorder),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 11,
                fontFamily: 'Cairo',
                color:
                    isSelected ? VirooColors.used : VirooColors.textSecondary)),
      ),
    );
  }

  static Widget _priceRow(String quantity, String discount) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(quantity,
              style: const TextStyle(
                  color: VirooColors.textSecondary,
                  fontSize: 13,
                  fontFamily: 'Cairo')),
          Text(discount,
              style: const TextStyle(
                  color: VirooColors.wholesale,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  fontFamily: 'Orbitron')),
        ],
      ),
    );
  }
}
