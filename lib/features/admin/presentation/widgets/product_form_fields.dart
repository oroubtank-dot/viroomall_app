// lib/features/admin/presentation/widgets/product_form_fields.dart
import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';

class ProductFormFields extends StatefulWidget {
  final VoidCallback? onImageTap;

  const ProductFormFields({
    super.key,
    this.onImageTap,
  });

  @override
  State<ProductFormFields> createState() => ProductFormFieldsState();
}

class ProductFormFieldsState extends State<ProductFormFields> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _originalPriceController = TextEditingController();
  final _descController = TextEditingController();
  final _locationController = TextEditingController();
  final _sellerNameController = TextEditingController();
  final _sellerPhoneController = TextEditingController();

  String _selectedProductType = 'new';
  String _selectedCondition = 'new';
  String _selectedCategory = 'electronics';
  File? _imageFile;

  final List<String> _categories = const [
    'electronics',
    'computers',
    'cameras',
    'video_games',
    'books',
    'clothing',
    'shoes',
    'bags',
    'jewelry',
    'watches',
    'beauty',
    'home_kitchen',
    'furniture',
    'home_decor',
    'tools',
    'toys',
    'baby_products',
    'sports',
    'outdoor',
    'automotive',
    'motorcycle',
    'car_parts',
    'pet_supplies',
    'grocery',
    'beverages',
    'health',
    'medical',
    'musical_instruments',
    'audio',
    'movies',
    'dj_equipment',
    'office_supplies',
    'industrial',
    'arts_crafts',
    'party_supplies',
    'collectibles',
    'software',
    'tickets',
    'gift_cards',
    'adult',
    'other'
  ];

  final List<Map<String, String>> _productTypes = const [
    {'value': 'new', 'label': '🛍️ تسوق (جديد)'},
    {'value': 'wholesale', 'label': '🏪 جملة'},
    {'value': 'used', 'label': '♻️ مستعمل'},
    {'value': 'outlet', 'label': '🔥 فرز إنتاج'},
  ];

  final List<Map<String, String>> _conditions = const [
    {'value': 'new', 'label': 'جديد'},
    {'value': 'like_new', 'label': 'مثل الجديد'},
    {'value': 'good', 'label': 'جيد'},
    {'value': 'acceptable', 'label': 'مقبول'},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _originalPriceController.dispose();
    _descController.dispose();
    _locationController.dispose();
    _sellerNameController.dispose();
    _sellerPhoneController.dispose();
    super.dispose();
  }

  void setImageFile(File file) {
    setState(() => _imageFile = file);
  }

  Map<String, dynamic> getFormData() {
    if (_nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _imageFile == null) {
      return {};
    }

    return {
      'name': _nameController.text.trim(),
      'price': _priceController.text.trim(),
      'originalPrice': _originalPriceController.text.trim(),
      'description': _descController.text.trim(),
      'productType': _selectedProductType,
      'category': _selectedCategory,
      'condition': _selectedCondition,
      'location': _locationController.text.trim(),
      'sellerName': _sellerNameController.text.trim(),
      'sellerPhone': _sellerPhoneController.text.trim(),
      'imageFile': _imageFile,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // صورة المنتج
        const Text(
          'صورة المنتج *',
          style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo'),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: widget.onImageTap,
          child: GlassContainer(
            height: 200,
            width: double.infinity,
            borderRadius: BorderRadius.circular(20),
            child: _imageFile == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo_rounded,
                          size: 50, color: VirooColors.primary),
                      const SizedBox(height: 8),
                      Text('اضغط لإضافة صورة',
                          style: TextStyle(
                              color: VirooColors.textSecondary,
                              fontFamily: 'Cairo')),
                    ],
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.file(_imageFile!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity),
                  ),
          ),
        ),
        const SizedBox(height: 24),

        // اسم المنتج
        _buildSectionTitle('اسم المنتج *'),
        const SizedBox(height: 8),
        _buildTextField(
            controller: _nameController,
            hint: 'مثال: آيفون 15 برو ماكس',
            icon: Icons.shopping_bag_rounded),
        const SizedBox(height: 20),

        // السعر
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('السعر (ج.م) *'),
                  const SizedBox(height: 8),
                  _buildTextField(
                      controller: _priceController,
                      hint: 'مثال: 45999',
                      icon: Icons.money_rounded,
                      keyboardType: TextInputType.number),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('السعر الأصلي'),
                  const SizedBox(height: 8),
                  _buildTextField(
                      controller: _originalPriceController,
                      hint: 'للعروض فقط',
                      icon: Icons.discount_rounded,
                      keyboardType: TextInputType.number),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // نوع المنتج
        _buildSectionTitle('نوع المنتج *'),
        const SizedBox(height: 8),
        _buildDropdown<String>(
          value: _selectedProductType,
          items: _productTypes,
          onChanged: (val) => setState(() => _selectedProductType = val!),
        ),
        const SizedBox(height: 20),

        // القسم
        _buildSectionTitle('القسم *'),
        const SizedBox(height: 8),
        _buildDropdown<String>(
          value: _selectedCategory,
          items: _categories
              .map((c) => {'value': c, 'label': _getCategoryArabic(c)})
              .toList(),
          onChanged: (val) => setState(() => _selectedCategory = val!),
        ),
        const SizedBox(height: 20),

        // حالة المنتج
        _buildSectionTitle('حالة المنتج'),
        const SizedBox(height: 8),
        _buildDropdown<String>(
          value: _selectedCondition,
          items: _conditions,
          onChanged: (val) => setState(() => _selectedCondition = val!),
        ),
        const SizedBox(height: 20),

        // الموقع
        _buildSectionTitle('الموقع'),
        const SizedBox(height: 8),
        _buildTextField(
            controller: _locationController,
            hint: 'مثال: القاهرة',
            icon: Icons.location_on_rounded),
        const SizedBox(height: 20),

        // اسم البائع
        _buildSectionTitle('اسم البائع'),
        const SizedBox(height: 8),
        _buildTextField(
            controller: _sellerNameController,
            hint: 'مثال: متجر الإلكترونيات',
            icon: Icons.store_rounded),
        const SizedBox(height: 20),

        // رقم البائع
        _buildSectionTitle('رقم البائع (واتساب)'),
        const SizedBox(height: 8),
        _buildTextField(
            controller: _sellerPhoneController,
            hint: 'مثال: +201001234567',
            icon: Icons.phone_rounded,
            keyboardType: TextInputType.phone),
        const SizedBox(height: 20),

        // وصف المنتج
        _buildSectionTitle('وصف المنتج'),
        const SizedBox(height: 8),
        _buildTextField(
            controller: _descController,
            hint: 'اكتب وصفاً تفصيلياً للمنتج...',
            icon: Icons.description_rounded,
            maxLines: 4),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title,
        style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            fontFamily: 'Cairo'));
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      borderRadius: BorderRadius.circular(16),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white, fontFamily: 'Cairo'),
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
              color: VirooColors.textSecondary.withValues(alpha: 0.6),
              fontFamily: 'Cairo'),
          prefixIcon: Icon(icon, color: VirooColors.primary, size: 20),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T value,
    required List<Map<String, String>> items,
    required void Function(T?) onChanged,
  }) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      borderRadius: BorderRadius.circular(16),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          dropdownColor: VirooColors.surface,
          icon: Icon(Icons.arrow_drop_down_rounded, color: VirooColors.primary),
          style: const TextStyle(
              color: Colors.white, fontFamily: 'Cairo', fontSize: 16),
          items: items
              .map((item) => DropdownMenuItem<T>(
                    value: item['value'] as T,
                    child: Text(item['label']!,
                        style: const TextStyle(fontFamily: 'Cairo')),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  String _getCategoryArabic(String category) {
    const map = {
      'electronics': '📱 إلكترونيات',
      'computers': '💻 أجهزة الكمبيوتر',
      'cameras': '📷 كاميرات وتصوير',
      'video_games': '🎮 ألعاب الفيديو',
      'books': '📚 كتب',
      'clothing': '👕 ملابس',
      'shoes': '👟 أحذية',
      'bags': '👜 حقائب ومحافظ',
      'jewelry': '💍 مجوهرات',
      'watches': '⌚ ساعات',
      'beauty': '💄 جمال وعناية شخصية',
      'home_kitchen': '🏠 منزل ومطبخ',
      'furniture': '🛋️ أثاث',
      'home_decor': '🛏️ مفروشات وديكور',
      'tools': '🛠️ أدوات وتحسين المنزل',
      'toys': '🧸 ألعاب أطفال',
      'baby_products': '👶 مستلزمات الأطفال',
      'sports': '🏋️ رياضة',
      'outdoor': '🏕️ مستلزمات الرحلات',
      'automotive': '🚗 سيارات وإكسسوارات',
      'motorcycle': '🛵 دراجات نارية',
      'car_parts': '🔧 قطع غيار السيارات',
      'pet_supplies': '🐶 مستلزمات الحيوانات الأليفة',
      'grocery': '🛒 بقالة ومواد غذائية',
      'beverages': '🥤 مشروبات',
      'health': '💪 صحة وتغذية',
      'medical': '🏥 معدات طبية',
      'musical_instruments': '🎵 آلات موسيقية',
      'audio': '🎧 صوتيات وسماعات',
      'movies': '🎬 أفلام ومسلسلات',
      'dj_equipment': '🎸 دي جي ومعدات صوت',
      'office_supplies': '🏢 مستلزمات مكتبية',
      'industrial': '🏭 معدات صناعية وعلمية',
      'arts_crafts': '🎨 فنون وحرف يدوية',
      'party_supplies': '🎉 لوازم الحفلات',
      'collectibles': '🏺 تحف ومقتنيات',
      'software': '💿 برامج كمبيوتر',
      'tickets': '🎟️ تذاكر وفعاليات',
      'gift_cards': '🎁 بطاقات هدايا',
      'adult': '🔞 منتجات للبالغين',
      'other': '📦 منتجات أخرى',
    };
    return map[category] ?? category;
  }
}
