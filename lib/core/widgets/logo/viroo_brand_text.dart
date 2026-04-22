// lib/core/widgets/logo/viroo_brand_text.dart
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class VirooBrandText extends StatelessWidget {
  final double fontSize;
  final bool withGlow;

  const VirooBrandText({
    super.key,
    this.fontSize = 40,
    this.withGlow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      'Viroo',
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        fontFamily: 'Orbitron',
        color: VirooColors.amberPrimary,
        letterSpacing: 1.5,
        shadows: withGlow
            ? [
                Shadow(
                  color: VirooColors.amberPrimary.withOpacity(0.7),
                  blurRadius: 20,
                ),
              ]
            : null,
      ),
    );
  }
}
