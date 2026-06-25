// lib/features/home/presentation/providers/product_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/product_service.dart';
import '../../../../core/models/product_model.dart';
import '../../../../core/constants/product_type.dart';
import 'home_provider.dart';

final productServiceProvider =
    Provider<ProductService>((ref) => ProductService());

// بروفايدر المنتجات (بيعمل Re-fetch تلقائي لما المود يتغير)
final productsStreamProvider = StreamProvider<List<ProductModel>>((ref) {
  final currentMode = ref.watch(shopModeProvider);
  final service = ref.watch(productServiceProvider);

  if (currentMode == ProductType.shopping) {
    return service.getAllProducts();
  }

  return service.getProductsByMode(currentMode);
});

// بروفايدر المنتجات المميزة
final featuredProductsProvider = StreamProvider<List<ProductModel>>((ref) {
  final service = ref.watch(productServiceProvider);
  return service.getFeaturedProducts();
});
