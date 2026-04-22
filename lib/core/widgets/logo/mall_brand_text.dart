// lib/core/widgets/logo/mall_brand_text.dart
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class MallBrandText extends StatelessWidget {
  final double fontSize;

  const MallBrandText({
    super.key,
    this.fontSize = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      'Mall',
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        fontFamily: 'Orbitron',
        color: VirooColors.warmWhite,
        letterSpacing: 1.5,
      ),
    );
  }
}
