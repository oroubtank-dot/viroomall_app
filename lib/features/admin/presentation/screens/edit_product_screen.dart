// lib/features/admin/presentation/screens/edit_product_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/viroo_background.dart';
import '../../../../core/services/image_picker_service.dart';
import '../../../../core/models/product_model.dart';
import '../../../../core/constants/product_type.dart';
import '../widgets/product_type_selector.dart';
import '../widgets/product_basic_info.dart';
import '../widgets/category_dropdown.dart';
import '../widgets/location_field.dart';
import '../widgets/farz_fields.dart';
import '../widgets/gomla_fields.dart';
import '../widgets/tasawok_fields.dart';
import '../widgets/mosta3mal_fields.dart';
import '../widgets/seller_contact_info.dart';

class EditProductScreen extends ConsumerStatefulWidget {
  final String productId;

  const EditProductScreen({super.key, required this.productId});

  @override
  ConsumerState<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends ConsumerState<EditProductScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePickerService _imagePickerService = ImagePickerService();
  bool _isLoading = true;
  bool _isSaving = false;

  // ========== الحقول الأساسية ==========
  String _productType = 'farz';
  String _title = '';
  String _description = '';
  String _categoryId = '';
  String _location = '';
  List<File> _newImages = [];
  List<String> _existingImages = [];
  File? _videoFile;
  String? _existingVideoUrl;
  bool _deleteVideo = false;

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
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.productId)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        final product = ProductModel.fromFirestore(doc);

        setState(() {
          _title = product.title;
          _description = product.description;
          _price = product.price.toString();
          _originalPrice = product.originalPrice?.toString() ?? '';
          _productType = _getProductType(product.productType);
          _categoryId = product.categoryId;
          _location = product.location;
          _existingImages = product.images;
          _existingVideoUrl = product.videoUrl;
          _condition = product.condition;
          _defects = product.defects ?? '';
          _sellerPhone = product.sellerPhone;
          _sellerWhatsapp = product.sellerWhatsapp;

          if (product.productType == ProductType.wholesale) {
            _wholesalePrice = data['wholesalePrice']?.toString() ?? '';
            _minQuantity = data['minQuantity']?.toString() ?? '10';
            _maxQuantity = data['maxQuantity']?.toString() ?? '100';
          }

          if (product.productType == ProductType.used) {
            _reasonForSelling = data['reasonForSelling'] ?? '';
            _usageDuration = data['usageDuration'] ?? '';
            _hasOriginalBox = data['hasOriginalBox'] ?? false;
            _originalReceipt = data['originalReceipt'] ?? 'no';
          }

          if (product.productType == ProductType.outlet) {
            _discountPercentage = data['discountPercentage']?.toString() ?? '';
            _limitedQuantity = data['limitedQuantity']?.toString() ?? '';
            _expiryDate = (data['expiryDate'] as Timestamp?)?.toDate();
            _flashSaleType = data['flashSaleType'] ?? 'normal';
            _couponCode = data['couponCode'] ?? '';
          }

          if (product.productType == ProductType.shopping) {
            _hasWarranty = data['hasWarranty'] ?? false;
            _warrantyMonths = data['warrantyMonths']?.toString() ?? '12';
            _priceIncludesTax = data['priceIncludesTax'] ?? true;
          }

          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  String _getProductType(ProductType type) {
    switch (type) {
      case ProductType.shopping:
        return 'farz';
      case ProductType.wholesale:
        return 'gomla';
      case ProductType.used:
        return 'tasawok';
      case ProductType.outlet:
        return 'mosta3mal';
    }
  }

  Future<void> _pickMultipleImages() async {
    final images = await _imagePickerService.pickMultipleImages(context);
    if (images.isNotEmpty) {
      setState(() {
        _newImages.addAll(images);
      });
    }
  }

  Future<void> _pickVideo() async {
    final videoFile = await _imagePickerService.pickVideo(context);
    if (videoFile != null) {
      setState(() {
        _videoFile = videoFile;
        _deleteVideo = false;
      });
    }
  }

  Future<void> _removeExistingImage(int index) async {
    setState(() {
      _existingImages.removeAt(index);
    });
  }

  Future<void> _removeNewImage(int index) async {
    setState(() {
      _newImages.removeAt(index);
    });
  }

  Future<void> _deleteProduct() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: VirooColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          '🗑️ حذف المنتج',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'هل أنت متأكد من حذف هذا المنتج؟\nلا يمكن التراجع عن هذا الإجراء.',
          style: TextStyle(color: Colors.white70, fontFamily: 'Cairo'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'إلغاء',
              style: TextStyle(
                  color: VirooColors.textSecondary, fontFamily: 'Cairo'),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: VirooColors.error),
            child: const Text(
              'حذف',
              style: TextStyle(color: Colors.white, fontFamily: 'Cairo'),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isSaving = true);
      try {
        await FirebaseFirestore.instance
            .collection('products')
            .doc(widget.productId)
            .delete();

        for (var imageUrl in _existingImages) {
          try {
            final ref = FirebaseStorage.instance.refFromURL(imageUrl);
            await ref.delete();
          } catch (_) {}
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ تم حذف المنتج بنجاح!'),
              backgroundColor: VirooColors.success,
            ),
          );
          Navigator.pop(context);
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
        if (mounted) setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;
    if (_existingImages.isEmpty && _newImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إضافة صورة على الأقل')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      List<String> allImages = List.from(_existingImages);

      if (_newImages.isNotEmpty) {
        for (int i = 0; i < _newImages.length; i++) {
          final ref = FirebaseStorage.instance.ref().child(
              'product_images/${DateTime.now().millisecondsSinceEpoch}_$i.jpg');
          await ref.putFile(_newImages[i]);
          final url = await ref.getDownloadURL();
          allImages.add(url);
        }
      }

      String? videoUrl = _existingVideoUrl;
      if (_videoFile != null) {
        final ref = FirebaseStorage.instance.ref().child(
            'product_videos/${DateTime.now().millisecondsSinceEpoch}.mp4');
        await ref.putFile(_videoFile!);
        videoUrl = await ref.getDownloadURL();
      }
      if (_deleteVideo) {
        videoUrl = null;
      }

      final firestoreProductType = _getFirestoreType(_productType);

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

      final productData = {
        'title': _title,
        'description': _description,
        'price': double.tryParse(_price) ?? 0,
        'originalPrice': double.tryParse(_originalPrice),
        'productType': firestoreProductType,
        'categoryId': _categoryId,
        'images': allImages,
        'videoUrl': videoUrl,
        'condition': _condition,
        'defects': _defects,
        'location': _location,
        'sellerPhone': _sellerPhone,
        'sellerWhatsapp': _sellerWhatsapp,
        'updatedAt': FieldValue.serverTimestamp(),
        ...additionalData,
      };

      await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.productId)
          .update(productData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ تم تحديث المنتج بنجاح!')),
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
      if (mounted) setState(() => _isSaving = false);
    }
  }

  String _getFirestoreType(String type) {
    switch (type) {
      case 'farz':
        return ProductType.shopping.firestoreValue;
      case 'gomla':
        return ProductType.wholesale.firestoreValue;
      case 'tasawok':
        return ProductType.used.firestoreValue;
      case 'mosta3mal':
        return ProductType.outlet.firestoreValue;
      default:
        return ProductType.shopping.firestoreValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: VirooColors.background,
        body: Center(
            child: CircularProgressIndicator(color: VirooColors.amberPrimary)),
      );
    }

    return Scaffold(
      backgroundColor: VirooColors.background,
      appBar: AppBar(
        title: const Text('✏️ تعديل المنتج',
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
          IconButton(
            icon: const Icon(Icons.delete_rounded, color: VirooColors.error),
            onPressed: _deleteProduct,
          ),
          TextButton(
            onPressed: _isSaving ? null : _saveProduct,
            child: Text(
              _isSaving ? 'جاري...' : 'حفظ',
              style: TextStyle(
                color: _isSaving ? Colors.grey : VirooColors.amberPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: VirooBackground(
        showOrbs: true,
        child: _isSaving
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

  Widget _buildImagesSection() {
    final totalImages = _existingImages.length + _newImages.length;
    final canAddMore = totalImages < 5;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('صور المنتج',
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('اضغط على الصورة لحذفها',
            style: TextStyle(color: VirooColors.textSecondary, fontSize: 12)),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: canAddMore ? totalImages + 1 : totalImages,
            itemBuilder: (context, index) {
              if (index == totalImages && canAddMore) {
                return _buildAddImageButton();
              }
              return _buildImageItem(index);
            },
          ),
        ),
        if (totalImages == 0)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text('يجب إضافة صورة واحدة على الأقل',
                style: TextStyle(color: VirooColors.warning, fontSize: 12)),
          ),
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
            Text('إضافة',
                style:
                    TextStyle(color: VirooColors.textSecondary, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildImageItem(int index) {
    final isNew = index >= _existingImages.length;

    return Stack(children: [
      Container(
        width: 80,
        height: 80,
        margin: const EdgeInsets.only(right: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: isNew
              ? Image.file(_newImages[index - _existingImages.length],
                  fit: BoxFit.cover)
              : Image.network(_existingImages[index], fit: BoxFit.cover),
        ),
      ),
      Positioned(
        top: -4,
        right: 4,
        child: GestureDetector(
          onTap: () {
            if (isNew) {
              _removeNewImage(index - _existingImages.length);
            } else {
              _removeExistingImage(index);
            }
          },
          child: const CircleAvatar(
            radius: 12,
            backgroundColor: VirooColors.error,
            child: Icon(Icons.close, size: 12, color: Colors.white),
          ),
        ),
      ),
    ]);
  }

  Widget _buildVideoSection() {
    final hasVideo =
        _videoFile != null || (_existingVideoUrl != null && !_deleteVideo);

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
              border: Border.all(
                  color:
                      hasVideo ? VirooColors.success : VirooColors.glassBorder),
            ),
            child: hasVideo
                ? Stack(
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
                          onTap: () {
                            setState(() {
                              _videoFile = null;
                              _deleteVideo = true;
                            });
                          },
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
                  )
                : const Column(
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
                  ),
          ),
        ),
      ],
    );
  }

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
}
