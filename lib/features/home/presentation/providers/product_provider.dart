import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/product_model.dart';
import '../../../../core/services/product_service.dart';
import 'home_provider.dart';

/// Provider لقائمة المنتجات حسب الوضع المختار
final productsProvider =
    StreamProvider.family<List<ProductModel>, ShopMode>((ref, mode) {
  String? productType;

  switch (mode) {
    case ShopMode.shopping:
      productType = null; // كل المنتجات
      break;
    case ShopMode.wholesale:
      productType = 'wholesale';
      break;
    case ShopMode.used:
      productType = 'used';
      break;
    case ShopMode.outlet:
      productType = 'outlet';
      break;
  }

  return ProductService.getProductsStream(
    productType: productType,
    limit: 20,
  );
});

/// Provider للمنتجات المميزة (العروض)
final featuredProductsProvider = StreamProvider<List<ProductModel>>((ref) {
  return ProductService.getProductsStream(
    productType: null,
    limit: 6,
  );
});

/// Provider لمنتج واحد
final productProvider =
    FutureProvider.family<ProductModel?, String>((ref, productId) {
  return ProductService.getProduct(productId);
});
