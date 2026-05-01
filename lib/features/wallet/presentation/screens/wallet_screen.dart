// lib/features/wallet/presentation/screens/wallet_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';
import '../../../../core/widgets/viroo_background.dart';
import '../providers/wallet_provider.dart';
import '../widgets/balance_card.dart';
import '../widgets/transaction_card.dart';
import 'add_funds_screen.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsProvider);
    final themeColor = VirooColors.amberPrimary;

    return Scaffold(
      backgroundColor: VirooColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('💰 محفظتي',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                fontSize: 20)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: VirooBackground(
        showOrbs: true,
        themeColor: themeColor,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: BalanceCard(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GlowingButton(
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddFundsScreen()),
                  );
                },
                text: '💳 اشحن محفظتك الآن',
                icon: Icons.add_circle_rounded,
                backgroundColor: themeColor,
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text('📋 سجل المعاملات',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo')),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: transactionsAsync.when(
                data: (transactions) => transactions.isEmpty
                    ? const Center(
                        child: EmptyState(
                          icon: Icons.receipt_long_rounded,
                          title: 'لا توجد معاملات',
                          subtitle: 'سجل معاملاتك هتظهر هنا',
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        physics: const BouncingScrollPhysics(),
                        itemCount: transactions.length,
                        itemBuilder: (context, index) {
                          return TransactionCard(
                              transaction: transactions[index]);
                        },
                      ),
                loading: () => const Center(
                    child: CircularProgressIndicator(
                        color: VirooColors.amberPrimary)),
                error: (_, __) => const Center(
                    child: Text('❌ حدث خطأ',
                        style: TextStyle(
                            color: VirooColors.error, fontFamily: 'Cairo'))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
