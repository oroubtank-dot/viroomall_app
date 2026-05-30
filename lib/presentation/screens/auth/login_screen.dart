// lib/presentation/screens/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_widgets.dart';
import '../../../core/widgets/viroo_background.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/storage_service.dart';
import 'otp_screen.dart';
import 'widgets/biometric_toggle.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  bool _biometricEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadBiometricSetting();
  }

  Future<void> _loadBiometricSetting() async {
    final enabled = await StorageService.isBiometricEnabled();
    if (mounted) setState(() => _biometricEnabled = enabled);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  String _formatPhoneNumber(String phone) {
    phone = phone.replaceAll(RegExp(r'\D'), '');
    if (phone.startsWith('0')) return '+2$phone';
    if (!phone.startsWith('+')) return '+20$phone';
    return phone;
  }

  Future<void> _sendOTP() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty || phone.length < 10) {
      setState(() => _errorMessage = 'من فضلك أدخل رقم هاتف صحيح');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final formattedPhone = _formatPhoneNumber(phone);

    await AuthService.sendOTP(
      phoneNumber: formattedPhone,
      onCodeSent: (verificationId) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
          _errorMessage = null;
        });
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPScreen(
                  verificationId: verificationId, phone: formattedPhone),
            ));
      },
      onError: (error) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
          _errorMessage = error;
        });
        _showSnackBar(error);
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(message, style: const TextStyle(fontFamily: 'Cairo')),
          backgroundColor: VirooColors.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: VirooBackground(
        showOrbs: true,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(flex: 1),
                          _buildLogo(),
                          const SizedBox(height: 50),
                          const Text('أهلاً بك في VirooMall',
                              style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Cairo',
                                  shadows: [
                                    Shadow(
                                        color: Colors.black26,
                                        blurRadius: 10,
                                        offset: Offset(0, 2))
                                  ]),
                              textAlign: TextAlign.center),
                          const SizedBox(height: 12),
                          const Text('سجل دخولك لبدء التجربة الأسطورية',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: VirooColors.textSecondary,
                                  fontFamily: 'Cairo'),
                              textAlign: TextAlign.center),
                          const SizedBox(height: 50),
                          _buildPhoneField(),
                          const SizedBox(height: 20),
                          BiometricToggle(
                              enabled: _biometricEnabled,
                              onChanged: (val) =>
                                  setState(() => _biometricEnabled = val),
                              showSnackBar: _showSnackBar),
                          const SizedBox(height: 20),
                          GlowingButton(
                              onPressed: _sendOTP,
                              text: 'إرسال كود التحقق',
                              icon: Icons.arrow_forward_rounded,
                              isLoading: _isLoading,
                              height: 60,
                              width: double.infinity),
                          const SizedBox(height: 20),
                          _buildLinks(),
                          const Spacer(flex: 1),
                          _buildTerms(),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: NeonBorderContainer(
            borderColor: VirooColors.primary,
            glowRadius: 30,
            animated: true,
            child: GlassContainer(
                padding: const EdgeInsets.all(30),
                borderRadius: BorderRadius.circular(30),
                child: const Icon(Icons.lock_person_rounded,
                    size: 80, color: VirooColors.primary)),
          ),
        );
      },
    );
  }

  Widget _buildPhoneField() {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      borderRadius: BorderRadius.circular(16),
      child: TextField(
        controller: _phoneController,
        style: const TextStyle(
            color: Colors.white, fontFamily: 'Cairo', fontSize: 16),
        keyboardType: TextInputType.phone,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          hintText: 'رقم الهاتف (مثال: 01001234567)',
          hintStyle: TextStyle(
              color: VirooColors.textSecondary.withOpacity(0.5),
              fontFamily: 'Cairo'),
          prefixIcon: const Icon(Icons.phone_android, color: VirooColors.primary),
          prefixText: '+20 ',
          prefixStyle:
              const TextStyle(color: Colors.white, fontFamily: 'Cairo'),
          border: InputBorder.none,
          errorText: _errorMessage,
          errorStyle:
              const TextStyle(color: VirooColors.error, fontFamily: 'Cairo'),
        ),
      ),
    );
  }

  Widget _buildLinks() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: _sendOTP,
          child: const Text('إنشاء حساب جديد',
              style: TextStyle(
                  color: VirooColors.textSecondary, fontFamily: 'Cairo')),
        ),
        // 👇 تم حذف "تصفح كضيف"
      ],
    );
  }

  Widget _buildTerms() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 20, top: 20),
      child: Text('بالتسجيل، أنت توافق على الشروط والأحكام وسياسة الخصوصية',
          style: TextStyle(
              fontSize: 12,
              color: VirooColors.textTertiary,
              fontFamily: 'Cairo'),
          textAlign: TextAlign.center),
    );
  }
}
