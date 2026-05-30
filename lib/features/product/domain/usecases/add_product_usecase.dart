// lib/features/product/domain/usecases/add_product_usecase.dart
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class AddProductUseCase {
  final ProductRepository _repository;
  AddProductUseCase(this._repository);

  Future<void> call(ProductEntity product) async {
    await _repository.addProduct(product);
  }
}
