// lib/features/admin/presentation/widgets/image_picker_bottom_sheet.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';

Future<File?> showImagePickerBottomSheet(BuildContext context) async {
  final ImagePicker picker = ImagePicker();

  return await showModalBottomSheet<File?>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return GlassContainer(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'اختر مصدر الصورة',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOption(
                  icon: Icons.camera_alt_rounded,
                  label: 'كاميرا',
                  color: VirooColors.primary,
                  onTap: () async {
                    final file = await _pickImage(picker, ImageSource.camera);
                    if (context.mounted) {
                      Navigator.pop(context, file);
                    }
                  },
                ),
                _buildOption(
                  icon: Icons.photo_library_rounded,
                  label: 'معرض الصور',
                  color: VirooColors.info,
                  onTap: () async {
                    final file = await _pickImage(picker, ImageSource.gallery);
                    if (context.mounted) {
                      Navigator.pop(context, file);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

Future<File?> _pickImage(ImagePicker picker, ImageSource source) async {
  try {
    final pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 70,
    );
    if (pickedFile != null) {
      print('📸 تم اختيار الصورة: ${pickedFile.path}');
      return File(pickedFile.path);
    }
    print('❌ لم يتم اختيار صورة');
    return null;
  } catch (e) {
    print('❌ خطأ في اختيار الصورة: $e');
    return null;
  }
}

Widget _buildOption({
  required IconData icon,
  required String label,
  required Color color,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: color.withAlpha(25),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withAlpha(75)),
          ),
          child: Icon(icon, size: 35, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    ),
  );
}
