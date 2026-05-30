// lib/features/product/domain/repositories/product_repository.dart
import '../entities/product_entity.dart';

abstract class ProductRepository {
  Stream<List<ProductEntity>> getProducts(String marketType);
  Stream<List<ProductEntity>> getFeaturedProducts();
  Future<ProductEntity?> getProductById(String productId);
  Future<void> addProduct(ProductEntity product);
  Future<void> updateProduct(ProductEntity product);
  Future<void> deleteProduct(String productId);
}
