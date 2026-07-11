// lib/core/widgets/loading_indicator.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// 🔄 Custom Loading Indicator
/// مؤشر تحميل مخصص
class VirooLoadingIndicator extends StatelessWidget {
  final String? message;
  final double size;
  final Color color;

  const VirooLoadingIndicator({
    Key? key,
    this.message,
    this.size = 50,
    this.color = VirooColors.primary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(color),
              strokeWidth: 3,
            ),
          ),
          if (message != null) ...
            [
              const SizedBox(height: 16),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
        ],
      ),
    );
  }
}
