// lib/features/admin/presentation/widgets/product_basic_info.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ProductBasicInfo extends StatelessWidget {
  final String title;
  final String description;
  final Function(String) onTitleChanged;
  final Function(String) onDescriptionChanged;

  const ProductBasicInfo({
    super.key,
    required this.title,
    required this.description,
    required this.onTitleChanged,
    required this.onDescriptionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          initialValue: title,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: 'اسم المنتج',
            hintText: 'مثال: ايفون 15 برو',
            labelStyle: TextStyle(color: VirooColors.textSecondary),
          ),
          onChanged: onTitleChanged,
          validator: (v) =>
              v == null || v.isEmpty ? 'الرجاء إدخال اسم المنتج' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          initialValue: description,
          maxLines: 3,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: 'وصف المنتج',
            hintText: 'وصف تفصيلي للمنتج...',
            labelStyle: TextStyle(color: VirooColors.textSecondary),
          ),
          onChanged: onDescriptionChanged,
          validator: (v) =>
              v == null || v.isEmpty ? 'الرجاء إدخال وصف المنتج' : null,
        ),
      ],
    );
  }
}
