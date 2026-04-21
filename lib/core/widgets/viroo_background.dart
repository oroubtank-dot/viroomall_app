// lib/core/widgets/viroo_background.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class VirooBackground extends StatelessWidget {
  final Widget child;
  final bool showOrbs;
  final Color? themeColor;

  const VirooBackground({
    super.key,
    required this.child,
    this.showOrbs = true,
    this.themeColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = themeColor ?? VirooColors.primary;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            VirooColors.background,
            VirooColors.secondary,
          ],
        ),
      ),
      child: Stack(
        children: [
          if (showOrbs) ...[
            // دائرة بنفسجية كبيرة فوق على اليمين
            Positioned(
              top: -150,
              right: -100,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: effectiveColor.withOpacity(0.2),
                  boxShadow: [
                    BoxShadow(
                      color: effectiveColor.withOpacity(0.15),
                      blurRadius: 100,
                      spreadRadius: 50,
                    ),
                  ],
                ),
              ),
            ),

            // دائرة برتقالية وهمية في النص على الشمال
            Positioned(
              top: 200,
              left: -80,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: effectiveColor.withOpacity(0.25),
                  boxShadow: [
                    BoxShadow(
                      color: effectiveColor.withOpacity(0.2),
                      blurRadius: 120,
                      spreadRadius: 60,
                    ),
                  ],
                ),
              ),
            ),

            // دائرة وردية/أرجوانية في الأسفل على اليمين
            Positioned(
              bottom: -100,
              right: -50,
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFE83D84).withOpacity(0.2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE83D84).withOpacity(0.15),
                      blurRadius: 150,
                      spreadRadius: 80,
                    ),
                  ],
                ),
              ),
            ),

            // دائرة بنفسجية فاتحة في النص على اليمين
            Positioned(
              top: 400,
              right: -50,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF7B4FDB).withOpacity(0.2),
                ),
              ),
            ),

            // دائرة زرقاء نيلي في الأسفل على الشمال
            Positioned(
              bottom: 50,
              left: -100,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF1E105E).withOpacity(0.5),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1E105E).withOpacity(0.4),
                      blurRadius: 100,
                      spreadRadius: 40,
                    ),
                  ],
                ),
              ),
            ),
          ],

          // طبقة الضبابية السحرية (Blur Layer)
          if (showOrbs)
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
              child: Container(color: Colors.transparent),
            ),

          // طبقة تدرج شفافة لتعميق الألوان
          if (showOrbs)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    VirooColors.background.withOpacity(0.3),
                    Colors.transparent,
                    VirooColors.secondary.withOpacity(0.4),
                  ],
                ),
              ),
            ),

          // المحتوى الأساسي (الشاشة نفسها)
          child,
        ],
      ),
    );
  }
}
