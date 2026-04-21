import 'package:flutter/material.dart';
import 'app_colors.dart';

/// =============================================
/// الثيم الرئيسي لتطبيق VirooMall
/// =============================================
class VirooTheme {
  // =============================================
  // الثيم الداكن (الأساسي)
  // =============================================
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: VirooColors.background,
      primaryColor: VirooColors.primary,
      fontFamily: 'Cairo',

      // =========================================
      // AppBar Theme
      // =========================================
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: VirooColors.textPrimary),
        titleTextStyle: TextStyle(
          color: VirooColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Cairo',
        ),
      ),

      // =========================================
      // Elevated Button Theme (Glowing)
      // =========================================
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: VirooColors.primary,
          foregroundColor: Colors.white,
          shadowColor: VirooColors.primary.withOpacity(0.5),
          elevation: 8,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
          ),
        ),
      ),

      // =========================================
      // Text Button Theme
      // =========================================
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: VirooColors.primary,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Cairo',
          ),
        ),
      ),

      // =========================================
      // Outlined Button Theme
      // =========================================
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: VirooColors.primary,
          side: BorderSide(color: VirooColors.primary.withOpacity(0.5)),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
          ),
        ),
      ),

      // =========================================
      // Card Theme (Glassmorphism)
      // =========================================
      cardTheme: CardThemeData(
        color: VirooColors.glassDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: VirooColors.glassBorder,
            width: 1.5,
          ),
        ),
        elevation: 0,
      ),

      // =========================================
      // Input Decoration Theme
      // =========================================
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: VirooColors.glassDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: VirooColors.glassBorder,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: VirooColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: VirooColors.error,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: VirooColors.error,
            width: 2,
          ),
        ),
        labelStyle: const TextStyle(
          color: VirooColors.textSecondary,
          fontFamily: 'Cairo',
        ),
        hintStyle: const TextStyle(
          color: VirooColors.textSecondary,
          fontFamily: 'Cairo',
        ),
        errorStyle: const TextStyle(
          color: VirooColors.error,
          fontFamily: 'Cairo',
        ),
        floatingLabelStyle: const TextStyle(
          color: VirooColors.primary,
          fontFamily: 'Cairo',
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),

      // =========================================
      // Checkbox Theme
      // =========================================
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return VirooColors.primary;
          }
          return Colors.transparent;
        }),
        side: const BorderSide(
          color: VirooColors.textSecondary,
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),

      // =========================================
      // Radio Theme
      // =========================================
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return VirooColors.primary;
          }
          return VirooColors.textSecondary;
        }),
      ),

      // =========================================
      // Switch Theme
      // =========================================
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return VirooColors.primary;
          }
          return Colors.white;
        }),
        trackColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return VirooColors.primary.withOpacity(0.5);
          }
          return Colors.white.withOpacity(0.2);
        }),
      ),

      // =========================================
      // Slider Theme
      // =========================================
      sliderTheme: SliderThemeData(
        activeTrackColor: VirooColors.primary,
        inactiveTrackColor: Colors.white.withOpacity(0.2),
        thumbColor: VirooColors.primary,
        overlayColor: VirooColors.primary.withOpacity(0.2),
        valueIndicatorColor: VirooColors.primary,
        valueIndicatorTextStyle: const TextStyle(
          color: Colors.white,
          fontFamily: 'Cairo',
        ),
      ),

      // =========================================
      // Progress Indicator Theme
      // =========================================
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: VirooColors.primary,
        linearTrackColor: Colors.white12,
        circularTrackColor: Colors.white12,
      ),

      // =========================================
      // Divider Theme
      // =========================================
      dividerTheme: DividerThemeData(
        color: VirooColors.glassBorder,
        thickness: 1,
        space: 1,
      ),

      // =========================================
      // Bottom Navigation Bar Theme
      // =========================================
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: VirooColors.surface.withOpacity(0.8),
        selectedItemColor: VirooColors.primary,
        unselectedItemColor: VirooColors.textSecondary,
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 12,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      // =========================================
      // Tab Bar Theme
      // =========================================
      tabBarTheme: TabBarThemeData(
        labelColor: VirooColors.primary,
        unselectedLabelColor: VirooColors.textSecondary,
        indicatorColor: VirooColors.primary,
        dividerColor: Colors.transparent,
        labelStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
      ),

      // =========================================
      // Dialog Theme
      // =========================================
      dialogTheme: DialogThemeData(
        backgroundColor: VirooColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: VirooColors.glassBorder,
            width: 1,
          ),
        ),
        titleTextStyle: const TextStyle(
          color: VirooColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Cairo',
        ),
        contentTextStyle: const TextStyle(
          color: VirooColors.textSecondary,
          fontSize: 16,
          fontFamily: 'Cairo',
        ),
      ),

      // =========================================
      // Snackbar Theme
      // =========================================
      snackBarTheme: SnackBarThemeData(
        backgroundColor: VirooColors.surface,
        contentTextStyle: const TextStyle(
          color: VirooColors.textPrimary,
          fontFamily: 'Cairo',
        ),
        actionTextColor: VirooColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
        insetPadding: const EdgeInsets.all(16),
      ),

      // =========================================
      // Tooltip Theme
      // =========================================
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: VirooColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: VirooColors.glassBorder,
          ),
        ),
        textStyle: const TextStyle(
          color: VirooColors.textPrimary,
          fontFamily: 'Cairo',
        ),
      ),

      // =========================================
      // Popup Menu Theme
      // =========================================
      popupMenuTheme: PopupMenuThemeData(
        color: VirooColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: VirooColors.glassBorder,
          ),
        ),
        textStyle: const TextStyle(
          color: VirooColors.textPrimary,
          fontFamily: 'Cairo',
        ),
      ),

      // =========================================
      // List Tile Theme
      // =========================================
      listTileTheme: ListTileThemeData(
        iconColor: VirooColors.primary,
        textColor: VirooColors.textPrimary,
        titleTextStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        subtitleTextStyle: const TextStyle(
          fontFamily: 'Cairo',
          color: VirooColors.textSecondary,
          fontSize: 14,
        ),
      ),

      // =========================================
      // Icon Theme
      // =========================================
      iconTheme: const IconThemeData(
        color: VirooColors.textPrimary,
        size: 24,
      ),

      // =========================================
      // Floating Action Button Theme
      // =========================================
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: VirooColors.primary,
        foregroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // =========================================
      // Chip Theme
      // =========================================
      chipTheme: ChipThemeData(
        backgroundColor: VirooColors.glassDark,
        selectedColor: VirooColors.primary,
        secondarySelectedColor: VirooColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        labelStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
        ),
        secondaryLabelStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
        ),
        brightness: Brightness.dark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: VirooColors.glassBorder,
          ),
        ),
      ),

      // =========================================
      // Color Scheme
      // =========================================
      colorScheme: const ColorScheme.dark(
        primary: VirooColors.primary,
        secondary: VirooColors.secondary,
        surface: VirooColors.surface,
        error: VirooColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: VirooColors.textPrimary,
        onError: Colors.white,
      ),
    );
  }

  // =============================================
  // الثيم الفاتح (للتوسع المستقبلي)
  // =============================================
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      primaryColor: VirooColors.primary,
      fontFamily: 'Cairo',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: VirooColors.background),
        titleTextStyle: TextStyle(
          color: VirooColors.background,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Cairo',
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: VirooColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: VirooColors.primary,
            width: 2,
          ),
        ),
        labelStyle: const TextStyle(
          color: Colors.grey,
          fontFamily: 'Cairo',
        ),
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontFamily: 'Cairo',
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),
        elevation: 2,
      ),
      colorScheme: const ColorScheme.light(
        primary: VirooColors.primary,
        secondary: VirooColors.secondary,
        surface: Colors.white,
        error: VirooColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: VirooColors.background,
        onError: Colors.white,
      ),
    );
  }
}
