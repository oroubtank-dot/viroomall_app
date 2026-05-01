// lib/features/settings/presentation/screens/language_settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';
import '../../../../core/widgets/viroo_background.dart';
import '../../../../core/services/storage_service.dart';

class LanguageSettingsScreen extends StatefulWidget {
  const LanguageSettingsScreen({super.key});

  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  String _selectedLanguage = 'ar';

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final lang = await StorageService.getLanguage();
    setState(() => _selectedLanguage = lang);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VirooColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('🌐 اللغة',
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
        themeColor: VirooColors.success,
        child: ListView(
          padding: const EdgeInsets.all(20),
          physics: const BouncingScrollPhysics(),
          children: [
            _sectionTitle('اختر اللغة'),
            _languageCard('ar', '🇪🇬 العربية', 'Arabic'),
            _languageCard('en', '🇬🇧 English', 'الإنجليزية'),
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

  Widget _languageCard(String code, String label, String sublabel) {
    final isSelected = _selectedLanguage == code;
    return GestureDetector(
      onTap: () async {
        HapticFeedback.lightImpact();
        setState(() => _selectedLanguage = code);
        await StorageService.setLanguage(code);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ تم تغيير اللغة - أعد تشغيل التطبيق',
                style: TextStyle(fontFamily: 'Cairo')),
            backgroundColor: VirooColors.success,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? VirooColors.success.withAlpha(38)
              : VirooColors.glassDark,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? VirooColors.success : VirooColors.glassBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(label,
                style: TextStyle(
                    color: isSelected ? VirooColors.success : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Cairo')),
            const SizedBox(width: 10),
            Text(sublabel,
                style: const TextStyle(
                    color: VirooColors.textSecondary,
                    fontSize: 12,
                    fontFamily: 'Cairo')),
            const Spacer(),
            Icon(
              isSelected ? Icons.check_circle_rounded : Icons.circle_outlined,
              color:
                  isSelected ? VirooColors.success : VirooColors.textSecondary,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
