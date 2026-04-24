// lib/features/home/presentation/widgets/floating_nav_bar.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import 'dart:ui';

/// =============================================
/// 🚀 Floating Nav Bar - شريط التنقل العائم
/// =============================================
///
/// تصميم Cyber-Glassy مع زرار إضافة منتج طائر في النص:
/// - 4 أيقونات جانبية (الرئيسية، المفضلة، السلة، حسابي)
/// - زرار إضافة منتج بارز في النص (Floating Action)
/// - تأثير نيون وجلاس
/// - Animation نبض للزرار الأوسط
/// =============================================
class FloatingNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const FloatingNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  State<FloatingNavBar> createState() => _FloatingNavBarState();
}

class _FloatingNavBarState extends State<FloatingNavBar>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // نبض للزرار الأوسط
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // 🧊 الخلفية الزجاجية للشريط
          Container(
            decoration: BoxDecoration(
              color: VirooColors.surface.withOpacity(0.85),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: VirooColors.glassBorder,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: VirooColors.amberPrimary.withOpacity(0.15),
                  blurRadius: 20,
                  spreadRadius: -2,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
          ),

          // 🎯 الأيقونات الجانبية
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // 🏠 الرئيسية
              _buildNavItem(
                icon: Icons.home_rounded,
                label: 'الرئيسية',
                index: 0,
              ),

              // ❤️ المفضلة
              _buildNavItem(
                icon: Icons.favorite_rounded,
                label: 'المفضلة',
                index: 1,
              ),

              // ⭐ مساحة فاضية للزرار الأوسط
              const SizedBox(width: 50),

              // 🛒 السلة
              _buildNavItem(
                icon: Icons.shopping_cart_rounded,
                label: 'السلة',
                index: 2,
              ),

              // 👤 حسابي
              _buildNavItem(
                icon: Icons.person_rounded,
                label: 'حسابي',
                index: 3,
              ),
            ],
          ),

          // 🟠 الزرار الأوسط الطائر (إضافة منتج)
          Positioned(
            top: -20,
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: child,
                );
              },
              child: GestureDetector(
                onTapDown: (_) => HapticFeedback.mediumImpact(),
                onTap: () => widget.onTap(-1),
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        VirooColors.amberPrimary,
                        VirooColors.amberLight,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: VirooColors.amberPrimary.withOpacity(0.6),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: VirooColors.amberPrimary.withOpacity(0.3),
                        blurRadius: 35,
                        spreadRadius: 5,
                      ),
                    ],
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = widget.selectedIndex == index;

    return GestureDetector(
      onTap: () => widget.onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: isSelected
            ? BoxDecoration(
                color: VirooColors.amberPrimary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: VirooColors.amberPrimary.withOpacity(0.3),
                  width: 1,
                ),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? VirooColors.amberPrimary
                  : VirooColors.textSecondary,
              size: 22,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? VirooColors.amberPrimary
                    : VirooColors.textSecondary,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
