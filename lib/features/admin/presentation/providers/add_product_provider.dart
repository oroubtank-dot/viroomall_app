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
      final imageFile = formData['imageFile'] as File;
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      final productData = {
        'title': formData['name'],
        'description': formData['description']?.isNotEmpty == true
            ? formData['description']
            : 'لا يوجد وصف',
        'price': double.parse(formData['price']),
        'originalPrice': formData['originalPrice']?.isNotEmpty == true
            ? double.parse(formData['originalPrice'])
            : null,
        'productType': formData['productType'],
        'categoryId': formData['category'],
        'images': [base64Image],
        'condition': formData['condition'],
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
        'expiresAt': DateTime.now().add(const Duration(days: 30)),
        'averageRating': 0.0,
        'ratingCount': 0,
      };

      await FirebaseFirestore.instance.collection('products').add(productData);

      _ref.read(addProductLoadingProvider.notifier).state = false;
      return true;
    } catch (e) {
      _ref.read(addProductLoadingProvider.notifier).state = false;
      _ref.read(addProductErrorProvider.notifier).state = '❌ حدث خطأ: $e';
      return false;
    }
  }
}
