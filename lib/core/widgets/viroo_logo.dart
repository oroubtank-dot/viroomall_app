// lib/core/widgets/viroo_logo.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_widgets.dart';

class VirooLogo extends StatelessWidget {
  final double size;
  final bool withNeon;
  final bool withCart;
  final Color? customColor;

  const VirooLogo({
    super.key,
    this.size = 28,
    this.withNeon = true,
    this.withCart = true,
    this.customColor,
  });

  @override
  Widget build(BuildContext context) {
    final amberColor = customColor ?? VirooColors.amberPrimary;

    Widget logo = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Viroo',
          style: TextStyle(
            fontSize: size,
            fontWeight: FontWeight.bold,
            fontFamily: 'Orbitron',
            color: amberColor,
            letterSpacing: 1.2,
            shadows: [
              Shadow(
                color: amberColor.withOpacity(0.5),
                blurRadius: 10,
              ),
            ],
          ),
        ),
        Text(
          'Mall',
          style: TextStyle(
            fontSize: size,
            fontWeight: FontWeight.bold,
            fontFamily: 'Orbitron',
            color: VirooColors.warmWhite,
            letterSpacing: 1.2,
          ),
        ),
        if (withCart) ...[
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: amberColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.shopping_cart_rounded,
              size: size - 4,
              color: amberColor,
            ),
          ),
        ],
      ],
    );

    if (withNeon) {
      return NeonBorderContainer(
        borderColor: amberColor,
        borderWidth: 2,
        glowRadius: 12,
        borderRadius: BorderRadius.circular(12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: logo,
      );
    }

    return logo;
  }
}

// =============================================
// VM-Cart Logo للـ Splash Screen
// =============================================
class VMCartLogo extends StatelessWidget {
  final double size;
  final double glowOpacity;

  const VMCartLogo({
    super.key,
    this.size = 140,
    this.glowOpacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: VirooColors.amberPrimary.withOpacity(0.15 * glowOpacity),
        border: Border.all(
          color:
              VirooColors.amberPrimary.withOpacity(0.5 + (0.5 * glowOpacity)),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: VirooColors.amberPrimary.withOpacity(0.5 * glowOpacity),
            blurRadius: 40,
            spreadRadius: 10,
          ),
          BoxShadow(
            color: VirooColors.amberPrimary.withOpacity(0.3 * glowOpacity),
            blurRadius: 80,
            spreadRadius: 20,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // VM-Cart Logo
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'VM',
                style: TextStyle(
                  fontSize: size * 0.3,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Orbitron',
                  color: VirooColors.amberPrimary,
                  shadows: [
                    Shadow(
                      color: VirooColors.amberPrimary.withOpacity(0.8),
                      blurRadius: 15,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.shopping_cart_rounded,
                size: size * 0.25,
                color: VirooColors.amberPrimary,
              ),
            ],
          ),
          // نجمة
          Positioned(
            top: size * 0.22,
            right: size * 0.18,
            child: Icon(
              Icons.star_rounded,
              size: size * 0.15,
              color: VirooColors.amberPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
