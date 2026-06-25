// lib/features/admin/presentation/screens/add_product_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/viroo_background.dart';
import '../../../../core/services/image_picker_service.dart';
import '../../../../core/services/auth_service.dart';
import '../widgets/product_type_selector.dart';
import '../widgets/product_basic_info.dart';
import '../widgets/category_dropdown.dart';
import '../widgets/location_field.dart';
import '../widgets/farz_fields.dart';
import '../widgets/gomla_fields.dart';
import '../widgets/tasawok_fields.dart';
import '../widgets/mosta3mal_fields.dart';
import '../widgets/seller_contact_info.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePickerService _imagePickerService = ImagePickerService();
  bool _isLoading = false;

  // ========== الحقول الأساسية ==========
  String _productType = 'farz';
  String _title = '';
  String _description = '';
  String _categoryId = '';
  String _location = '';
  List<File> _images = [];
  File? _videoFile;

  // ========== Farz ==========
  String _price = '';
  String _originalPrice = '';
  bool _hasWarranty = false;
  String _warrantyMonths = '12';
  bool _priceIncludesTax = true;

  // ========== Gomla ==========
  String _wholesalePrice = '';
  String _minQuantity = '10';
  String _maxQuantity = '100';

  // ========== Tasawok ==========
  String _condition = 'good';
  String _defects = '';
  String _reasonForSelling = '';
  String _usageDuration = '';
  bool _hasOriginalBox = false;
  String _originalReceipt = 'no';

  // ========== Mosta3mal ==========
  String _discountPercentage = '';
  String _limitedQuantity = '';
  DateTime? _expiryDate;
  String _flashSaleType = 'normal';
  String _couponCode = '';

  // ========== بيانات البائع ==========
  String _sellerPhone = '';
  String _sellerWhatsapp = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VirooColors.background,
      appBar: AppBar(
        title: const Text('إضافة منتج جديد',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _submitProduct,
            child: const Text('نشر',
                style: TextStyle(
                    color: VirooColors.amberPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: VirooBackground(
        showOrbs: true,
        child: _isLoading
            ? const Center(
                child:
                    CircularProgressIndicator(color: VirooColors.amberPrimary))
            : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildImagesSection(),
                      const SizedBox(height: 16),
                      _buildVideoSection(),
                      const SizedBox(height: 20),
                      ProductTypeSelector(
                        selectedType: _productType,
                        onTypeChanged: (type) =>
                            setState(() => _productType = type),
                      ),
                      const SizedBox(height: 20),
                      ProductBasicInfo(
                        title: _title,
                        description: _description,
                        onTitleChanged: (v) => _title = v,
                        onDescriptionChanged: (v) => _description = v,
                      ),
                      const SizedBox(height: 20),
                      CategoryDropdown(
                        selectedCategoryId: _categoryId,
                        onCategoryChanged: (v) => _categoryId = v,
                      ),
                      const SizedBox(height: 20),
                      LocationField(
                        location: _location,
                        onLocationChanged: (v) => _location = v,
                      ),
                      const SizedBox(height: 20),
                      _buildModeSpecificFields(),
                      const SizedBox(height: 20),
                      SellerContactInfo(
                        phone: _sellerPhone,
                        whatsapp: _sellerWhatsapp,
                        onPhoneChanged: (v) => _sellerPhone = v,
                        onWhatsappChanged: (v) => _sellerWhatsapp = v,
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  // ============================================================
  // 📸 قسم الصور
  // ============================================================
  Widget _buildImagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('صور المنتج',
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('يمكنك إضافة حتى 5 صور (JPG, PNG)',
            style: TextStyle(color: VirooColors.textSecondary, fontSize: 12)),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _images.length < 5 ? _images.length + 1 : _images.length,
            itemBuilder: (context, index) {
              if (index == _images.length && _images.length < 5) {
                return _buildAddImageButton();
              }
              return _buildImageItem(index);
            },
          ),
        ),
        if (_images.isEmpty)
          const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text('يجب إضافة صورة واحدة على الأقل',
                  style: TextStyle(color: VirooColors.warning, fontSize: 12))),
      ],
    );
  }

  Widget _buildAddImageButton() {
    return GestureDetector(
      onTap: _pickMultipleImages,
      child: Container(
        width: 80,
        height: 80,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: VirooColors.glassDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: VirooColors.glassBorder),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate,
                color: VirooColors.textSecondary, size: 28),
            SizedBox(height: 4),
            Text('إضافة صور',
                style:
                    TextStyle(color: VirooColors.textSecondary, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildImageItem(int index) {
    return Stack(children: [
      Container(
          width: 80,
          height: 80,
          margin: const EdgeInsets.only(right: 12),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(_images[index], fit: BoxFit.cover))),
      Positioned(
        top: -4,
        right: 4,
        child: GestureDetector(
          onTap: () => setState(() => _images.removeAt(index)),
          child: const CircleAvatar(
              radius: 12,
              backgroundColor: VirooColors.error,
              child: Icon(Icons.close, size: 12, color: Colors.white)),
        ),
      ),
    ]);
  }

  // ============================================================
  // 🎬 قسم الفيديو
  // ============================================================
  Widget _buildVideoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('فيديو المنتج (اختياري)',
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('أضف فيديو للمنتج (MP4, max 30 ثانية)',
            style: TextStyle(color: VirooColors.textSecondary, fontSize: 12)),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _pickVideo,
          child: Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: VirooColors.glassDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: VirooColors.glassBorder),
            ),
            child: _videoFile == null
                ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.play_circle_outline_rounded,
                          color: VirooColors.textSecondary, size: 40),
                      SizedBox(height: 8),
                      Text(
                        'اضغط لإضافة فيديو (اختياري)',
                        style: TextStyle(
                          color: VirooColors.textSecondary,
                          fontSize: 12,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  )
                : Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: double.infinity,
                          height: 100,
                          color: Colors.black,
                          child: const Center(
                            child: Icon(Icons.play_circle_fill_rounded,
                                color: VirooColors.amberPrimary, size: 50),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () => setState(() => _videoFile = null),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: VirooColors.error,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close_rounded,
                                color: Colors.white, size: 16),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            '🎬 فيديو',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // 📸 اختيار صور متعددة
  // ============================================================
  Future<void> _pickMultipleImages() async {
    final images = await _imagePickerService.pickMultipleImages(context);

    if (images.isNotEmpty) {
      if (images.length == 1) {
        await _imagePickerService.previewImage(
          context: context,
          imageFile: images.first,
          onConfirm: () {
            setState(() {
              _images.addAll(images);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('تم اختيار ${images.length} صورة')),
            );
          },
        );
      } else {
        setState(() {
          _images.addAll(images);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم اختيار ${images.length} صورة')),
        );
      }
    }
  }

  // ============================================================
  // 🎬 اختيار فيديو
  // ============================================================
  Future<void> _pickVideo() async {
    final videoFile = await _imagePickerService.pickVideo(context);
    if (videoFile != null) {
      await _imagePickerService.previewVideo(
        context: context,
        videoFile: videoFile,
        onConfirm: () {
          setState(() {
            _videoFile = videoFile;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✅ تم اختيار الفيديو بنجاح')),
          );
        },
      );
    }
  }

  // ============================================================
  // 🔧 الحقول الخاصة بكل وضع
  // ============================================================
  Widget _buildModeSpecificFields() {
    switch (_productType) {
      case 'farz':
        return FarzFields(
          price: _price,
          originalPrice: _originalPrice,
          hasWarranty: _hasWarranty,
          warrantyMonths: _warrantyMonths,
          priceIncludesTax: _priceIncludesTax,
          onPriceChanged: (v) => _price = v,
          onOriginalPriceChanged: (v) => _originalPrice = v,
          onHasWarrantyChanged: (v) => _hasWarranty = v,
          onWarrantyMonthsChanged: (v) => _warrantyMonths = v,
          onPriceIncludesTaxChanged: (v) => _priceIncludesTax = v,
        );
      case 'gomla':
        return GomlaFields(
          wholesalePrice: _wholesalePrice,
          minQuantity: _minQuantity,
          maxQuantity: _maxQuantity,
          onWholesalePriceChanged: (v) => _wholesalePrice = v,
          onMinQuantityChanged: (v) => _minQuantity = v,
          onMaxQuantityChanged: (v) => _maxQuantity = v,
        );
      case 'tasawok':
        return TasawokFields(
          price: _price,
          condition: _condition,
          defects: _defects,
          reasonForSelling: _reasonForSelling,
          usageDuration: _usageDuration,
          hasOriginalBox: _hasOriginalBox,
          originalReceipt: _originalReceipt,
          onPriceChanged: (v) => _price = v,
          onConditionChanged: (v) => _condition = v,
          onDefectsChanged: (v) => _defects = v,
          onReasonForSellingChanged: (v) => _reasonForSelling = v,
          onUsageDurationChanged: (v) => _usageDuration = v,
          onHasOriginalBoxChanged: (v) => _hasOriginalBox = v,
          onOriginalReceiptChanged: (v) => _originalReceipt = v,
        );
      case 'mosta3mal':
        return Mosta3malFields(
          originalPrice: _originalPrice,
          price: _price,
          discountPercentage: _discountPercentage,
          limitedQuantity: _limitedQuantity,
          expiryDate: _expiryDate,
          flashSaleType: _flashSaleType,
          couponCode: _couponCode,
          onOriginalPriceChanged: (v) => _originalPrice = v,
          onPriceChanged: (v) => _price = v,
          onDiscountPercentageChanged: (v) => _discountPercentage = v,
          onLimitedQuantityChanged: (v) => _limitedQuantity = v,
          onExpiryDateChanged: (v) => _expiryDate = v,
          onFlashSaleTypeChanged: (v) => _flashSaleType = v,
          onCouponCodeChanged: (v) => _couponCode = v,
        );
      default:
        return const SizedBox();
    }
  }

  // ============================================================
  // 🚀 نشر المنتج
  // ============================================================
  Future<void> _submitProduct() async {
    if (!_formKey.currentState!.validate()) return;
    if (_images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إضافة صورة على الأقل')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. رفع الصور
      List<String> imageUrls = [];
      for (int i = 0; i < _images.length; i++) {
        final ref = FirebaseStorage.instance.ref().child(
            'product_images/${DateTime.now().millisecondsSinceEpoch}_$i.jpg');
        await ref.putFile(_images[i]);
        final url = await ref.getDownloadURL();
        imageUrls.add(url);
      }

      // 2. رفع الفيديو (إن وجد)
      String? videoUrl;
      if (_videoFile != null) {
        final ref = FirebaseStorage.instance.ref().child(
            'product_videos/${DateTime.now().millisecondsSinceEpoch}.mp4');
        await ref.putFile(_videoFile!);
        videoUrl = await ref.getDownloadURL();
      }

      // 3. تحديد نوع المنتج
      String firestoreProductType;
      switch (_productType) {
        case 'farz':
          firestoreProductType = 'new';
          break;
        case 'gomla':
          firestoreProductType = 'wholesale';
          break;
        case 'tasawok':
          firestoreProductType = 'used';
          break;
        case 'mosta3mal':
          firestoreProductType = 'outlet';
          break;
        default:
          firestoreProductType = 'new';
      }

      // 4. إضافة تفاصيل إضافية
      Map<String, dynamic> additionalData = {};
      if (_productType == 'gomla') {
        additionalData['minQuantity'] = int.tryParse(_minQuantity) ?? 10;
        additionalData['maxQuantity'] = int.tryParse(_maxQuantity);
        additionalData['wholesalePrice'] =
            double.tryParse(_wholesalePrice) ?? double.tryParse(_price) ?? 0;
      } else if (_productType == 'tasawok') {
        additionalData['condition'] = _condition;
        additionalData['defects'] = _defects;
        additionalData['reasonForSelling'] = _reasonForSelling;
        additionalData['usageDuration'] = _usageDuration;
        additionalData['hasOriginalBox'] = _hasOriginalBox;
        additionalData['originalReceipt'] = _originalReceipt;
      } else if (_productType == 'mosta3mal') {
        additionalData['discountPercentage'] =
            int.tryParse(_discountPercentage);
        additionalData['limitedQuantity'] = int.tryParse(_limitedQuantity);
        additionalData['expiryDate'] = _expiryDate;
        additionalData['flashSaleType'] = _flashSaleType;
        additionalData['couponCode'] = _couponCode;
      } else {
        additionalData['hasWarranty'] = _hasWarranty;
        additionalData['warrantyMonths'] = int.tryParse(_warrantyMonths);
        additionalData['priceIncludesTax'] = _priceIncludesTax;
      }

      final currentUser = AuthService.currentUser;

      final productData = {
        'title': _title,
        'description': _description,
        'price': double.tryParse(_price) ?? 0,
        'originalPrice': double.tryParse(_originalPrice),
        'productType': firestoreProductType,
        'categoryId': _categoryId,
        'images': imageUrls,
        'videoUrl': videoUrl,
        'condition': _condition,
        'location': _location,
        'sellerId': currentUser?.uid ?? '',
        'sellerPhone': _sellerPhone,
        'sellerWhatsapp': _sellerWhatsapp,
        'status': 'approved',
        'views': 0,
        'favorites': 0,
        'createdAt': FieldValue.serverTimestamp(),
        ...additionalData,
      };

      await FirebaseFirestore.instance.collection('products').add(productData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ تم نشر المنتج بنجاح!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ خطأ: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
