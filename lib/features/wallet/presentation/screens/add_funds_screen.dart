// lib/features/wallet/presentation/screens/add_funds_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';
import '../../../../core/widgets/viroo_background.dart';
import '../providers/wallet_provider.dart';
import '../../data/wallet_service.dart';
import '../../../../core/services/auth_service.dart';

class AddFundsScreen extends ConsumerStatefulWidget {
  const AddFundsScreen({super.key});

  @override
  ConsumerState<AddFundsScreen> createState() => _AddFundsScreenState();
}

class _AddFundsScreenState extends ConsumerState<AddFundsScreen> {
  final _amountController = TextEditingController();
  String _selectedMethod = 'instapay';
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _confirmPayment() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount < 50) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ الحد الأدنى للشحن 50 ج',
              style: TextStyle(fontFamily: 'Cairo')),
          backgroundColor: VirooColors.warning,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: VirooColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('💳 تأكيد الشحن',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('المبلغ: ${amount.toStringAsFixed(0)} ج.م',
                style: const TextStyle(
                    color: VirooColors.textSecondary, fontFamily: 'Cairo')),
            const SizedBox(height: 8),
            Text('الطريقة: ${_getMethodLabel(_selectedMethod)}',
                style: const TextStyle(
                    color: VirooColors.textSecondary, fontFamily: 'Cairo')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء',
                style: TextStyle(
                    fontFamily: 'Cairo', color: VirooColors.textSecondary)),
          ),
          GlowingButton(
            onPressed: () {
              Navigator.pop(ctx);
              _processPayment(amount);
            },
            text: '✅ تأكيد',
            width: 120,
            height: 40,
          ),
        ],
      ),
    );
  }

  Future<void> _processPayment(double amount) async {
    setState(() => _isLoading = true);

    try {
      // محاكاة نجاح الدفع (للتجربة)
      await Future.delayed(const Duration(seconds: 1));

      final user = AuthService.currentUser;
      if (user != null && mounted) {
        final walletService = ref.read(walletServiceProvider);
        await walletService.deposit(
            user.uid, amount, _getMethodLabel(_selectedMethod));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ تم شحن المحفظة بنجاح! 🎉',
                style: TextStyle(fontFamily: 'Cairo')),
            backgroundColor: VirooColors.success,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('❌ فشل: $e', style: const TextStyle(fontFamily: 'Cairo')),
            backgroundColor: VirooColors.error,
          ),
        );
      }
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = VirooColors.amberPrimary;

    return Scaffold(
      backgroundColor: VirooColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('💳 شحن المحفظة',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: VirooBackground(
        showOrbs: true,
        themeColor: themeColor,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GlassContainer(
                padding: const EdgeInsets.all(20),
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('💰 المبلغ',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo')),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontFamily: 'Orbitron'),
                      decoration: InputDecoration(
                        hintText: '0',
                        suffixText: 'ج.م',
                        suffixStyle: const TextStyle(
                            color: VirooColors.textSecondary,
                            fontSize: 18,
                            fontFamily: 'Cairo'),
                        filled: true,
                        fillColor: VirooColors.glassDark,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text('اختر طريقة الشحن:',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo')),
              const SizedBox(height: 12),
              _methodCard('instapay', '📱 InstaPay', 'تحويل فوري - بدون رسوم'),
              _methodCard(
                  'vodafone_cash', '📱 فودافون كاش', 'تحويل فوري - بدون رسوم'),
              _methodCard('bank', '🏦 تحويل بنكي', 'يستغرق 1-3 ساعات'),
              const SizedBox(height: 8),
              GlassContainer(
                padding: const EdgeInsets.all(14),
                borderRadius: BorderRadius.circular(16),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded,
                        color: VirooColors.info, size: 20),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'بعد التحويل، الرصيد هيضاف تلقائياً لمحفظتك خلال دقائق',
                        style: TextStyle(
                          color: VirooColors.textSecondary,
                          fontSize: 12,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              GlowingButton(
                onPressed: _isLoading ? () {} : _confirmPayment,
                text: _isLoading ? '⏳ جاري المعالجة...' : '💳 شحن الآن',
                isLoading: _isLoading,
                backgroundColor: themeColor,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _methodCard(String value, String title, String subtitle) {
    final isSelected = _selectedMethod == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? VirooColors.amberPrimary.withAlpha(38)
              : VirooColors.glassDark,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color:
                isSelected ? VirooColors.amberPrimary : VirooColors.glassBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected ? VirooColors.amberPrimary : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(width: 10),
            Text(
              subtitle,
              style: const TextStyle(
                color: VirooColors.textSecondary,
                fontSize: 11,
                fontFamily: 'Cairo',
              ),
            ),
            const Spacer(),
            Icon(
              isSelected ? Icons.check_circle_rounded : Icons.circle_outlined,
              color: isSelected
                  ? VirooColors.amberPrimary
                  : VirooColors.textSecondary,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  String _getMethodLabel(String method) {
    switch (method) {
      case 'instapay':
        return 'InstaPay';
      case 'vodafone_cash':
        return 'فودافون كاش';
      case 'bank':
        return 'تحويل بنكي';
      default:
        return method;
    }
  }
}
