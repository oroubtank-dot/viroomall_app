// lib/features/profile/domain/services/profile_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// جلب بيانات المستخدم من Firestore
  Future<UserModel?> getUserProfile(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// تحديث بيانات المستخدم
  Future<void> updateUserProfile(
      String userId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(userId).update(data);
    } catch (e) {
      // معالجة الخطأ
    }
  }

  /// تحديث صورة المستخدم
  Future<void> updateUserPhoto(String userId, String photoUrl) async {
    await _firestore.collection('users').doc(userId).update({
      'photoUrl': photoUrl,
    });
  }

  /// تحديث تقييم البائع (عندما يقيّم مشتري)
  Future<void> updateSellerRating(String sellerId, double newRating) async {
    final doc = await _firestore.collection('users').doc(sellerId).get();
    if (doc.exists) {
      final currentRating = doc.data()?['rating'] ?? 0.0;
      final totalSales = doc.data()?['totalSales'] ?? 0;
      final newAvgRating =
          ((currentRating * totalSales) + newRating) / (totalSales + 1);

      await _firestore.collection('users').doc(sellerId).update({
        'rating': newAvgRating,
      });
    }
  }

  /// زيادة عدد المبيعات للبائع
  Future<void> incrementTotalSales(String sellerId) async {
    await _firestore.collection('users').doc(sellerId).update({
      'totalSales': FieldValue.increment(1),
    });
  }

  /// زيادة عدد المشاهدات الإجمالية للبائع
  Future<void> incrementTotalViews(String sellerId, int views) async {
    await _firestore.collection('users').doc(sellerId).update({
      'totalViews': FieldValue.increment(views),
    });
  }

  /// إنشاء مستخدم جديد
  Future<void> createUser(UserModel user) async {
    await _firestore.collection('users').doc(user.id).set(user.toMap());
  }
}
