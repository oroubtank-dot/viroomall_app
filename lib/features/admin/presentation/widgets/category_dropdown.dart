// lib/features/admin/presentation/widgets/category_dropdown.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class CategoryDropdown extends StatelessWidget {
  final String selectedCategoryId;
  final Function(String) onCategoryChanged;

  const CategoryDropdown({
    super.key,
    required this.selectedCategoryId,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    final categories = _getCategories();
    final grouped = _groupCategories(categories);

    List<DropdownMenuItem<String>> items = [];

    final groupOrder = [
      'electronics',
      'fashion',
      'home',
      'beauty',
      'sports',
      'books',
      'kids',
      'car',
      'pets',
      'other'
    ];
    final groupNames = {
      'electronics': '📱 الإلكترونيات',
      'fashion': '👔 الموضة',
      'home': '🏠 المنزل والمطبخ',
      'beauty': '💄 الجمال والعناية',
      'sports': '⚽ الرياضة',
      'books': '📚 الكتب والقرطاسية',
      'kids': '🧸 الأطفال',
      'car': '🚗 السيارات',
      'pets': '🐶 الحيوانات الأليفة',
      'other': '📦 أخرى',
    };

    for (var group in groupOrder) {
      if (grouped.containsKey(group)) {
        items.add(
          DropdownMenuItem<String>(
            value: null,
            enabled: false,
            child: Text(
              groupNames[group]!,
              style: const TextStyle(
                color: VirooColors.amberPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        );
        for (var cat in grouped[group]!) {
          items.add(
            DropdownMenuItem<String>(
              value: cat['id'],
              child: Row(
                children: [
                  Text(cat['icon']!, style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      cat['name']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الفئة',
          style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo'),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: VirooColors.glassDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: VirooColors.glassBorder),
          ),
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            hint: const Text(
              'اختر فئة للمنتج',
              style: TextStyle(
                  color: VirooColors.textSecondary, fontFamily: 'Cairo'),
            ),
            value: selectedCategoryId.isEmpty ? null : selectedCategoryId,
            items: items,
            onChanged: (value) => onCategoryChanged(value ?? ''),
            validator: (value) =>
                value == null || value.isEmpty ? 'الرجاء اختيار الفئة' : null,
            dropdownColor: VirooColors.surface,
            style: const TextStyle(color: Colors.white, fontFamily: 'Cairo'),
            icon: const Icon(Icons.arrow_drop_down,
                color: VirooColors.amberPrimary),
          ),
        ),
      ],
    );
  }

  List<Map<String, String>> _getCategories() {
    return [
      // 📱 إلكترونيات
      {
        'id': 'mobile',
        'name': '📱 موبايلات وتابلت',
        'icon': '📱',
        'group': 'electronics'
      },
      {
        'id': 'laptop',
        'name': '💻 لاب توب وكومبيوتر',
        'icon': '💻',
        'group': 'electronics'
      },
      {
        'id': 'tablet',
        'name': '📟 أجهزة لوحية',
        'icon': '📟',
        'group': 'electronics'
      },
      {
        'id': 'mobile_accessories',
        'name': '🎧 إكسسوارات موبايل',
        'icon': '🎧',
        'group': 'electronics'
      },
      {
        'id': 'headphones',
        'name': '🎵 سماعات',
        'icon': '🎵',
        'group': 'electronics'
      },
      {
        'id': 'smart_watch',
        'name': '⌚ ساعات ذكية',
        'icon': '⌚',
        'group': 'electronics'
      },
      {
        'id': 'gaming',
        'name': '🎮 ألعاب فيديو',
        'icon': '🎮',
        'group': 'electronics'
      },
      {
        'id': 'gaming_accessories',
        'name': '🕹️ إكسسوارات الألعاب',
        'icon': '🕹️',
        'group': 'electronics'
      },
      {
        'id': 'tv',
        'name': '📺 تلفزيونات',
        'icon': '📺',
        'group': 'electronics'
      },
      {
        'id': 'camera',
        'name': '📷 كاميرات وتصوير',
        'icon': '📷',
        'group': 'electronics'
      },
      {
        'id': 'audio',
        'name': '🔊 أنظمة صوتية',
        'icon': '🔊',
        'group': 'electronics'
      },
      {
        'id': 'drone',
        'name': '🚁 طائرات درون',
        'icon': '🚁',
        'group': 'electronics'
      },
      {
        'id': 'vr',
        'name': '🥽 واقع افتراضي',
        'icon': '🥽',
        'group': 'electronics'
      },

      // 👔 موضة
      {
        'id': 'men_fashion',
        'name': '👔 ملابس رجالية',
        'icon': '👔',
        'group': 'fashion'
      },
      {
        'id': 'women_fashion',
        'name': '👗 ملابس حريمي',
        'icon': '👗',
        'group': 'fashion'
      },
      {
        'id': 'kids_fashion',
        'name': '🧒 ملابس أطفال',
        'icon': '🧒',
        'group': 'fashion'
      },
      {
        'id': 'baby_fashion',
        'name': '🍼 ملابس أطفال رضع',
        'icon': '🍼',
        'group': 'fashion'
      },
      {'id': 'shoes', 'name': '👟 أحذية', 'icon': '👟', 'group': 'fashion'},
      {'id': 'watches', 'name': '⌚ ساعات', 'icon': '⌚', 'group': 'fashion'},
      {
        'id': 'accessories',
        'name': '💍 إكسسوارات',
        'icon': '💍',
        'group': 'fashion'
      },
      {'id': 'bags', 'name': '👜 شنط وحقائب', 'icon': '👜', 'group': 'fashion'},
      {'id': 'perfumes', 'name': '🌸 عطور', 'icon': '🌸', 'group': 'fashion'},
      {
        'id': 'sunglasses',
        'name': '🕶️ نظارات شمسية',
        'icon': '🕶️',
        'group': 'fashion'
      },
      {'id': 'jewelry', 'name': '💎 مجوهرات', 'icon': '💎', 'group': 'fashion'},

      // 🏠 منزل ومطبخ
      {'id': 'furniture', 'name': '🛋️ أثاث', 'icon': '🛋️', 'group': 'home'},
      {
        'id': 'appliances',
        'name': '🔌 أجهزة منزلية',
        'icon': '🔌',
        'group': 'home'
      },
      {'id': 'kitchen', 'name': '🍳 أدوات مطبخ', 'icon': '🍳', 'group': 'home'},
      {
        'id': 'kitchen_appliances',
        'name': '🍕 أجهزة مطبخ',
        'icon': '🍕',
        'group': 'home'
      },
      {'id': 'bedding', 'name': '🛏️ مفروشات', 'icon': '🛏️', 'group': 'home'},
      {'id': 'decoration', 'name': '🎨 ديكور', 'icon': '🎨', 'group': 'home'},
      {'id': 'lighting', 'name': '💡 إضاءة', 'icon': '💡', 'group': 'home'},
      {
        'id': 'storage',
        'name': '📦 تخزين وتنظيم',
        'icon': '📦',
        'group': 'home'
      },
      {
        'id': 'cleaning',
        'name': '🧹 أدوات تنظيف',
        'icon': '🧹',
        'group': 'home'
      },
      {'id': 'garden', 'name': '🌱 حديقة', 'icon': '🌱', 'group': 'home'},
      {'id': 'tools', 'name': '🔧 أدوات', 'icon': '🔧', 'group': 'home'},

      // 💄 جمال وعناية
      {
        'id': 'skin_care',
        'name': '🧴 عناية بالبشرة',
        'icon': '🧴',
        'group': 'beauty'
      },
      {
        'id': 'hair_care',
        'name': '💇 عناية بالشعر',
        'icon': '💇',
        'group': 'beauty'
      },
      {'id': 'makeup', 'name': '💄 مكياج', 'icon': '💄', 'group': 'beauty'},
      {'id': 'fragrances', 'name': '🌸 عطور', 'icon': '🌸', 'group': 'beauty'},
      {
        'id': 'medical',
        'name': '🩺 أجهزة طبية',
        'icon': '🩺',
        'group': 'beauty'
      },
      {
        'id': 'nail_care',
        'name': '💅 عناية بالأظافر',
        'icon': '💅',
        'group': 'beauty'
      },
      {
        'id': 'men_grooming',
        'name': '🧔 أدوات حلاقة',
        'icon': '🧔',
        'group': 'beauty'
      },
      {
        'id': 'natural_products',
        'name': '🌿 منتجات طبيعية',
        'icon': '🌿',
        'group': 'beauty'
      },

      // ⚽ رياضة
      {
        'id': 'sportswear',
        'name': '👕 ملابس رياضية',
        'icon': '👕',
        'group': 'sports'
      },
      {
        'id': 'sports_shoes',
        'name': '👟 أحذية رياضية',
        'icon': '👟',
        'group': 'sports'
      },
      {
        'id': 'fitness',
        'name': '🏋️ أجهزة رياضية',
        'icon': '🏋️',
        'group': 'sports'
      },
      {'id': 'camping', 'name': '🏕️ تخييم', 'icon': '🏕️', 'group': 'sports'},
      {'id': 'bikes', 'name': '🚲 دراجات', 'icon': '🚲', 'group': 'sports'},
      {
        'id': 'swimming',
        'name': '🏊 مستلزمات سباحة',
        'icon': '🏊',
        'group': 'sports'
      },
      {'id': 'fishing', 'name': '🎣 صيد', 'icon': '🎣', 'group': 'sports'},

      // 📚 كتب
      {
        'id': 'arabic_books',
        'name': '📖 كتب عربية',
        'icon': '📖',
        'group': 'books'
      },
      {
        'id': 'english_books',
        'name': '📚 كتب أجنبية',
        'icon': '📚',
        'group': 'books'
      },
      {
        'id': 'kids_books',
        'name': '📕 كتب أطفال',
        'icon': '📕',
        'group': 'books'
      },
      {
        'id': 'stationery',
        'name': '✏️ قرطاسية',
        'icon': '✏️',
        'group': 'books'
      },
      {'id': 'magazines', 'name': '📰 مجلات', 'icon': '📰', 'group': 'books'},

      // 🧸 أطفال
      {'id': 'toys', 'name': '🧸 ألعاب', 'icon': '🧸', 'group': 'kids'},
      {
        'id': 'kids_clothes',
        'name': '👕 ملابس أطفال',
        'icon': '👕',
        'group': 'kids'
      },
      {
        'id': 'baby_care',
        'name': '🍼 مستلزمات أطفال',
        'icon': '🍼',
        'group': 'kids'
      },
      {
        'id': 'strollers',
        'name': '🚼 عربيات أطفال',
        'icon': '🚼',
        'group': 'kids'
      },
      {
        'id': 'educational',
        'name': '📚 ألعاب تعليمية',
        'icon': '📚',
        'group': 'kids'
      },
      {
        'id': 'kids_room',
        'name': '🛏️ غرفة أطفال',
        'icon': '🛏️',
        'group': 'kids'
      },

      // 🚗 سيارات
      {'id': 'car_parts', 'name': '🔧 قطع غيار', 'icon': '🔧', 'group': 'car'},
      {
        'id': 'car_accessories',
        'name': '🚗 إكسسوارات سيارة',
        'icon': '🚗',
        'group': 'car'
      },
      {'id': 'car_decor', 'name': '✨ زينة سيارة', 'icon': '✨', 'group': 'car'},
      {
        'id': 'car_electronics',
        'name': '📡 إلكترونيات سيارة',
        'icon': '📡',
        'group': 'car'
      },

      // 🐶 حيوانات
      {
        'id': 'pet_food',
        'name': '🍖 طعام حيوانات',
        'icon': '🍖',
        'group': 'pets'
      },
      {
        'id': 'pet_supplies',
        'name': '🐾 مستلزمات حيوانات',
        'icon': '🐾',
        'group': 'pets'
      },
      {
        'id': 'pet_toys',
        'name': '🧸 ألعاب حيوانات',
        'icon': '🧸',
        'group': 'pets'
      },
      {
        'id': 'pet_health',
        'name': '🏥 عناية صحية',
        'icon': '🏥',
        'group': 'pets'
      },

      // 📦 أخرى
      {'id': 'other', 'name': '📦 أخرى', 'icon': '📦', 'group': 'other'},
    ];
  }

  Map<String, List<Map<String, String>>> _groupCategories(
      List<Map<String, String>> categories) {
    final Map<String, List<Map<String, String>>> grouped = {};
    for (var cat in categories) {
      final group = cat['group']!;
      if (!grouped.containsKey(group)) {
        grouped[group] = [];
      }
      grouped[group]!.add(cat);
    }
    return grouped;
  }
}
