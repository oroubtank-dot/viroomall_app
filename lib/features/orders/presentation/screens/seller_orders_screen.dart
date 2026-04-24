// lib/features/orders/presentation/screens/seller_orders_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';
// 👈 المسار الصحيح
// 👈 المسار الصحيح

class SellerOrdersScreen extends ConsumerWidget {
  const SellerOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // هنا هنجيب الطلبات من Firestore
    // final ordersAsync = ref.watch(sellerOrdersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'الطلبات الواردة',
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5, // مؤقت
        itemBuilder: (context, index) {
          return _buildOrderCard(context, ref);
        },
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, WidgetRef ref) {
    return GlassContainer(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: VirooColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.shopping_bag_rounded,
                    color: VirooColors.primary),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'آيفون 15 برو ماكس',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo'),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'الكمية: 1',
                      style: TextStyle(
                          color: VirooColors.textSecondary,
                          fontFamily: 'Cairo',
                          fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: VirooColors.warning.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'قيد الانتظار',
                  style: TextStyle(
                      color: VirooColors.warning,
                      fontFamily: 'Cairo',
                      fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: GlowingButton(
                  onPressed: () {
                    // قبول الطلب
                  },
                  text: 'قبول',
                  icon: Icons.check_circle_rounded,
                  height: 40,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // رفض الطلب
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: VirooColors.error),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('رفض',
                      style: TextStyle(
                          color: VirooColors.error, fontFamily: 'Cairo')),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
