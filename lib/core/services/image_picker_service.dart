// lib/core/services/image_picker_service.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../theme/app_colors.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  /// اختيار صورة واحدة من الكاميرا أو المعرض مع قص وضغط
  Future<File?> pickAndProcessImage({
    required BuildContext context,
    ImageSource? source,
  }) async {
    ImageSource selectedSource =
        source ?? await _showImageSourceDialog(context);
    if (selectedSource == ImageSource.camera) {
      return _pickFromCamera(context);
    } else {
      return _pickFromGallerySingle(context);
    }
  }

  /// اختيار عدة صور من المعرض
  Future<List<File>> pickMultipleImages(BuildContext context) async {
    try {
      final List<XFile>? pickedFiles = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFiles == null || pickedFiles.isEmpty) return [];

      List<File> processedImages = [];

      for (var file in pickedFiles) {
        File imageFile = File(file.path);

        final croppedFile = await _cropImage(imageFile, context);
        if (croppedFile == null) continue;

        final compressedFile = await _compressImage(croppedFile);
        processedImages.add(compressedFile ?? croppedFile);
      }

      return processedImages;
    } catch (e) {
      debugPrint('خطأ في اختيار الصور: $e');
      return [];
    }
  }

  /// عرض حوار اختيار المصدر
  Future<ImageSource> _showImageSourceDialog(BuildContext context) async {
    return await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: VirooColors.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Container(
                width: 50,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
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
              ListTile(
                leading: const Icon(Icons.camera_alt_rounded,
                    color: VirooColors.amberPrimary, size: 28),
                title: const Text('كاميرا',
                    style: TextStyle(color: Colors.white, fontFamily: 'Cairo')),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_rounded,
                    color: VirooColors.amberPrimary, size: 28),
                title: const Text('المعرض',
                    style: TextStyle(color: Colors.white, fontFamily: 'Cairo')),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    ).then((value) => value ?? ImageSource.gallery);
  }

  /// التقاط صورة من الكاميرا
  Future<File?> _pickFromCamera(BuildContext context) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFile == null) return null;

      File imageFile = File(pickedFile.path);

      final croppedFile = await _cropImage(imageFile, context);
      if (croppedFile == null) return null;

      final compressedFile = await _compressImage(croppedFile);

      return compressedFile ?? croppedFile;
    } catch (e) {
      debugPrint('خطأ في الكاميرا: $e');
      return null;
    }
  }

  /// اختيار صورة واحدة من المعرض
  Future<File?> _pickFromGallerySingle(BuildContext context) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFile == null) return null;

      File imageFile = File(pickedFile.path);

      final croppedFile = await _cropImage(imageFile, context);
      if (croppedFile == null) return null;

      final compressedFile = await _compressImage(croppedFile);

      return compressedFile ?? croppedFile;
    } catch (e) {
      debugPrint('خطأ في المعرض: $e');
      return null;
    }
  }

  /// قص الصورة
  Future<File?> _cropImage(File imageFile, BuildContext context) async {
    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'قص الصورة',
            toolbarColor: VirooColors.amberPrimary,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
            activeControlsWidgetColor: VirooColors.amberPrimary,
          ),
          IOSUiSettings(
            title: 'قص الصورة',
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
          ),
        ],
      );

      if (croppedFile == null) return null;
      return File(croppedFile.path);
    } catch (e) {
      debugPrint('خطأ في قص الصورة: $e');
      return imageFile;
    }
  }

  /// ضغط الصورة
  Future<File?> _compressImage(File imageFile) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final targetPath = path.join(
        tempDir.path,
        'compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      final result = await FlutterImageCompress.compressAndGetFile(
        imageFile.absolute.path,
        targetPath,
        quality: 75,
        minWidth: 800,
        minHeight: 800,
        rotate: 0,
      );

      if (result == null) return null;
      return File(result.path);
    } catch (e) {
      debugPrint('خطأ في ضغط الصورة: $e');
      return imageFile;
    }
  }

  /// معاينة الصورة قبل الرفع
  Future<void> previewImage({
    required BuildContext context,
    required File imageFile,
    required VoidCallback onConfirm,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: VirooColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            const Text(
              'معاينة الصورة',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                imageFile,
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'إعادة',
                    style: TextStyle(
                        color: VirooColors.error, fontFamily: 'Cairo'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onConfirm();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: VirooColors.amberPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'موافق',
                    style: TextStyle(color: Colors.white, fontFamily: 'Cairo'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
