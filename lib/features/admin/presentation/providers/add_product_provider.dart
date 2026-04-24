// lib/features/admin/presentation/providers/add_product_provider.dart
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final addProductLoadingProvider = StateProvider<bool>((ref) => false);
final addProductErrorProvider = StateProvider<String?>((ref) => null);

final addProductNotifierProvider =
    StateNotifierProvider<AddProductNotifier, void>((ref) {
  return AddProductNotifier(ref);
});

class AddProductNotifier extends StateNotifier<void> {
  final Ref _ref;

  AddProductNotifier(this._ref) : super(null);

  Future<bool> saveProduct(Map<String, dynamic> formData) async {
    _ref.read(addProductLoadingProvider.notifier).state = true;
    _ref.read(addProductErrorProvider.notifier).state = null;

    try {
      // الصورة (إجبارية)
      String base64Image = '';
      final imageFile = formData['imageFile'];
      if (imageFile != null && imageFile is File) {
        final bytes = await imageFile.readAsBytes();
        base64Image = base64Encode(bytes);
        print('✅ صورة Base64 - الحجم: ${bytes.length} bytes');
      }

      // الفيديو (اختياري)
      String? base64Video;
      final videoFile = formData['videoFile'];
      if (videoFile != null && videoFile is File) {
        final bytes = await videoFile.readAsBytes();
        base64Video = base64Encode(bytes);
        print('✅ فيديو Base64 - الحجم: ${bytes.length} bytes');
      }

      final price = double.tryParse(formData['price']?.toString() ?? '0') ?? 0;

      final productData = {
        'title': formData['name'] ?? 'منتج بدون اسم',
        'description': formData['description']?.isNotEmpty == true
            ? formData['description']
            : 'لا يوجد وصف',
        'price': price,
        'originalPrice': formData['originalPrice']?.isNotEmpty == true
            ? double.tryParse(formData['originalPrice'])
            : null,
        'productType': formData['productType'] ?? 'new',
        'categoryId': formData['category'] ?? 'general',
        'images': base64Image.isNotEmpty ? [base64Image] : [],
        'videoUrl': base64Video, // اختياري
        'condition': formData['condition'] ?? 'new',
        'location': formData['location']?.isNotEmpty == true
            ? formData['location']
            : 'القاهرة',
        'sellerName': formData['sellerName']?.isNotEmpty == true
            ? formData['sellerName']
            : 'بائع VirooMall',
        'sellerPhone': formData['sellerPhone']?.isNotEmpty == true
            ? formData['sellerPhone']
            : '+201001234567',
        'sellerId': 'admin',
        'views': 0,
        'favorites': 0,
        'status': 'approved',
        'qualityScore': 85,
        'createdAt': FieldValue.serverTimestamp(),
        'expiresAt':
            Timestamp.fromDate(DateTime.now().add(const Duration(days: 30))),
        'averageRating': 0.0,
        'ratingCount': 0,
      };

      print('📦 title: ${productData['title']}');
      print('📦 price: ${productData['price']}');
      print('📦 productType: ${productData['productType']}');
      print('📦 hasImage: ${(productData['images'] as List).isNotEmpty}');
      print('📦 hasVideo: ${productData['videoUrl'] != null}');

      await FirebaseFirestore.instance.collection('products').add(productData);

      print('✅ تم حفظ المنتج في Firestore بنجاح');

      _ref.read(addProductLoadingProvider.notifier).state = false;
      return true;
    } catch (e) {
      print('❌ خطأ في الحفظ: $e');
      _ref.read(addProductLoadingProvider.notifier).state = false;
      _ref.read(addProductErrorProvider.notifier).state = '❌ حدث خطأ: $e';
      return false;
    }
  }
}
