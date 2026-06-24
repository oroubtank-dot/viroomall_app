// lib/features/seller_convert/presentation/screens/convert_to_seller_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';
import '../../../../core/widgets/viroo_background.dart';
import '../../../../core/services/auth_service.dart';
import '../../../profile/domain/models/user_model.dart';
import '../../../profile/presentation/providers/profile_provider.dart';

class ConvertToSellerScreen extends ConsumerStatefulWidget {
  const ConvertToSellerScreen({super.key});

  @override
  ConsumerState<ConvertToSellerScreen> createState() =>
      _ConvertToSellerScreenState();
}

class _ConvertToSellerScreenState extends ConsumerState<ConvertToSellerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storeNameController = TextEditingController();
  final _storeDescriptionController = TextEditingController();
  final _storePhoneController = TextEditingController();
  final _storeAddressController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _storeNameController.dispose();
    _storeDescriptionController.dispose();
    _storePhoneController.dispose();
    _storeAddressController.dispose();
    super.dispose();
  }

  Future<void> _convertToSeller() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = AuthService.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('الرجاء تسجيل الدخول أولاً'),
            backgroundColor: VirooColors.error,
          ),
        );
        return;
      }

      // تحديث بيانات المستخدم في Firestore
      final userData = {
        'isSeller': true,
        'storeName': _storeNameController.text.trim(),
        'storeDescription': _storeDescriptionController.text.trim(),
        'storePhone': _storePhoneController.text.trim(),
        'storeAddress': _storeAddressController.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update(userData);

      // تحديث الـ UserModel في الـ Provider
      final updatedUser = UserModel(
        id: user.uid,
        name: _storeNameController.text.trim(),
        email: user.email ?? '',
        phone: user.phoneNumber ?? '',
        photoUrl: user.photoURL ?? '',
        isSeller: true,
        isBuyer: true,
        createdAt: DateTime.now(),
      );

      ref.read(profileNotifierProvider.notifier).setUser(updatedUser);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🎉 تم التحويل إلى بائع بنجاح!'),
            backgroundColor: VirooColors.success,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ خطأ: ${e.toString()}'),
            backgroundColor: VirooColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VirooColors.background,
      appBar: AppBar(
        title: const Text(
          '📢 التحويل إلى بائع',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: VirooBackground(
        showOrbs: true,
        themeColor: VirooColors.amberPrimary,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // العنوان
                const Text(
                  '✨ افتح متجرك الآن',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'حول حسابك إلى بائع وابدأ في بيع منتجاتك',
                  style: TextStyle(
                    fontSize: 14,
                    color: VirooColors.textSecondary,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 30),

                // اسم المتجر
                TextFormField(
                  controller: _storeNameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'اسم المتجر *',
                    hintText: 'مثال: متجر الإلكترونيات',
                    prefixIcon: Icon(Icons.store_rounded),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'الرجاء إدخال اسم المتجر' : null,
                ),
                const SizedBox(height: 16),

                // وصف المتجر
                TextFormField(
                  controller: _storeDescriptionController,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'وصف المتجر',
                    hintText: 'مثال: متجر متخصص في الإلكترونيات والأجهزة',
                    prefixIcon: Icon(Icons.description_rounded),
                  ),
                ),
                const SizedBox(height: 16),

                // رقم الهاتف
                TextFormField(
                  controller: _storePhoneController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'رقم التواصل (واتساب) *',
                    hintText: 'مثال: 01012345678',
                    prefixIcon: Icon(Icons.phone_android_rounded),
                  ),
                  validator: (v) => v == null || v.isEmpty
                      ? 'الرجاء إدخال رقم التواصل'
                      : null,
                ),
                const SizedBox(height: 16),

                // العنوان
                TextFormField(
                  controller: _storeAddressController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'العنوان',
                    hintText: 'مثال: القاهرة - مصر',
                    prefixIcon: Icon(Icons.location_on_rounded),
                  ),
                ),
                const SizedBox(height: 30),

                // زر التحويل
                GlowingButton(
                  onPressed: _isLoading ? null : () => _convertToSeller(),
                  text: _isLoading ? 'جاري التحويل...' : '🚀 تحويل إلى بائع',
                  backgroundColor: VirooColors.amberPrimary,
                  isLoading: _isLoading,
                ),

                const SizedBox(height: 16),

                // ملاحظة
                GlassContainer(
                  padding: const EdgeInsets.all(12),
                  borderRadius: BorderRadius.circular(12),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline_rounded,
                          color: VirooColors.info, size: 20),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'بعد التحويل، ستتمكن من إضافة منتجات وعرضها في المتجر',
                          style: TextStyle(
                            color: VirooColors.textSecondary,
                            fontSize: 12,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
