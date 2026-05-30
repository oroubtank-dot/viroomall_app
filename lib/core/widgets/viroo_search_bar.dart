// lib/core/widgets/viroo_search_bar.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_widgets.dart';
import 'logo/vm_cart_icon.dart';

class VirooSearchBar extends StatelessWidget {
  final VoidCallback? onTap;
  final TextEditingController? controller;

  const VirooSearchBar({
    super.key,
    this.onTap,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: NeonBorderContainer(
        borderColor: VirooColors.amberPrimary,
        borderWidth: 2,
        glowRadius: 15,
        borderRadius: BorderRadius.circular(15),
        child: GlassContainer(
          borderRadius: BorderRadius.circular(15),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          child: Row(
            children: [
              // 🆕 أيقونة VM-Cart بدل البحث
              const VMCartIcon(
                size: 28,
                withGlow: false,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: controller,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Cairo',
                  ),
                  decoration: InputDecoration(
                    hintText: "بتدور على إيه في VirooMall؟",
                    hintStyle: TextStyle(
                      color: VirooColors.warmWhite.withOpacity(0.5),
                      fontSize: 14,
                      fontFamily: 'Cairo',
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              // أيقونة المايك
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: VirooColors.amberPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.mic_rounded,
                  color: VirooColors.amberPrimary,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
