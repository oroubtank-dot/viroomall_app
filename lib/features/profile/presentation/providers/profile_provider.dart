// lib/features/profile/presentation/providers/profile_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/user_model.dart';
import '../../domain/models/seller_stats.dart';
import '../../domain/models/buyer_stats.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);
final sellerStatsProvider = StateProvider<SellerStats?>((ref) => null);
final buyerStatsProvider = StateProvider<BuyerStats?>((ref) => null);

final isUserLoadingProvider = StateProvider<bool>((ref) => false);

class ProfileNotifier extends StateNotifier<UserModel?> {
  ProfileNotifier() : super(null);

  void setUser(UserModel user) {
    state = user;
  }

  void updateUser(UserModel user) {
    state = user;
  }

  void clearUser() {
    state = null;
  }
}

final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, UserModel?>((ref) {
  return ProfileNotifier();
});
