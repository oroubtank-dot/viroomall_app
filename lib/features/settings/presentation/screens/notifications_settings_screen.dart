// lib/features/settings/presentation/screens/notifications_settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';
import '../../../../core/widgets/viroo_background.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() =>
      _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState
    extends State<NotificationsSettingsScreen> {
  bool _promotions = true;
  bool _orders = true;
  bool _messages = true;
  bool _products = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VirooColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('🔔 الإشعارات',
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
        themeColor: VirooColors.amberPrimary,
        child: ListView(
          padding: const EdgeInsets.all(20),
          physics: const BouncingScrollPhysics(),
          children: [
            _sectionTitle('الإشعارات'),
            _switchTile('📢 العروض والتخفيضات', _promotions,
                (v) => setState(() => _promotions = v)),
            _switchTile('🛒 تحديثات الطلبات', _orders,
                (v) => setState(() => _orders = v)),
            _switchTile(
                '💬 الرسائل', _messages, (v) => setState(() => _messages = v)),
            _switchTile('📦 المنتجات الجديدة', _products,
                (v) => setState(() => _products = v)),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(title,
          style: const TextStyle(
              color: VirooColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo')),
    );
  }

  Widget _switchTile(String title, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        borderRadius: BorderRadius.circular(14),
        child: Row(
          children: [
            Expanded(
              child: Text(title,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 14, fontFamily: 'Cairo')),
            ),
            Switch(
              value: value,
              onChanged: (v) {
                HapticFeedback.lightImpact();
                onChanged(v);
              },
              activeColor: VirooColors.amberPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
