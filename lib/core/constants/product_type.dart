// lib/core/constants/product_type.dart
import 'package:flutter/material.dart';

/// =============================================
/// النوع الموحد للمنتج - ProductType Enum
/// المصدر الوحيد للحقيقة (Single Source of Truth)
/// =============================================

enum ProductType {
  /// منتجات جديدة - تسوق عادي
  shopping(
    firestoreValue: 'new',
    arabicName: 'تسوق',
    icon: '🛍️',
    color: Color(0xFFFF6B35), // برتقالي
  ),

  /// منتجات الجملة
  wholesale(
    firestoreValue: 'wholesale',
    arabicName: 'جملة',
    icon: '🏪',
    color: Color(0xFF2196F3), // أزرق
  ),

  /// منتجات مستعملة
  used(
    firestoreValue: 'used',
    arabicName: 'مستعمل',
    icon: '♻️',
    color: Color(0xFF4CAF50), // أخضر
  ),

  /// فرز إنتاج وتصفية - تخفيضات
  outlet(
    firestoreValue: 'outlet',
    arabicName: 'فرز إنتاج وتصفية',
    icon: '🔥',
    color: Color(0xFFF44336), // أحمر
  );

  const ProductType({
    required this.firestoreValue,
    required this.arabicName,
    required this.icon,
    required this.color,
  });

  /// القيمة المخزنة في Firestore
  final String firestoreValue;

  /// الاسم المعروض بالعربي
  final String arabicName;

  /// الأيقونة (Emoji)
  final String icon;

  /// اللون المميز
  final Color color;

  /// تحويل من القيمة المخزنة في Firestore إلى enum
  static ProductType fromFirestore(String? value) {
    if (value == null) return ProductType.shopping;
    return ProductType.values.firstWhere(
      (type) => type.firestoreValue == value,
      orElse: () => ProductType.shopping,
    );
  }

  /// تحويل من اسم الوضع القديم (farz, gomla, mosta3mal, tasawok) إلى enum
  static ProductType fromModeName(String? modeName) {
    if (modeName == null) return ProductType.shopping;
    switch (modeName) {
      case 'farz':
      case 'shopping':
        return ProductType.shopping;
      case 'gomla':
      case 'wholesale':
        return ProductType.wholesale;
      case 'mosta3mal':
      case 'used':
        return ProductType.used;
      case 'tasawok':
      case 'outlet':
        return ProductType.outlet;
      default:
        return ProductType.shopping;
    }
  }

  /// هل هذا النوع هو التسوق العادي؟
  bool get isShopping => this == ProductType.shopping;

  /// هل هذا النوع هو الجملة؟
  bool get isWholesale => this == ProductType.wholesale;

  /// هل هذا النوع هو المستعمل؟
  bool get isUsed => this == ProductType.used;

  /// هل هذا النوع هو فرز الإنتاج؟
  bool get isOutlet => this == ProductType.outlet;
}
