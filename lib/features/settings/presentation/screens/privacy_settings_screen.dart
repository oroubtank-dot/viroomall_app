// lib/features/settings/presentation/screens/privacy_settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';
import '../../../../core/widgets/viroo_background.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  bool _showPhone = true;
  bool _showLocation = true;
  bool _biometric = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VirooColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('🔒 الخصوصية والأمان',
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
        themeColor: VirooColors.info,
        child: ListView(
          padding: const EdgeInsets.all(20),
          physics: const BouncingScrollPhysics(),
          children: [
            _sectionTitle('معلوماتي'),
            _switchTile('📞 إظهار رقم الهاتف', _showPhone,
                (v) => setState(() => _showPhone = v)),
            _switchTile('📍 إظهار الموقع', _showLocation,
                (v) => setState(() => _showLocation = v)),
            const SizedBox(height: 20),
            _sectionTitle('الأمان'),
            _switchTile('👆 بصمة الإصبع', _biometric,
                (v) => setState(() => _biometric = v)),
            const SizedBox(height: 8),
            GlassContainer(
              padding: const EdgeInsets.all(14),
              borderRadius: BorderRadius.circular(14),
              child: const Text(
                'ℹ️ بصمة الإصبع بتخليك تدخل للتطبيق بسرعة وأمان من غير ما تكتب كلمة سر',
                style: TextStyle(
                    color: VirooColors.textSecondary,
                    fontSize: 12,
                    fontFamily: 'Cairo'),
              ),
            ),
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
              activeColor: VirooColors.info,
            ),
          ],
        ),
      ),
    );
  }
}
