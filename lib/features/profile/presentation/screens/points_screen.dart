// Points Screen
// lib/features/profile/presentation/screens/points_screen.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/viroo_background.dart';

class PointsScreen extends StatelessWidget {
  const PointsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('النقاط والمكافآت',
            style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: VirooBackground(
        showOrbs: true,
        themeColor: VirooColors.primary,
        child: const Center(
          child: Text('🎁 النقاط والمكافآت\n(هتتعمل قريباً)',
              style: TextStyle(
                  color: Colors.white, fontSize: 18, fontFamily: 'Cairo'),
              textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
