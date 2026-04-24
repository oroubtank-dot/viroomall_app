// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

/// =============================================
/// ألوان VirooMall الرسمية
/// =============================================
class VirooColors {
  // =============================================
  // Deep Space Theme (الخلفيات الأساسية)
  // =============================================

  /// الخلفية الرئيسية - بنفسجي غامق جداً
  static const Color background = Color(0xFF1A0B4A);

  /// الخلفية الثانوية - بنفسجي متوسط
  static const Color secondary = Color(0xFF2D1B69);

  /// خلفية الأسطح - بنفسجي داكن
  static const Color surface = Color(0xFF1E105E);

  /// خلفية أغمق للتأثيرات
  static const Color deepDark = Color(0xFF0F0630);

  // =============================================
  // 🆕 الهوية الجديدة - VM-Cart Amber
  // =============================================

  /// البرتقالي الياقوتي الأساسي (Amber Glow)
  static const Color amberPrimary = Color(0xFFFF8C00);

  /// البرتقالي الفاتح للتدرجات
  static const Color amberLight = Color(0xFFFFA726);

  /// البرتقالي الغامق للحدود النيون
  static const Color amberDark = Color(0xFFE65100);

  /// الأبيض الدافئ (Warm White)
  static const Color warmWhite = Color(0xFFFDF5E6);

  /// الأبيض الدافئ الشفاف
  static Color warmWhiteSoft = const Color(0xFFFDF5E6).withOpacity(0.7);

  // =============================================
  // Accent Colors (الألوان المميزة)
  // =============================================

  /// اللون الأساسي - برتقالي نيون (متوافق مع القديم)
  static const Color primary = Color(0xFFFF8C00);

  /// برتقالي فاتح للتدرجات
  static const Color primaryLight = Color(0xFFFFA726);

  /// برتقالي غامق للظلال
  static const Color primaryDark = Color(0xFFE65100);

  // =============================================
  // ألوان الأوضاع الأربعة
  // =============================================

  /// 🛍️ وضع التسوق - برتقالي
  static const Color shopping = Color(0xFFFF8C00);

  /// 🏪 وضع الجملة - أزرق
  static const Color wholesale = Color(0xFF2196F3);

  /// ♻️ وضع المستعمل - أخضر
  static const Color used = Color(0xFF4CAF50);

  /// 🔥 وضع فرز الإنتاج - أحمر
  static const Color outlet = Color(0xFFF44336);

  // =============================================
  // ألوان النصوص
  // =============================================

  /// النص الأساسي - أبيض
  static const Color textPrimary = Color(0xFFFFFFFF);

  /// النص الثانوي - رمادي فاتح مائل للبنفسجي
  static const Color textSecondary = Color(0xFFB8B8D2);

  /// النص الثالث - رمادي أغمق
  static const Color textTertiary = Color(0xFF8E8EA8);

  /// نص معطل
  static const Color textDisabled = Color(0xFF6B6B8A);

  // =============================================
  // ألوان الحالات (Status Colors)
  // =============================================

  /// نجاح - أخضر فاتح
  static const Color success = Color(0xFF4ADE80);

  /// خطأ - أحمر فاتح
  static const Color error = Color(0xFFF87171);

  /// تحذير - أصفر
  static const Color warning = Color(0xFFFBBF24);

  /// معلومات - أزرق فاتح
  static const Color info = Color(0xFF60A5FA);

  // =============================================
  // ألوان الزجاج (Glassmorphism Opacities)
  // =============================================

  /// زجاج فاتح - 10% شفافية
  static const Color glassLight = Color(0x1AFFFFFF);

  /// زجاج متوسط - 20% شفافية
  static const Color glassMedium = Color(0x33FFFFFF);

  /// زجاج غامق - 5% شفافية
  static const Color glassDark = Color(0x0DFFFFFF);

  /// حدود زجاجية - 15% شفافية
  static const Color glassBorder = Color(0x26FFFFFF);

  // =============================================
  // ألوان إضافية للتدرجات
  // =============================================

  /// بنفسجي فاتح للتوهج
  static const Color purpleGlow = Color(0xFF7B4FDB);

  /// وردي للتوهج
  static const Color pinkGlow = Color(0xFFE83D84);

  /// نيلي للتوهج
  static const Color indigoGlow = Color(0xFF4A1D8C);

  // =============================================
  // 🆕 ألوان الأوضاع الأربعة كـ Map
  // =============================================
  static const Map<String, Color> modeColors = {
    'shopping': shopping,
    'wholesale': wholesale,
    'used': used,
    'outlet': outlet,
  };
}

/// =============================================
/// التدرجات اللونية الجاهزة
/// =============================================
class VirooGradients {
  /// تدرج الخلفية الرئيسي
  static const LinearGradient background = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      VirooColors.background,
      VirooColors.secondary,
    ],
  );

  /// 🆕 تدرج الهوية الجديدة (Amber to Warm White)
  static LinearGradient amberWarm = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      VirooColors.amberPrimary,
      VirooColors.amberLight,
    ],
  );

  /// تدرج برتقالي (للتسوق)
  static const LinearGradient shopping = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      VirooColors.shopping,
      Color(0xFFFFA726),
    ],
  );

  /// تدرج أزرق (للجملة)
  static const LinearGradient wholesale = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      VirooColors.wholesale,
      Color(0xFF64B5F6),
    ],
  );

  /// تدرج أخضر (للمستعمل)
  static const LinearGradient used = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      VirooColors.used,
      Color(0xFF81C784),
    ],
  );

  /// تدرج أحمر (لفرز الإنتاج)
  static const LinearGradient outlet = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      VirooColors.outlet,
      Color(0xFFE57373),
    ],
  );

  /// تدرج زجاجي
  static LinearGradient glass = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      VirooColors.glassLight,
      VirooColors.glassDark,
    ],
  );
}
