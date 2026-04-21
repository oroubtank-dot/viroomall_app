// lib/features/home/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';
import '../../../../core/widgets/viroo_background.dart';
import '../../../../core/widgets/viroo_search_bar.dart';
import '../../../../core/services/auth_service.dart';
import '../providers/home_provider.dart';
import '../widgets/mode_selector.dart';
import '../widgets/hot_sales_banner.dart';
import '../widgets/featured_products_section.dart';
import '../widgets/floating_nav_bar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final selectedMode = ref.watch(shopModeProvider);
    final modes = ref.watch(shopModesProvider);

    return Scaffold(
      body: VirooBackground(
        showOrbs: true,
        child: SafeArea(
          child: SingleChildScrollView(
            // 👈 السحر اللي هيحل المشكلة
            physics: const BouncingScrollPhysics(), // 👈 نعومة في السكرول
            child: Column(
              children: [
                _buildHeader(),
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: VirooSearchBar(),
                ),
                ModeSelector(
                  modes: modes,
                  selectedMode: selectedMode,
                  onModeChanged: (mode) {
                    ref.read(shopModeProvider.notifier).state = mode;
                  },
                ),
                const HotSalesBanner(),
                const FeaturedProductsSection(),
                const SizedBox(
                    height: 100), // 👈 مساحة للـ Bottom Nav Bar العائم
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: FloatingNavBar(
        selectedIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Row(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [VirooColors.primary, VirooColors.primaryLight],
            ).createShader(bounds),
            child: const Text(
              'VirooMall',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Cairo',
                letterSpacing: 1.5,
              ),
            ),
          ),
          const Spacer(),
          GlassContainer(
            padding: const EdgeInsets.all(10),
            borderRadius: BorderRadius.circular(12),
            child: Icon(
              Icons.notifications_outlined,
              color: VirooColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () async {
              await AuthService.signOut();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/');
              }
            },
            child: GlassContainer(
              padding: const EdgeInsets.all(10),
              borderRadius: BorderRadius.circular(12),
              child: Icon(
                Icons.logout_rounded,
                color: VirooColors.error,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
