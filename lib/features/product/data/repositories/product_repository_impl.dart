// lib/features/product/data/repositories/product_repository_impl.dart
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;

  ProductRepositoryImpl(this._remoteDataSource);

  @override
  Stream<List<ProductEntity>> getProducts(String marketType) {
    return _remoteDataSource
        .getProducts(marketType)
        .map((products) => products.map((p) => p.toEntity()).toList());
  }

  @override
  Stream<List<ProductEntity>> getFeaturedProducts() {
    return _remoteDataSource
        .getFeaturedProducts()
        .map((products) => products.map((p) => p.toEntity()).toList());
  }

  @override
  Future<ProductEntity?> getProductById(String productId) async {
    final product = await _remoteDataSource.getProductById(productId);
    return product?.toEntity();
  }

  @override
  Future<void> addProduct(ProductEntity product) async {
    final model = ProductModel(
      id: product.id,
      sellerId: product.sellerId,
      sellerName: product.sellerName,
      title: product.title,
      description: product.description,
      price: product.price,
      originalPrice: product.originalPrice,
      marketType: product.marketType,
      categoryId: product.categoryId,
      images: product.images,
      videoUrl: product.videoUrl,
      condition: product.condition,
      defects: product.defects,
      location: product.location,
      status: product.status,
      qualityScore: product.qualityScore,
      createdAt: product.createdAt,
      expiresAt: product.expiresAt,
    );
    await _remoteDataSource.addProduct(model);
  }

  @override
  Future<void> updateProduct(ProductEntity product) async {
    final model = ProductModel(
      id: product.id,
      sellerId: product.sellerId,
      sellerName: product.sellerName,
      title: product.title,
      description: product.description,
      price: product.price,
      originalPrice: product.originalPrice,
      marketType: product.marketType,
      categoryId: product.categoryId,
      images: product.images,
      videoUrl: product.videoUrl,
      condition: product.condition,
      defects: product.defects,
      location: product.location,
      status: product.status,
      qualityScore: product.qualityScore,
      createdAt: product.createdAt,
      expiresAt: product.expiresAt,
    );
    await _remoteDataSource.updateProduct(model);
  }

  @override
  Future<void> deleteProduct(String productId) async {
    await _remoteDataSource.deleteProduct(productId);
  }
}
