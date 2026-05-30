// lib/features/product/domain/usecases/get_products_usecase.dart
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository _repository;
  GetProductsUseCase(this._repository);

  Stream<List<ProductEntity>> call(String marketType) {
    return _repository.getProducts(marketType);
  }
}
