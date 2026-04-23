// Seller Dashboard
// lib/features/profile/presentation/screens/seller_dashboard_screen.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/viroo_background.dart';

class SellerDashboardScreen extends StatelessWidget {
  const SellerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة تحكم البائع',
            style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: VirooBackground(
        showOrbs: true,
        themeColor: VirooColors.primary,
        child: const Center(
          child: Text('📊 لوحة تحكم البائع\n(هتتعمل قريباً)',
              style: TextStyle(
                  color: Colors.white, fontSize: 18, fontFamily: 'Cairo'),
              textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
