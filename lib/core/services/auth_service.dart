// lib/core/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'storage_service.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static User? get currentUser => _auth.currentUser;

  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// حفظ بيانات المستخدم في Firestore بعد تسجيل الدخول
  static Future<void> saveUserToFirestore(User user) async {
    try {
      final userData = {
        'uid': user.uid,
        'name': user.displayName ?? 'مستخدم VirooMall',
        'email': user.email ?? '',
        'phone': user.phoneNumber ?? '',
        'photoUrl': user.photoURL ?? '',
        'isSeller': false,
        'isBuyer': true,
        'createdAt': FieldValue.serverTimestamp(),
        'rating': 0.0,
        'totalSales': 0,
        'totalProducts': 0,
        'totalViews': 0,
      };

      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(userData, SetOptions(merge: true));

      print('✅ تم حفظ المستخدم في Firestore: ${user.uid}');
    } catch (e) {
      print('❌ خطأ في حفظ المستخدم: $e');
    }
  }

  static Future<void> sendOTP({
    required String phoneNumber,
    required Function(String) onCodeSent,
    required Function(String) onError,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          final userCredential = await _auth.signInWithCredential(credential);
          if (userCredential.user != null) {
            await saveUserToFirestore(userCredential.user!);
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          onError(e.message ?? 'حدث خطأ ما');
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      onError(e.toString());
    }
  }

  static Future<User?> verifyOTP({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        await saveUserToFirestore(userCredential.user!);
      }

      return userCredential.user;
    } catch (e) {
      return null;
    }
  }

  static Future<void> signOut() async {
    await _auth.signOut();
    await StorageService.logout();
  }
}
