// lib/features/profile/presentation/screens/edit_profile_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';
import '../../../../core/widgets/viroo_background.dart';
import '../../../../core/services/auth_service.dart';
import '../providers/profile_provider.dart';
import '../../domain/models/user_model.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  final _storeNameController = TextEditingController();
  final _storeDescriptionController = TextEditingController();
  final _storePhoneController = TextEditingController();
  final _storeAddressController = TextEditingController();

  File? _profileImage;
  String? _currentPhotoUrl;
  bool _isLoading = false;
  bool _isSeller = false;
  bool _isBuyer = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _storeNameController.dispose();
    _storeDescriptionController.dispose();
    _storePhoneController.dispose();
    _storeAddressController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final user = AuthService.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      _nameController.text = data['name'] ?? '';
      _phoneController.text = data['phone'] ?? '';
      _emailController.text = data['email'] ?? '';
      _currentPhotoUrl = data['photoUrl'] ?? '';
      _isSeller = data['isSeller'] ?? false;
      _isBuyer = data['isBuyer'] ?? true;

      if (_isSeller) {
        _storeNameController.text = data['storeName'] ?? '';
        _storeDescriptionController.text = data['storeDescription'] ?? '';
        _storePhoneController.text = data['storePhone'] ?? '';
        _storeAddressController.text = data['storeAddress'] ?? '';
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 500,
      maxHeight: 500,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() => _profileImage = File(pickedFile.path));
    }
  }

  Future<String?> _uploadImage() async {
    if (_profileImage == null) return _currentPhotoUrl;

    try {
      final user = AuthService.currentUser;
      if (user == null) return _currentPhotoUrl;

      final ref = FirebaseStorage.instance.ref().child(
          'users/${user.uid}/profile_${DateTime.now().millisecondsSinceEpoch}.jpg');

      await ref.putFile(_profileImage!);
      return await ref.getDownloadURL();
    } catch (e) {
      return _currentPhotoUrl;
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = AuthService.currentUser;
      if (user == null) return;

      final photoUrl = await _uploadImage();

      final userData = {
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'email': _emailController.text.trim(),
        'photoUrl': photoUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (_isSeller) {
        userData['storeName'] = _storeNameController.text.trim();
        userData['storeDescription'] = _storeDescriptionController.text.trim();
        userData['storePhone'] = _storePhoneController.text.trim();
        userData['storeAddress'] = _storeAddressController.text.trim();
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update(userData);

      // ✅ تحديث الـ Provider عشان الصورة تظهر فوراً
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final updatedUser = UserModel.fromFirestore(doc);
        ref.read(profileNotifierProvider.notifier).setUser(updatedUser);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ تم تحديث البروفايل بنجاح!'),
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
          '✏️ تعديل البروفايل',
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
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: const Text(
              'حفظ',
              style: TextStyle(
                color: VirooColors.amberPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
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
                _buildProfileImage(),
                const SizedBox(height: 24),
                _buildBasicInfo(),
                const SizedBox(height: 20),
                if (_isSeller) _buildStoreInfo(),
                if (_isSeller) const SizedBox(height: 20),
                GlowingButton(
                  onPressed: _isLoading ? null : _saveProfile,
                  text: _isLoading ? 'جاري الحفظ...' : '💾 حفظ التغييرات',
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

  Widget _buildProfileImage() {
    return GestureDetector(
      onTap: _pickImage,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: VirooColors.glassDark,
              border: Border.all(color: VirooColors.amberPrimary, width: 3),
              image: _profileImage != null
                  ? DecorationImage(
                      image: FileImage(_profileImage!),
                      fit: BoxFit.cover,
                    )
                  : (_currentPhotoUrl != null && _currentPhotoUrl!.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(_currentPhotoUrl!),
                          fit: BoxFit.cover,
                        )
                      : null),
            ),
            child: _profileImage == null &&
                    (_currentPhotoUrl == null || _currentPhotoUrl!.isEmpty)
                ? const Icon(
                    Icons.person_rounded,
                    size: 60,
                    color: VirooColors.textSecondary,
                  )
                : null,
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: VirooColors.amberPrimary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.camera_alt_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfo() {
    return Column(
      children: [
        TextFormField(
          controller: _nameController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: 'الاسم *',
            prefixIcon: Icon(Icons.person_rounded),
          ),
          validator: (v) =>
              v == null || v.isEmpty ? 'الرجاء إدخال الاسم' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _phoneController,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'رقم الهاتف *',
            prefixIcon: Icon(Icons.phone_rounded),
          ),
          validator: (v) =>
              v == null || v.isEmpty ? 'الرجاء إدخال رقم الهاتف' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emailController,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'البريد الإلكتروني',
            prefixIcon: Icon(Icons.email_rounded),
          ),
        ),
      ],
    );
  }

  Widget _buildStoreInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: VirooColors.glassDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: VirooColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🏪 بيانات المتجر',
            style: TextStyle(
              color: VirooColors.amberPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _storeNameController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'اسم المتجر *',
              prefixIcon: Icon(Icons.store_rounded),
            ),
            validator: (v) =>
                v == null || v.isEmpty ? 'الرجاء إدخال اسم المتجر' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _storeDescriptionController,
            style: const TextStyle(color: Colors.white),
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'وصف المتجر',
              prefixIcon: Icon(Icons.description_rounded),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _storePhoneController,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'رقم التواصل (واتساب) *',
              prefixIcon: Icon(Icons.chat_rounded),
            ),
            validator: (v) =>
                v == null || v.isEmpty ? 'الرجاء إدخال رقم التواصل' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _storeAddressController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'العنوان',
              prefixIcon: Icon(Icons.location_on_rounded),
            ),
          ),
        ],
      ),
    );
  }
}
