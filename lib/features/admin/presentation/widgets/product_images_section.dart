// lib/features/admin/presentation/widgets/product_images_section.dart
import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/image_picker_service.dart';

class ProductImagesSection extends StatelessWidget {
  final List<File> images;
  final Function(File) onImageAdded;
  final Function(int) onImageRemoved;

  const ProductImagesSection({
    super.key,
    required this.images,
    required this.onImageAdded,
    required this.onImageRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('صور المنتج',
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: images.length < 5 ? images.length + 1 : images.length,
            itemBuilder: (context, index) {
              if (index == images.length && images.length < 5) {
                return _buildAddImageButton(context);
              }
              return _buildImageItem(index);
            },
          ),
        ),
        if (images.isEmpty)
          const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text('يجب إضافة صورة واحدة على الأقل',
                  style: TextStyle(color: VirooColors.warning, fontSize: 12))),
      ],
    );
  }

  Widget _buildAddImageButton(BuildContext context) {
    final picker = ImagePickerService();
    return GestureDetector(
      onTap: () async {
        // ✅ استخدام الدالة الجديدة
        final images = await picker.pickMultipleImages(context);
        if (images.isNotEmpty) {
          // نأخذ أول صورة فقط (لأن هذه الويدجت كانت تستقبل واحدة)
          final image = images.first;
          await picker.previewImage(
            context: context,
            imageFile: image,
            onConfirm: () => onImageAdded(image),
          );
        }
      },
      child: Container(
        width: 80,
        height: 80,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
            color: VirooColors.glassDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: VirooColors.glassBorder)),
        child: const Icon(Icons.add_photo_alternate,
            color: VirooColors.textSecondary, size: 32),
      ),
    );
  }

  Widget _buildImageItem(int index) {
    return Stack(children: [
      Container(
          width: 80,
          height: 80,
          margin: const EdgeInsets.only(right: 12),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(images[index], fit: BoxFit.cover))),
      Positioned(
        top: -4,
        right: 4,
        child: GestureDetector(
          onTap: () => onImageRemoved(index),
          child: const CircleAvatar(
              radius: 12,
              backgroundColor: VirooColors.error,
              child: Icon(Icons.close, size: 12, color: Colors.white)),
        ),
      ),
    ]);
  }
}
