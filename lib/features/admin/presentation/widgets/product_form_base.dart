// lib/features/admin/presentation/widgets/product_form_base.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';

/// =============================================
/// 🏗️ ProductFormBase - الحقول المشتركة + 41+ قسم
/// =============================================
class ProductFormBase {
  static final nameController = TextEditingController();
  static final priceController = TextEditingController();
  static final originalPriceController = TextEditingController();
  static final descController = TextEditingController();
  static final locationController = TextEditingController();
  static final sellerNameController = TextEditingController();
  static final sellerPhoneController = TextEditingController();
  static final minQuantityController = TextEditingController();
  static final defectsController = TextEditingController();
  static final outletReasonController = TextEditingController();
  static final outletQuantityController = TextEditingController();

  static void disposeAll() {
    nameController.dispose();
    priceController.dispose();
    originalPriceController.dispose();
    descController.dispose();
    locationController.dispose();
    sellerNameController.dispose();
    sellerPhoneController.dispose();
    minQuantityController.dispose();
    defectsController.dispose();
    outletReasonController.dispose();
    outletQuantityController.dispose();
  }

  /// 📂 41+ قسم من أمازون والمتاجر الكبرى
  static const List<Map<String, String>> categories = [
    // ===== إلكترونيات =====
    {'value': 'electronics_mobiles', 'label': '📱 موبايلات وتابلت'},
    {'value': 'electronics_laptops', 'label': '💻 لابتوب وكمبيوتر'},
    {'value': 'electronics_accessories', 'label': '🔌 إكسسوارات إلكترونية'},
    {'value': 'electronics_screens', 'label': '🖥️ شاشات وتلفزيونات'},
    {'value': 'electronics_audio', 'label': '🎧 سماعات وصوتيات'},
    {'value': 'electronics_gaming', 'label': '🎮 ألعاب فيديو واكسسوارات'},
    {'value': 'electronics_cameras', 'label': '📷 كاميرات وتصوير'},
    {'value': 'electronics_smart_home', 'label': '🏠 أجهزة منزلية ذكية'},
    {'value': 'electronics_wearables', 'label': '⌚ أجهزة قابلة للارتداء'},
    {'value': 'electronics_printers', 'label': '🖨️ طابعات وأحبار'},
    {'value': 'electronics_networking', 'label': '🌐 شبكات وراوترات'},
    {'value': 'electronics_storage', 'label': '💾 تخزين وفلاشات'},
    {'value': 'electronics_other', 'label': '🔧 إلكترونيات أخرى'},

    // ===== ملابس وأزياء =====
    {'value': 'fashion_men', 'label': '👔 ملابس رجالي'},
    {'value': 'fashion_women', 'label': '👗 ملابس حريمي'},
    {'value': 'fashion_kids', 'label': '👶 ملابس أطفال'},
    {'value': 'fashion_shoes', 'label': '👟 أحذية'},
    {'value': 'fashion_bags', 'label': '👜 حقائب ومحافظ'},
    {'value': 'fashion_accessories', 'label': '💍 إكسسوارات ومجوهرات'},
    {'value': 'fashion_watches', 'label': '⌚ ساعات'},
    {'value': 'fashion_sports', 'label': '🏋️ ملابس رياضية'},

    // ===== منزل ومطبخ =====
    {'value': 'home_kitchen_appliances', 'label': '🍳 أجهزة مطبخ'},
    {'value': 'home_furniture', 'label': '🛋️ أثاث'},
    {'value': 'home_decor', 'label': '🖼️ ديكورات وتحف'},
    {'value': 'home_bedding', 'label': '🛏️ مفروشات'},
    {'value': 'home_lighting', 'label': '💡 إضاءة'},
    {'value': 'home_tools', 'label': '🛠️ أدوات منزلية'},
    {'value': 'home_garden', 'label': '🌿 أدوات حديقة'},
    {'value': 'home_cleaning', 'label': '🧹 تنظيف وعناية منزلية'},
    {'value': 'home_bathroom', 'label': '🚿 مستلزمات حمام'},

    // ===== جمال وعناية =====
    {'value': 'beauty_skincare', 'label': '✨ عناية بالبشرة'},
    {'value': 'beauty_hair', 'label': '💇‍♀️ عناية بالشعر'},
    {'value': 'beauty_makeup', 'label': '💄 مكياج'},
    {'value': 'beauty_perfumes', 'label': '🌸 عطور'},
    {'value': 'beauty_men', 'label': '🧔 عناية رجالية'},

    // ===== صحة ورياضة =====
    {'value': 'health_supplements', 'label': '💊 مكملات غذائية'},
    {'value': 'health_medical', 'label': '🏥 معدات طبية'},
    {'value': 'sports_equipment', 'label': '⚽ معدات رياضية'},
    {'value': 'sports_fitness', 'label': '💪 لياقة وتمارين'},

    // ===== أطفال =====
    {'value': 'baby_food', 'label': '🍼 طعام رضع'},
    {'value': 'baby_toys', 'label': '🧸 ألعاب أطفال'},
    {'value': 'baby_strollers', 'label': '👶 عربيات ومقاعد'},

    // ===== سيارات =====
    {'value': 'auto_parts', 'label': '🔧 قطع غيار'},
    {'value': 'auto_accessories', 'label': '🚗 إكسسوارات سيارات'},
    {'value': 'auto_tools', 'label': '🛢️ زيوت ومواد عناية'},

    // ===== كتب ومكتب =====
    {'value': 'books_arabic', 'label': '📚 كتب عربية'},
    {'value': 'books_english', 'label': '📖 كتب إنجليزية'},
    {'value': 'office_supplies', 'label': '🏢 مستلزمات مكتبية'},
    {'value': 'arts_crafts', 'label': '🎨 فنون وحرف يدوية'},

    // ===== حيوانات أليفة =====
    {'value': 'pets_food', 'label': '🐶 طعام حيوانات'},
    {'value': 'pets_accessories', 'label': '🐱 إكسسوارات حيوانات'},

    // ===== بقالة =====
    {'value': 'grocery_drinks', 'label': '🥤 مشروبات'},
    {'value': 'grocery_snacks', 'label': '🍿 مسليات وحلويات'},
    {'value': 'grocery_canned', 'label': '🥫 معلبات'},

    // ===== خدمات =====
    {'value': 'services_digital', 'label': '💳 خدمات رقمية'},
    {'value': 'services_gifts', 'label': '🎁 بطاقات هدايا'},
    {'value': 'services_tickets', 'label': '🎟️ تذاكر ومناسبات'},

    // ===== أخرى =====
    {'value': 'other_products', 'label': '📦 منتجات أخرى'},
  ];

  static Widget buildCategoryDropdown(
      String selectedCategory, Function(String) onChanged) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      borderRadius: BorderRadius.circular(16),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedCategory,
          isExpanded: true,
          dropdownColor: VirooColors.surface,
          icon: const Icon(Icons.arrow_drop_down_rounded,
              color: VirooColors.primary),
          style: const TextStyle(
              color: Colors.white, fontFamily: 'Cairo', fontSize: 14),
          menuMaxHeight: 400,
          items: categories.map((c) {
            return DropdownMenuItem<String>(
              value: c['value'],
              child: Text(c['label']!,
                  style: const TextStyle(fontFamily: 'Cairo', fontSize: 13)),
            );
          }).toList(),
          onChanged: (val) => onChanged(val!),
        ),
      ),
    );
  }

  static Widget buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool required = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (required)
          Row(
            children: [
              Text(
                hint,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Cairo'),
              ),
              const SizedBox(width: 4),
              const Text('*',
                  style: TextStyle(
                      color: VirooColors.error,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        if (!required) const SizedBox.shrink(),
        if (required) const SizedBox(height: 8),
        GlassContainer(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          borderRadius: BorderRadius.circular(16),
          child: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white, fontFamily: 'Cairo'),
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: required ? '' : hint,
              hintStyle: TextStyle(
                  color: VirooColors.textSecondary.withAlpha(150),
                  fontFamily: 'Cairo'),
              prefixIcon: Icon(icon, color: VirooColors.primary, size: 20),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
