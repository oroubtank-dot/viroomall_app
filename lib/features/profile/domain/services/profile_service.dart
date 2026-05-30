// lib/features/profile/domain/services/profile_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/seller_stats.dart';
import '../models/buyer_stats.dart';

class ProfileService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<UserModel?> getUser(String userId) async {
    try {
      final doc = await _db.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<SellerStats?> getSellerStats(String userId) async {
    try {
      final doc = await _db.collection('seller_stats').doc(userId).get();
      if (doc.exists) {
        return SellerStats.fromFirestore(doc.data()!);
      }
      return SellerStats();
    } catch (e) {
      return SellerStats();
    }
  }

  Future<BuyerStats?> getBuyerStats(String userId) async {
    try {
      final doc = await _db.collection('buyer_stats').doc(userId).get();
      if (doc.exists) {
        return BuyerStats.fromFirestore(doc.data()!);
      }
      return BuyerStats();
    } catch (e) {
      return BuyerStats();
    }
  }

  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    try {
      await _db.collection('users').doc(userId).update(data);
    } catch (e) {
      // Handle error
    }
  }
}
