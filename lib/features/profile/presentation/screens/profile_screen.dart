// lib/features/profile/presentation/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/viroo_background.dart';
import '../../../../core/services/auth_service.dart';
import '../providers/profile_provider.dart';
import '../../domain/models/user_model.dart';
import '../../domain/models/seller_stats.dart';
import '../../domain/models/buyer_stats.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_share_button.dart';
import '../widgets/seller_stats_widget.dart';
import '../widgets/buyer_stats_widget.dart';
import '../widgets/profile_menu_section.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // 👈 نأجل تعديل الـ Provider لبعد ما الشجرة تتبني
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setDefaultUser();
    });
  }

  void _setDefaultUser() {
    ref.read(profileNotifierProvider.notifier).setUser(UserModel.mockSeller());
    ref.read(sellerStatsProvider.notifier).state = SellerStats.mock();
  }

  void _switchToBuyer() {
    ref.read(profileNotifierProvider.notifier).setUser(UserModel.mockBuyer());
    ref.read(buyerStatsProvider.notifier).state = BuyerStats.mock();
    ref.read(sellerStatsProvider.notifier).state = null;
  }

  void _switchToSeller() {
    ref.read(profileNotifierProvider.notifier).setUser(UserModel.mockSeller());
    ref.read(sellerStatsProvider.notifier).state = SellerStats.mock();
    ref.read(buyerStatsProvider.notifier).state = null;
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(profileNotifierProvider);
    final sellerStats = ref.watch(sellerStatsProvider);
    final buyerStats = ref.watch(buyerStatsProvider);
    final themeColor = VirooColors.primary;

    if (user == null) {
      return Scaffold(
        body: VirooBackground(
          showOrbs: true,
          themeColor: themeColor,
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('حسابي',
            style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _switchToBuyer,
            child: Text('مشتري',
                style: TextStyle(
                    color: user.isBuyer ? themeColor : Colors.white54,
                    fontFamily: 'Cairo',
                    fontSize: 12)),
          ),
          TextButton(
            onPressed: _switchToSeller,
            child: Text('بائع',
                style: TextStyle(
                    color: user.isSeller ? themeColor : Colors.white54,
                    fontFamily: 'Cairo',
                    fontSize: 12)),
          ),
          IconButton(
              icon: const Icon(Icons.settings_outlined), onPressed: () {}),
        ],
      ),
      body: VirooBackground(
        showOrbs: true,
        themeColor: themeColor,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              ProfileHeader(user: user, themeColor: themeColor),
              const SizedBox(height: 24),
              if (user.isSeller) ...[
                ProfileShareButton(themeColor: themeColor, onTap: () {}),
                const SizedBox(height: 24),
              ],
              if (user.isSeller && sellerStats != null)
                SellerStatsWidget(stats: sellerStats, themeColor: themeColor)
              else if (user.isBuyer && buyerStats != null)
                BuyerStatsWidget(stats: buyerStats, themeColor: themeColor),
              const SizedBox(height: 24),
              ProfileMenuSection(
                user: user,
                themeColor: themeColor,
                parentContext: context,
                sellerStats: sellerStats,
                buyerStats: buyerStats,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
