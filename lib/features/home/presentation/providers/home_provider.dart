// lib/features/home/presentation/providers/home_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. تعريف الأوضاع
enum ShopMode { shopping, wholesale, used, outlet }

// 2. قائمة الأوضاع مع بياناتها
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

// 3. المخزن اللي بيعرفنا إحنا في أنهي وضع حالياً (الافتراضي: تسوق)
final shopModeProvider = StateProvider<ShopMode>((ref) => ShopMode.shopping);

// 4. اللون الحالي بناءً على الوضع المختار
final modeColorProvider = Provider<Color>((ref) {
  final mode = ref.watch(shopModeProvider);
  switch (mode) {
    case ShopMode.shopping:
      return const Color(0xFFFF6B35); // برتقالي
    case ShopMode.wholesale:
      return const Color(0xFF2196F3); // أزرق
    case ShopMode.used:
      return const Color(0xFF4CAF50); // أخضر
    case ShopMode.outlet:
      return const Color(0xFFF44336); // أحمر
  }
});
