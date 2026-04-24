// lib/features/admin/presentation/screens/add_product_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';
import '../../../../core/widgets/viroo_background.dart';
import '../widgets/product_form_base.dart';
import '../widgets/product_form_sections.dart';
import '../providers/add_product_provider.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  String _selectedType = 'new';
  String _selectedCategory = 'electronics_mobiles';
  String _usedCondition = 'good';
  bool _isNegotiable = true;
  File? _imageFile;
  File? _videoFile;
  bool _isLoading = false;

  @override
  void dispose() {
    ProductFormBase.disposeAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = _getModeColor();

    return Scaffold(
      backgroundColor: VirooColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('إضافة منتج جديد',
            style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        leading: IconButton(
            icon: const Icon(Icons.close_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context)),
      ),
      body: VirooBackground(
        showOrbs: true,
        themeColor: themeColor,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🎯 اختيار نوع المنتج
              const Text('📂 اختر نوع المنتج أولاً:',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo')),
              const SizedBox(height: 12),
              Row(
                children: [
                  _typeChip('new', '🛍️ تسوق', VirooColors.shopping),
                  _typeChip('wholesale', '🏪 جملة', VirooColors.wholesale),
                  _typeChip('used', '♻️ مستعمل', VirooColors.used),
                  _typeChip('outlet', '🔥 فرز', VirooColors.outlet),
                ],
              ),
              const SizedBox(height: 24),

              // 📸 الصورة
              const Text('📸 صورة المنتج *',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo')),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _pickImage,
                child: GlassContainer(
                  height: 180,
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(20),
                  child: _imageFile == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              Icon(Icons.add_a_photo_rounded,
                                  size: 50, color: themeColor),
                              const SizedBox(height: 8),
                              Text('اضغط لإضافة صورة',
                                  style: TextStyle(
                                      color: VirooColors.textSecondary,
                                      fontFamily: 'Cairo')),
                            ])
                      : Stack(children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.file(_imageFile!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity)),
                          Positioned(
                              bottom: 10,
                              right: 10,
                              child: GestureDetector(
                                  onTap: _pickImage,
                                  child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: VirooColors.amberPrimary
                                              .withAlpha(230),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: const Icon(Icons.edit_rounded,
                                          color: Colors.white, size: 20)))),
                        ]),
                ),
              ),
              const SizedBox(height: 24),

              // 📝 اسم المنتج
              ProductFormBase.buildTextField(
                  controller: ProductFormBase.nameController,
                  hint: 'اسم المنتج',
                  icon: Icons.shopping_bag_rounded,
                  required: true),
              const SizedBox(height: 16),

              // 💰 السعر
              ProductFormBase.buildTextField(
                  controller: ProductFormBase.priceController,
                  hint: 'السعر',
                  icon: Icons.money_rounded,
                  keyboardType: TextInputType.number,
                  required: true),
              const SizedBox(height: 16),

              // 📂 القسم (41+)
              const Text('القسم *',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Cairo')),
              const SizedBox(height: 8),
              ProductFormBase.buildCategoryDropdown(_selectedCategory, (val) {
                setState(() => _selectedCategory = val);
              }),
              const SizedBox(height: 16),

              // 📋 الوصف
              ProductFormBase.buildTextField(
                  controller: ProductFormBase.descController,
                  hint: 'وصف المنتج',
                  icon: Icons.description_rounded,
                  maxLines: 3),
              const SizedBox(height: 16),

              // 📍 الموقع
              ProductFormBase.buildTextField(
                  controller: ProductFormBase.locationController,
                  hint: 'الموقع (المدينة/المنطقة)',
                  icon: Icons.location_on_rounded),
              const SizedBox(height: 16),

              // 👤 اسم البائع
              ProductFormBase.buildTextField(
                  controller: ProductFormBase.sellerNameController,
                  hint: 'اسم البائع/المتجر',
                  icon: Icons.store_rounded),
              const SizedBox(height: 16),

              // 📞 رقم البائع
              ProductFormBase.buildTextField(
                  controller: ProductFormBase.sellerPhoneController,
                  hint: 'رقم الهاتف للواتساب',
                  icon: Icons.phone_rounded,
                  keyboardType: TextInputType.phone),
              const SizedBox(height: 16),

              // 🎬 فيديو
              GestureDetector(
                onTap: _pickVideo,
                child: GlassContainer(
                  padding: const EdgeInsets.all(14),
                  borderRadius: BorderRadius.circular(16),
                  child: Row(children: [
                    Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: VirooColors.info.withAlpha(51),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.videocam_rounded,
                            color: VirooColors.info, size: 22)),
                    const SizedBox(width: 12),
                    Text(
                        _videoFile != null
                            ? '🎬 تم اختيار فيديو'
                            : '🎬 فيديو (اختياري - 30 ثانية)',
                        style: TextStyle(
                            color: _videoFile != null
                                ? VirooColors.success
                                : VirooColors.textSecondary,
                            fontFamily: 'Cairo',
                            fontSize: 13)),
                  ]),
                ),
              ),

              // 🏪 قسم الجملة
              if (_selectedType == 'wholesale')
                ProductFormSections.wholesaleSection(),

              // ♻️ قسم المستعمل
              if (_selectedType == 'used')
                ProductFormSections.usedSection(
                    _usedCondition,
                    (v) => setState(() => _usedCondition = v),
                    _isNegotiable,
                    (v) => setState(() => _isNegotiable = v)),

              // 🔥 قسم الفرز
              if (_selectedType == 'outlet')
                ProductFormSections.outletSection(),

              const SizedBox(height: 30),
              GlowingButton(
                onPressed: _isLoading ? () {} : _saveProduct,
                text: _isLoading ? '⏳ جاري النشر...' : '🚀 نشر المنتج الآن',
                isLoading: _isLoading,
                backgroundColor: themeColor,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (pickedFile != null) setState(() => _imageFile = File(pickedFile.path));
  }

  Future<void> _pickVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(
        source: ImageSource.gallery, maxDuration: const Duration(seconds: 30));
    if (pickedFile != null) setState(() => _videoFile = File(pickedFile.path));
  }

  Future<void> _saveProduct() async {
    if (ProductFormBase.nameController.text.isEmpty ||
        ProductFormBase.priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('⚠️ الاسم والسعر إجباريين',
              style: TextStyle(fontFamily: 'Cairo')),
          backgroundColor: VirooColors.warning));
      return;
    }
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text('⚠️ الصورة إجبارية', style: TextStyle(fontFamily: 'Cairo')),
          backgroundColor: VirooColors.warning));
      return;
    }
    if (_selectedType == 'wholesale' &&
        ProductFormBase.minQuantityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('⚠️ الحد الأدنى للطلب إجباري للجملة',
              style: TextStyle(fontFamily: 'Cairo')),
          backgroundColor: VirooColors.warning));
      return;
    }
    if (_selectedType == 'outlet' &&
        ProductFormBase.outletReasonController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('⚠️ سبب التصفية إجباري للفرز',
              style: TextStyle(fontFamily: 'Cairo')),
          backgroundColor: VirooColors.warning));
      return;
    }

    setState(() => _isLoading = true);

    final formData = {
      'name': ProductFormBase.nameController.text.trim(),
      'price': ProductFormBase.priceController.text.trim(),
      'description': ProductFormBase.descController.text.trim(),
      'productType': _selectedType,
      'category': _selectedCategory,
      'condition': _usedCondition,
      'location': ProductFormBase.locationController.text.trim(),
      'sellerName': ProductFormBase.sellerNameController.text.trim(),
      'sellerPhone': ProductFormBase.sellerPhoneController.text.trim(),
      'imageFile': _imageFile,
      'videoFile': _videoFile,
      'originalPrice': ProductFormBase.originalPriceController.text.trim(),
      'defects': ProductFormBase.defectsController.text.trim(),
      'minQuantity': ProductFormBase.minQuantityController.text.trim(),
      'negotiable': _isNegotiable,
      'outletReason': ProductFormBase.outletReasonController.text.trim(),
      'outletQuantity': ProductFormBase.outletQuantityController.text.trim(),
    };

    final success = await ref
        .read(addProductNotifierProvider.notifier)
        .saveProduct(formData);

    setState(() => _isLoading = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('✅ تم نشر المنتج بنجاح!',
              style: TextStyle(fontFamily: 'Cairo', color: Colors.white)),
          backgroundColor: VirooColors.success));
      Navigator.pop(context);
    }
  }

  Widget _typeChip(String value, String label, Color color) {
    final isSelected = _selectedType == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedType = value),
        child: Container(
          margin: const EdgeInsets.only(right: 6),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? color.withAlpha(51) : VirooColors.glassDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: isSelected ? color : VirooColors.glassBorder,
                width: isSelected ? 2 : 1),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                        color: color.withAlpha(38),
                        blurRadius: 10,
                        spreadRadius: 1)
                  ]
                : null,
          ),
          child: Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                  color: isSelected ? color : VirooColors.textSecondary)),
        ),
      ),
    );
  }

  Color _getModeColor() {
    switch (_selectedType) {
      case 'wholesale':
        return VirooColors.wholesale;
      case 'used':
        return VirooColors.used;
      case 'outlet':
        return VirooColors.outlet;
      default:
        return VirooColors.shopping;
    }
  }
}
