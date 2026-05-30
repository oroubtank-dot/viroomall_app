// lib/features/ads/domain/usecases/get_active_auctions_usecase.dart
import '../entities/ad_entity.dart';
import '../repositories/ads_repository.dart';

class GetActiveAuctionsUseCase {
  final AdsRepository _repository;
  GetActiveAuctionsUseCase(this._repository);

  Stream<List<AdEntity>> call(String mode) {
    return _repository.getActiveAuctions(mode);
  }
}
