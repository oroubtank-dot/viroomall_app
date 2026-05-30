// lib/features/home/presentation/providers/product_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/product_service.dart';
import '../../../../core/models/product_model.dart';
import 'home_provider.dart';

final productServiceProvider =
    Provider<ProductService>((ref) => ProductService());

// 👇 بروفايدر المنتجات (بيعمل Re-fetch تلقائي لما المود يتغير)
final productsStreamProvider = StreamProvider<List<ProductModel>>((ref) {
  // 1. مراقبة المود الحالي (shopping, wholesale, used, outlet)
  final currentMode = ref.watch(shopModeProvider);
  final service = ref.watch(productServiceProvider);

  // 2. طلب المنتجات الخاصة بهذا المود فقط من السيرفر
  // لو المود shopping، نجيب كل المنتجات
  if (currentMode == ShopMode.shopping) {
    return service.getAllProducts();
  }

  // غير كده، نفلتر حسب المود
  return service.getProductsByMode(currentMode.name);
});

// 👇 بروفايدر المنتجات المميزة (للعروض)
final featuredProductsProvider = StreamProvider<List<ProductModel>>((ref) {
  final service = ref.watch(productServiceProvider);
  return service.getFeaturedProducts();
});
