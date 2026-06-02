// lib/features/profile/presentation/providers/profile_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/repositories/user_repository.dart';
import '../../../../core/repositories/product_repository.dart';
import '../../../../core/models/product_model.dart';
import '../../domain/models/user_model.dart';
import '../../domain/models/seller_stats.dart';

final userRepositoryProvider = Provider((ref) => UserRepository());
final productRepositoryProvider = Provider((ref) => ProductRepository());

final profileNotifierProvider = StateNotifierProvider<ProfileNotifier, UserModel?>((ref) {
  return ProfileNotifier(ref);
});

class ProfileNotifier extends StateNotifier<UserModel?> {
  final Ref _ref;
  String? _currentUserId;

  ProfileNotifier(this._ref) : super(null);

  Future<void> loadUser(String userId) async {
    _currentUserId = userId;
    final user = await _ref.read(userRepositoryProvider).getUser(userId);
    state = user;
  }

  void setUser(UserModel user) {
    state = user;
  }

  void clear() {
    state = null;
    _currentUserId = null;
  }
}

final sellerProductsProvider = StreamProvider.family<List<ProductModel>, String>((ref, sellerId) {
  return ref.read(productRepositoryProvider).getProductsBySeller(sellerId);
});

final sellerProductCountProvider = FutureProvider.family<int, String>((ref, sellerId) {
  return ref.read(productRepositoryProvider).getProductCount(sellerId);
});

final sellerTotalViewsProvider = FutureProvider.family<int, String>((ref, sellerId) {
  return ref.read(productRepositoryProvider).getTotalViews(sellerId);
});

final sellerStatsProvider = StateProvider<SellerStats?>((ref) => null);
final buyerStatsProvider = StateProvider((ref) => null);