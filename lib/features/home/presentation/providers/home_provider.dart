import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// أنواع أوضاع التصفح
enum ShopMode {
  shopping, // 🛍️ تسوق
  wholesale, // 🏪 جملة
  used, // ♻️ مستعمل
  outlet, // 🔥 فرز إنتاج
}

// Provider لحالة الوضع المختار
final shopModeProvider = StateProvider<ShopMode>((ref) => ShopMode.shopping);

// Provider لقائمة الأوضاع
final shopModesProvider = Provider<List<Map<String, dynamic>>>((ref) {
  return [
    {
      'mode': ShopMode.shopping,
      'title': 'تسوق',
      'icon': '🛍️',
      'color': const Color(0xFFFF6B35),
    },
    {
      'mode': ShopMode.wholesale,
      'title': 'جملة',
      'icon': '🏪',
      'color': const Color(0xFF2196F3),
    },
    {
      'mode': ShopMode.used,
      'title': 'مستعمل',
      'icon': '♻️',
      'color': const Color(0xFF4CAF50),
    },
    {
      'mode': ShopMode.outlet,
      'title': 'فرز',
      'icon': '🔥',
      'color': const Color(0xFFF44336),
    },
  ];
});
