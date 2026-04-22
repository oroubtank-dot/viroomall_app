// lib/core/widgets/logo/viroo_mall_logo.dart
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_widgets.dart';

class VirooMallLogo extends StatelessWidget {
  final double size;
  final bool withNeon;
  final bool withCart;
  final bool horizontal;

  const VirooMallLogo({
    super.key,
    this.size = 28,
    this.withNeon = true,
    this.withCart = true,
    this.horizontal = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget logo = horizontal ? _buildHorizontalLogo() : _buildVerticalLogo();

    if (withNeon) {
      return NeonBorderContainer(
        borderColor: VirooColors.amberPrimary,
        borderWidth: 2,
        glowRadius: 12,
        borderRadius: BorderRadius.circular(12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: logo,
      );
    }

    return logo;
  }

  Widget _buildHorizontalLogo() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Viroo',
          style: TextStyle(
            fontSize: size,
            fontWeight: FontWeight.bold,
            fontFamily: 'Orbitron',
            color: VirooColors.amberPrimary,
            letterSpacing: 1.2,
            shadows: [
              Shadow(
                color: VirooColors.amberPrimary.withOpacity(0.5),
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
              color: VirooColors.amberPrimary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.shopping_cart_rounded,
              size: size - 4,
              color: VirooColors.amberPrimary,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildVerticalLogo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Viroo',
          style: TextStyle(
            fontSize: size,
            fontWeight: FontWeight.bold,
            fontFamily: 'Orbitron',
            color: VirooColors.amberPrimary,
            letterSpacing: 1.2,
            shadows: [
              Shadow(
                color: VirooColors.amberPrimary.withOpacity(0.5),
                blurRadius: 10,
              ),
            ],
          ),
        ),
        Text(
          'Mall',
          style: TextStyle(
            fontSize: size * 0.8,
            fontWeight: FontWeight.bold,
            fontFamily: 'Orbitron',
            color: VirooColors.warmWhite,
            letterSpacing: 1.2,
          ),
        ),
        if (withCart) ...[
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: VirooColors.amberPrimary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.shopping_cart_rounded,
              size: size - 4,
              color: VirooColors.amberPrimary,
            ),
          ),
        ],
      ],
    );
  }
}
