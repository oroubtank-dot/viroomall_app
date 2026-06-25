// lib/core/services/image_picker_service.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../theme/app_colors.dart';
import 'package:video_compress/video_compress.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<List<File>> pickMultipleImages(BuildContext context) async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFiles.isEmpty) return [];

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

  // ✅ دالة ضغط الصورة (للاستخدام العام)
  Future<File?> compressImage(File imageFile) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final targetPath = path.join(
        tempDir.path,
        'compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      final result = await FlutterImageCompress.compressAndGetFile(
        imageFile.absolute.path,
        targetPath,
        quality: 70,
        minWidth: 600,
        minHeight: 600,
      );

      if (result == null) return null;
      return File(result.path);
    } catch (e) {
      debugPrint('خطأ في ضغط الصورة: $e');
      return imageFile;
    }
  }

  Future<File?> pickVideo(BuildContext context) async {
    try {
      final XFile? pickedFile = await _picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(seconds: 30),
      );

      if (pickedFile == null) return null;

      final compressedVideo = await _compressVideo(File(pickedFile.path));
      return compressedVideo ?? File(pickedFile.path);
    } catch (e) {
      debugPrint('خطأ في اختيار الفيديو: $e');
      return null;
    }
  }

  Future<File?> pickVideoFromCamera(BuildContext context) async {
    try {
      final XFile? pickedFile = await _picker.pickVideo(
        source: ImageSource.camera,
        maxDuration: const Duration(seconds: 30),
      );

      if (pickedFile == null) return null;

      final compressedVideo = await _compressVideo(File(pickedFile.path));
      return compressedVideo ?? File(pickedFile.path);
    } catch (e) {
      debugPrint('خطأ في تصوير الفيديو: $e');
      return null;
    }
  }

  Future<File?> _compressVideo(File videoFile) async {
    try {
      final info = await VideoCompress.compressVideo(
        videoFile.path,
        quality: VideoQuality.MediumQuality,
        includeAudio: true,
      );

      if (info == null || info.path == null) return null;
      return File(info.path!);
    } catch (e) {
      debugPrint('خطأ في ضغط الفيديو: $e');
      return videoFile;
    }
  }

  Future<File?> _cropImage(File imageFile, BuildContext context) async {
    try {
      if (!context.mounted) return imageFile;

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
      );

      if (result == null) return null;
      return File(result.path);
    } catch (e) {
      debugPrint('خطأ في ضغط الصورة: $e');
      return imageFile;
    }
  }

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

  Future<void> previewVideo({
    required BuildContext context,
    required File videoFile,
    required VoidCallback onConfirm,
  }) async {
    if (!context.mounted) return;

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
              'معاينة الفيديو',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.black,
              child: const Center(
                child: Icon(
                  Icons.play_circle_fill_rounded,
                  color: VirooColors.amberPrimary,
                  size: 60,
                ),
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

  Future<File?> pickImageFromCamera(BuildContext context) async {
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
}
