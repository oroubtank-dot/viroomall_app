// lib/core/widgets/logo/vm_cart_icon.dart
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class VMCartIcon extends StatelessWidget {
  final double size;
  final Color? color;
  final bool withGlow;

  const VMCartIcon({
    super.key,
    this.size = 150,
    this.color,
    this.withGlow = true,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = color ?? VirooColors.amberPrimary;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: iconColor.withOpacity(0.15),
        border: Border.all(
          color: iconColor.withOpacity(0.5),
          width: size * 0.02,
        ),
        boxShadow: withGlow
            ? [
                BoxShadow(
                  color: iconColor.withOpacity(0.4),
                  blurRadius: size * 0.3,
                  spreadRadius: size * 0.07,
                ),
                BoxShadow(
                  color: iconColor.withOpacity(0.2),
                  blurRadius: size * 0.6,
                  spreadRadius: size * 0.15,
                ),
              ]
            : null,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // VM Text
          Text(
            'VM',
            style: TextStyle(
              fontSize: size * 0.3,
              fontWeight: FontWeight.bold,
              fontFamily: 'Orbitron',
              color: iconColor,
              letterSpacing: 2,
              shadows: withGlow
                  ? [
                      Shadow(
                        color: iconColor.withOpacity(0.8),
                        blurRadius: size * 0.1,
                      ),
                    ]
                  : null,
            ),
          ),
          // Cart Icon
          Positioned(
            bottom: size * 0.2,
            child: Icon(
              Icons.shopping_cart_rounded,
              size: size * 0.25,
              color: iconColor,
            ),
          ),
          // Star
          Positioned(
            top: size * 0.22,
            right: size * 0.18,
            child: Icon(
              Icons.star_rounded,
              size: size * 0.15,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }
}
