// lib/features/admin/presentation/screens/add_product_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';
import '../../../../core/widgets/viroo_background.dart';
import '../widgets/image_picker_bottom_sheet.dart';
import '../widgets/product_form_fields.dart';
import '../providers/add_product_provider.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  final _formKey = GlobalKey<ProductFormFieldsState>();

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(addProductLoadingProvider);
    final themeColor = VirooColors.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "إضافة منتج جديد",
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: VirooBackground(
        showOrbs: true,
        themeColor: themeColor,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: ProductFormFields(
            key: _formKey,
            onImageTap: isLoading ? null : () => _pickImage(),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              VirooColors.background.withOpacity(0.9),
            ],
          ),
        ),
        child: GlowingButton(
          onPressed: isLoading ? () {} : () => _saveProduct(),
          text: isLoading ? 'جاري النشر...' : '🚀 نشر المنتج الآن',
          isLoading: isLoading,
          backgroundColor: themeColor,
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final imageFile = await showImagePickerBottomSheet(context);
    if (imageFile != null) {
      _formKey.currentState?.setImageFile(imageFile);
    }
  }

  Future<void> _saveProduct() async {
    final formData = _formKey.currentState?.getFormData();
    if (formData == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('من فضلك أكمل جميع الحقول المطلوبة',
                style: TextStyle(fontFamily: 'Cairo')),
            backgroundColor: VirooColors.error,
          ),
        );
      }
      return;
    }

    final success = await ref
        .read(addProductNotifierProvider.notifier)
        .saveProduct(formData);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ تم نشر المنتج بنجاح!',
              style: TextStyle(fontFamily: 'Cairo', color: Colors.white)),
          backgroundColor: VirooColors.success,
          duration: Duration(seconds: 2),
        ),
      );

      _showShareReminder(formData['name'] as String);
    } else if (mounted) {
      final error = ref.read(addProductErrorProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? '❌ حدث خطأ ما',
              style: const TextStyle(fontFamily: 'Cairo')),
          backgroundColor: VirooColors.error,
        ),
      );
    }
  }

  void _showShareReminder(String productTitle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: VirooColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.share_rounded, color: VirooColors.primary),
            const SizedBox(width: 10),
            const Text(
              '🎉 منتجك اتنشر!',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          'شارك "$productTitle" مع أصحابك وزود مبيعاتك! 📈',
          style: TextStyle(
            color: VirooColors.textSecondary,
            fontFamily: 'Cairo',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(
              'لاحقاً',
              style: TextStyle(
                color: VirooColors.textSecondary,
                fontFamily: 'Cairo',
              ),
            ),
          ),
          GlowingButton(
            onPressed: () {
              Navigator.pop(context);
              final message = '''
🛍️ *$productTitle*
📱 شوف المنتج ده على VirooMall!

حمل التطبيق من هنا: https://viroomall.eg/app
''';
              Share.share(message, subject: productTitle);
              Navigator.pop(context);
            },
            text: 'مشاركة دلوقتي',
            icon: Icons.share_rounded,
            width: 140,
            height: 40,
          ),
        ],
      ),
    );
  }
}
