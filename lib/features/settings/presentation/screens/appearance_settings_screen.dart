// lib/features/settings/presentation/screens/appearance_settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';
import '../../../../core/widgets/viroo_background.dart';
import '../../../../core/services/storage_service.dart';

class AppearanceSettingsScreen extends StatefulWidget {
  const AppearanceSettingsScreen({super.key});

  @override
  State<AppearanceSettingsScreen> createState() =>
      _AppearanceSettingsScreenState();
}

class _AppearanceSettingsScreenState extends State<AppearanceSettingsScreen> {
  bool _isDarkMode = true;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final isDark = await StorageService.isDarkMode();
    setState(() => _isDarkMode = isDark);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VirooColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('🎨 تخصيص المظهر',
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
        themeColor: VirooColors.purpleGlow,
        child: ListView(
          padding: const EdgeInsets.all(20),
          physics: const BouncingScrollPhysics(),
          children: [
            _sectionTitle('المظهر'),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GlassContainer(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                borderRadius: BorderRadius.circular(14),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text('🌙 الوضع الليلي',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Cairo')),
                    ),
                    Switch(
                      value: _isDarkMode,
                      onChanged: (v) async {
                        HapticFeedback.lightImpact();
                        setState(() => _isDarkMode = v);
                        await StorageService.setDarkMode(v);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                '✅ تم تغيير المظهر - أعد تشغيل التطبيق',
                                style: TextStyle(fontFamily: 'Cairo')),
                            backgroundColor: VirooColors.success,
                          ),
                        );
                      },
                      activeColor: VirooColors.purpleGlow,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            GlassContainer(
              padding: const EdgeInsets.all(14),
              borderRadius: BorderRadius.circular(14),
              child: const Text(
                'ℹ️ التطبيق يدعم الوضع الليلي فقط حالياً. الوضع الفاتح قريباً.',
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
}
