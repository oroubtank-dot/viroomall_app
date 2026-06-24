// lib/features/profile/presentation/screens/edit_store_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';
import '../../../../core/widgets/viroo_background.dart';
import '../../../../core/services/auth_service.dart';
import '../providers/profile_provider.dart';
import '../../domain/models/user_model.dart';

class EditStoreScreen extends ConsumerStatefulWidget {
  const EditStoreScreen({super.key});

  @override
  ConsumerState<EditStoreScreen> createState() => _EditStoreScreenState();
}

class _EditStoreScreenState extends ConsumerState<EditStoreScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storeNameController = TextEditingController();
  final _storeDescriptionController = TextEditingController();
  final _storePhoneController = TextEditingController();
  final _storeAddressController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = AuthService.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        _storeNameController.text = data['storeName'] ?? data['name'] ?? '';
        _storeDescriptionController.text = data['storeDescription'] ?? '';
        _storePhoneController.text = data['storePhone'] ?? data['phone'] ?? '';
        _storeAddressController.text = data['storeAddress'] ?? '';
      }
    }
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _storeDescriptionController.dispose();
    _storePhoneController.dispose();
    _storeAddressController.dispose();
    super.dispose();
  }

  Future<void> _saveStoreData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = AuthService.currentUser;
      if (user == null) return;

      final data = {
        'storeName': _storeNameController.text.trim(),
        'storeDescription': _storeDescriptionController.text.trim(),
        'storePhone': _storePhoneController.text.trim(),
        'storeAddress': _storeAddressController.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update(data);

      // تحديث الـ Provider
      final updatedUser = UserModel(
        id: user.uid,
        name: user.displayName ?? '',
        email: user.email ?? '',
        phone: user.phoneNumber ?? '',
        photoUrl: user.photoURL ?? '',
        isSeller: true,
        isBuyer: true,
        createdAt: DateTime.now(),
        storeName: _storeNameController.text.trim(),
        storeDescription: _storeDescriptionController.text.trim(),
        storePhone: _storePhoneController.text.trim(),
        storeAddress: _storeAddressController.text.trim(),
      );

      ref.read(profileNotifierProvider.notifier).setUser(updatedUser);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ تم تحديث بيانات المتجر بنجاح!'),
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
          '🏪 تعديل بيانات المتجر',
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
              children: [
                const Text(
                  '📝 بيانات متجرك',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'عدل بيانات متجرك عشان يظهر بشكل احترافي للعملاء',
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

                // زر الحفظ
                GlowingButton(
                  onPressed: _isLoading ? null : _saveStoreData,
                  text: _isLoading ? 'جاري الحفظ...' : '💾 حفظ البيانات',
                  backgroundColor: VirooColors.amberPrimary,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
