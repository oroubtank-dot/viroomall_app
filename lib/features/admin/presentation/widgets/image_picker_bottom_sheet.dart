// lib/features/admin/presentation/widgets/image_picker_bottom_sheet.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';

Future<File?> showImagePickerBottomSheet(BuildContext context) async {
  File? selectedFile;

  await showModalBottomSheet(
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
                    Navigator.pop(context);
                    selectedFile = await _pickImage(ImageSource.camera);
                  },
                ),
                _buildOption(
                  icon: Icons.photo_library_rounded,
                  label: 'معرض الصور',
                  color: VirooColors.info,
                  onTap: () async {
                    Navigator.pop(context);
                    selectedFile = await _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ],
        ),
      );
    },
  );

  return selectedFile;
}

Future<File?> _pickImage(ImageSource source) async {
  final pickedFile = await ImagePicker().pickImage(
    source: source,
    imageQuality: 70,
  );
  if (pickedFile != null) {
    return File(pickedFile.path);
  }
  return null;
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
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Icon(icon, size: 35, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    ),
  );
}
