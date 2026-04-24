// Favorites Screen
// lib/features/profile/presentation/screens/favorites_screen.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/viroo_background.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المفضلة',
            style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: const VirooBackground(
        showOrbs: true,
        themeColor: VirooColors.primary,
        child: Center(
          child: Text('❤️ المفضلة\n(هتتعمل قريباً)',
              style: TextStyle(
                  color: Colors.white, fontSize: 18, fontFamily: 'Cairo'),
              textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
