// lib/features/admin/presentation/providers/add_product_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/product_repository.dart';
import '../states/add_product_state.dart';
import '../../../../core/models/product_model.dart';
import 'dart:io';

final productRepositoryProvider = Provider((ref) => ProductRepository());

class AddProductNotifier extends StateNotifier<AddProductState> {
  final Ref _ref;

  AddProductNotifier(this._ref) : super(const AddProductState());

  ProductRepository get _repository => _ref.read(productRepositoryProvider);

  void setImages(List<File> images) {
    state = state.copyWith(images: images);
  }

  void setVideo(File? video) {
    state = state.copyWith(video: video);
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  Future<void> saveProduct(ProductModel product) async {
    state =
        state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);

    try {
      // 1. رفع الصور
      final imageUrls =
          await _repository.uploadImages(state.images, product.id);

      // 2. تحديث المنتج بالصور
      final updatedProduct = product.copyWith(images: imageUrls);

      // 3. حفظ في Firestore
      await _repository.saveProductToFirestore(updatedProduct);

      // 4. نجاح
      state = state.copyWith(isLoading: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
        isSuccess: false,
      );
    }
  }
}

final addProductProvider =
    StateNotifierProvider<AddProductNotifier, AddProductState>((ref) {
  return AddProductNotifier(ref);
});
