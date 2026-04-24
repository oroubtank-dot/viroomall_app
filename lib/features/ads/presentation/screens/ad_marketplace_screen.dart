// lib/features/ads/presentation/screens/ad_marketplace_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';
import '../../../../core/widgets/viroo_background.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdMarketplaceScreen extends ConsumerStatefulWidget {
  const AdMarketplaceScreen({super.key});

  @override
  ConsumerState<AdMarketplaceScreen> createState() =>
      _AdMarketplaceScreenState();
}

class _AdMarketplaceScreenState extends ConsumerState<AdMarketplaceScreen> {
  String _selectedMode = 'shopping';
  double _userBalance = 2500;

  final List<int> _auctionPrices = [750, 520, 380, 290, 220];
  final List<String> _bidders = [
    'متجر التكنولوجيا',
    'مصنع الملابس',
    'أحمد للإلكترونيات',
    'عالم الرياضة',
    'بيت الأزياء'
  ];
  final List<int> _daysLeft = [3, 7, 2, 5, 1];

  @override
  Widget build(BuildContext context) {
    final themeColor =
        VirooColors.modeColors[_selectedMode] ?? VirooColors.shopping;

    return VirooBackground(
      showOrbs: true,
      themeColor: themeColor,
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, themeColor),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildModeSelector(),
                    _buildAuctionSection(themeColor),
                    const SizedBox(height: 20),
                    _buildFixedPriceSection(themeColor),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color themeColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: GlassContainer(
              padding: const EdgeInsets.all(10),
              borderRadius: BorderRadius.circular(12),
              child:
                  Icon(Icons.arrow_back_rounded, color: themeColor, size: 22),
            ),
          ),
          const SizedBox(width: 16),
          const Text('🏦 سوق الإعلانات',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: VirooColors.textPrimary,
                  fontFamily: 'Cairo')),
          const Spacer(),
          GlassContainer(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            borderRadius: BorderRadius.circular(12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.account_balance_wallet_rounded,
                    color: themeColor, size: 18),
                const SizedBox(width: 6),
                Text('${_userBalance.toStringAsFixed(0)} ج',
                    style: TextStyle(
                        color: themeColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: 'Cairo')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeSelector() {
    final modes = [
      {'mode': 'shopping', 'label': '🛍️ تسوق', 'color': VirooColors.shopping},
      {'mode': 'wholesale', 'label': '🏪 جملة', 'color': VirooColors.wholesale},
      {'mode': 'used', 'label': '♻️ مستعمل', 'color': VirooColors.used},
      {'mode': 'outlet', 'label': '🔥 فرز', 'color': VirooColors.outlet},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: modes.map((mode) {
          final isSelected = _selectedMode == mode['mode'];
          final color = mode['color'] as Color;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: GestureDetector(
                onTap: () =>
                    setState(() => _selectedMode = mode['mode'] as String),
                child: GlassContainer(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  borderRadius: BorderRadius.circular(12),
                  child: Text(
                    mode['label'] as String,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? color : VirooColors.textSecondary,
                        fontFamily: 'Cairo'),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAuctionSection(Color themeColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              Icon(Icons.gavel_rounded, color: VirooColors.error, size: 20),
              const SizedBox(width: 8),
              const Text('🔴 مزادات نشطة',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: VirooColors.textPrimary,
                      fontFamily: 'Cairo')),
              const Spacer(),
              const Text('الصفحات 1-5',
                  style: TextStyle(
                      color: VirooColors.textSecondary,
                      fontSize: 12,
                      fontFamily: 'Cairo')),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 5,
            itemBuilder: (context, index) {
              return _buildAuctionCard(index, themeColor);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAuctionCard(int index, Color themeColor) {
    return Container(
      width: 190,
      margin: const EdgeInsets.only(right: 12),
      child: Stack(
        children: [
          Positioned(
            bottom: 8,
            left: 18,
            right: 18,
            child: Container(
              height: 35,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    color: VirooColors.error.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2)
              ]),
            ),
          ),
          GlassContainer(
            padding: const EdgeInsets.all(12),
            borderRadius: BorderRadius.circular(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: VirooColors.error.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8)),
                      child: Text('🥇 ${index + 1}',
                          style: TextStyle(
                              color: VirooColors.error,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              fontFamily: 'Cairo')),
                    ),
                    const Spacer(),
                    Text('${_daysLeft[index]} أيام',
                        style: const TextStyle(
                            color: VirooColors.textSecondary,
                            fontSize: 10,
                            fontFamily: 'Cairo')),
                  ],
                ),
                const SizedBox(height: 8),
                Text('${_auctionPrices[index]} ج',
                    style: TextStyle(
                        color: themeColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Orbitron')),
                const SizedBox(height: 4),
                Text(_bidders[index],
                    style: const TextStyle(
                        color: VirooColors.textSecondary,
                        fontSize: 10,
                        fontFamily: 'Cairo'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      _showBiddingSheet(context, index + 1,
                          _auctionPrices[index].toDouble(), themeColor);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: VirooColors.error,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: const Text('💰 زايد الآن',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                            color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFixedPriceSection(Color themeColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            children: [
              Icon(Icons.store_rounded, color: VirooColors.warning, size: 20),
              const SizedBox(width: 8),
              const Text('🟡 إعلانات بسعر ثابت',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: VirooColors.textPrimary,
                      fontFamily: 'Cairo')),
            ],
          ),
        ),
        _buildFixedCard(
            title: '📄 الصفحات 6-10',
            price: '150 ج/شهر',
            available: '2 أماكن متاحة',
            themeColor: themeColor,
            tier: 2),
        const SizedBox(height: 8),
        _buildFixedCard(
            title: '📄 الصفحات 11-20',
            price: '100 ج/شهر',
            available: '5 أماكن متاحة',
            themeColor: themeColor,
            tier: 3),
      ],
    );
  }

  Widget _buildFixedCard(
      {required String title,
      required String price,
      required String available,
      required Color themeColor,
      required int tier}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: VirooColors.warning.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12)),
                child: Icon(Icons.ads_click_rounded,
                    color: VirooColors.warning, size: 24)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: VirooColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          fontFamily: 'Cairo')),
                  const SizedBox(height: 4),
                  Text('$price  │  🟢 $available',
                      style: const TextStyle(
                          color: VirooColors.textSecondary,
                          fontSize: 12,
                          fontFamily: 'Cairo')),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                _showBookingSheet(context, tier, themeColor);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: VirooColors.warning,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: const Text('📝 حجز',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                      color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showBiddingSheet(BuildContext context, int pageNumber,
      double currentBid, Color themeColor) {
    double bidAmount = currentBid + 50;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Container(
          decoration: BoxDecoration(
              color: VirooColors.surface,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(30)),
              border: Border.all(color: VirooColors.glassBorder, width: 1)),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 20),
              Text('🥇 مزاد الصفحة $pageNumber',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: VirooColors.textPrimary,
                      fontFamily: 'Cairo')),
              const SizedBox(height: 16),
              GlassContainer(
                padding: const EdgeInsets.all(16),
                borderRadius: BorderRadius.circular(16),
                child: Column(
                  children: [
                    const Text('أعلى عرض حالي',
                        style: TextStyle(
                            color: VirooColors.textSecondary,
                            fontSize: 12,
                            fontFamily: 'Cairo')),
                    const SizedBox(height: 4),
                    Text('$currentBid ج',
                        style: TextStyle(
                            color: themeColor,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Orbitron')),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () => setSheetState(() => bidAmount =
                        (bidAmount - 50)
                            .clamp(currentBid + 50, double.infinity)),
                    icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: VirooColors.glassDark),
                        child: const Icon(Icons.remove, color: Colors.white)),
                  ),
                  const SizedBox(width: 20),
                  Text('${bidAmount.toInt()} ج',
                      style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Orbitron')),
                  const SizedBox(width: 20),
                  IconButton(
                    onPressed: () => setSheetState(() => bidAmount += 50),
                    icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: VirooColors.amberPrimary),
                        child: const Icon(Icons.add, color: Colors.white)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text('الحد الأدنى للزيادة: 50 ج',
                  style: TextStyle(
                      color: VirooColors.textTertiary,
                      fontSize: 11,
                      fontFamily: 'Cairo')),
              const SizedBox(height: 20),
              GlowingButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('✅ تم تقديم عرضك بنجاح!',
                          style: TextStyle(fontFamily: 'Cairo')),
                      backgroundColor: VirooColors.success));
                },
                text: '✅ تأكيد المزايدة بـ ${bidAmount.toInt()} ج',
                backgroundColor: VirooColors.error,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  void _showBookingSheet(BuildContext context, int tier, Color themeColor) {
    String selectedDuration = '1_month';
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Container(
          decoration: BoxDecoration(
              color: VirooColors.surface,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(30)),
              border: Border.all(color: VirooColors.glassBorder, width: 1)),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 20),
              Text(
                  '📝 حجز إعلان - ${tier == 2 ? "الصفحات 6-10" : "الصفحات 11-20"}',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: VirooColors.textPrimary,
                      fontFamily: 'Cairo')),
              const SizedBox(height: 20),
              const Text('اختر المدة:',
                  style: TextStyle(
                      color: VirooColors.textSecondary, fontFamily: 'Cairo')),
              const SizedBox(height: 10),
              Wrap(spacing: 8, children: [
                _durationChip('5_days', '5 أيام', selectedDuration,
                    (v) => setSheetState(() => selectedDuration = v)),
                _durationChip('10_days', '10 أيام', selectedDuration,
                    (v) => setSheetState(() => selectedDuration = v)),
                _durationChip('1_month', 'شهر', selectedDuration,
                    (v) => setSheetState(() => selectedDuration = v)),
                _durationChip('3_months', '3 شهور', selectedDuration,
                    (v) => setSheetState(() => selectedDuration = v)),
              ]),
              const SizedBox(height: 20),
              GlowingButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('✅ تم الحجز بنجاح!',
                          style: TextStyle(fontFamily: 'Cairo')),
                      backgroundColor: VirooColors.success));
                },
                text: '✅ تأكيد الحجز',
                backgroundColor: VirooColors.warning,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _durationChip(
      String value, String label, String selected, Function(String) onSelect) {
    final isSelected = selected == value;
    return GestureDetector(
      onTap: () => onSelect(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
            color:
                isSelected ? VirooColors.amberPrimary : VirooColors.glassDark,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: isSelected
                    ? VirooColors.amberPrimary
                    : VirooColors.glassBorder)),
        child: Text(label,
            style: TextStyle(
                color: isSelected ? Colors.white : VirooColors.textSecondary,
                fontFamily: 'Cairo',
                fontSize: 12)),
      ),
    );
  }
}
