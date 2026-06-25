// lib/features/home/presentation/providers/home_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/product_type.dart';

// 1. قائمة الأوضاع مع بياناتها (من الـ Enum مباشرة)
final shopModesProvider = Provider<List<ProductType>>((ref) {
  return ProductType.values;
});

// 2. الوضع الحالي (الافتراضي: تسوق)
final shopModeProvider =
    StateProvider<ProductType>((ref) => ProductType.shopping);

// 3. اللون الحالي بناءً على الوضع المختار
final modeColorProvider = Provider<Color>((ref) {
  return ref.watch(shopModeProvider).color;
});
