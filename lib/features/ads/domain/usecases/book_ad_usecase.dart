// lib/features/ads/domain/usecases/book_ad_usecase.dart
import '../entities/ad_entity.dart';
import '../repositories/ads_repository.dart';

class BookAdUseCase {
  final AdsRepository _repository;
  BookAdUseCase(this._repository);

  Future<void> call(AdEntity ad) async {
    await _repository.bookFixedAd(ad);
  }
}
