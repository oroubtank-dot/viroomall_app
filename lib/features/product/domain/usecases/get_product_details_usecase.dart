// lib/features/product/domain/usecases/get_product_details_usecase.dart
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetProductDetailsUseCase {
  final ProductRepository _repository;
  GetProductDetailsUseCase(this._repository);

  Future<ProductEntity?> call(String productId) async {
    return await _repository.getProductById(productId);
  }
}
