import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_widgets.dart';

class VirooSearchBar extends StatelessWidget {
  final VoidCallback? onTap;

  const VirooSearchBar({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        borderRadius: BorderRadius.circular(15),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: const Row(
          children: [
            Icon(
              Icons.search_rounded,
              color: VirooColors.primary,
              size: 24,
            ),
            SizedBox(width: 12),
            Expanded(
              child: TextField(
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Cairo',
                ),
                decoration: InputDecoration(
                  hintText: "بتدور على إيه في VirooMall؟",
                  hintStyle: TextStyle(
                    color: Colors.white38,
                    fontSize: 14,
                    fontFamily: 'Cairo',
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            Icon(
              Icons.mic_rounded,
              color: VirooColors.primary,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
