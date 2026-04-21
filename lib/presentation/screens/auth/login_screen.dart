import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_widgets.dart';
import '../../../core/widgets/viroo_background.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/storage_service.dart';

// =============================================
// شاشة تسجيل الدخول
// =============================================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  String _formatPhoneNumber(String phone) {
    phone = phone.replaceAll(RegExp(r'\D'), '');
    if (phone.startsWith('0')) {
      return '+2$phone';
    }
    if (!phone.startsWith('+')) {
      return '+20$phone';
    }
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
    print('📱 Sending OTP to: $formattedPhone');

    await AuthService.sendOTP(
      phoneNumber: formattedPhone,
      onCodeSent: (verificationId) {
        setState(() => _isLoading = false);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPScreen(
              verificationId: verificationId,
              phone: formattedPhone,
            ),
          ),
        );
      },
      onError: (error) {
        setState(() {
          _isLoading = false;
          _errorMessage = error;
        });
        print('❌ Error: $error');
      },
    );
  }

  void _skipLogin() async {
    await StorageService.setLoggedIn(
      userId: 'guest_${DateTime.now().millisecondsSinceEpoch}',
      phone: 'ضيف',
      name: 'زائر',
    );

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VirooBackground(
        showOrbs: true,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 1),

                // أيقونة القفل الزجاجية
                TweenAnimationBuilder<double>(
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
                          child: Icon(
                            Icons.lock_person_rounded,
                            size: 80,
                            color: VirooColors.primary,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 50),

                // عنوان الترحيب
                const Text(
                  'أهلاً بك في VirooMall',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Cairo',
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                Text(
                  'سجل دخولك لبدء التجربة الأسطورية',
                  style: TextStyle(
                    fontSize: 16,
                    color: VirooColors.textSecondary,
                    fontFamily: 'Cairo',
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 50),

                // حقل رقم الهاتف (زجاجي)
                GlassContainer(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  borderRadius: BorderRadius.circular(16),
                  child: TextField(
                    controller: _phoneController,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Cairo',
                      fontSize: 16,
                    ),
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'رقم الهاتف (مثال: 01001234567)',
                      hintStyle: TextStyle(
                        color: VirooColors.textSecondary.withOpacity(0.5),
                        fontFamily: 'Cairo',
                      ),
                      prefixIcon: Icon(
                        Icons.phone_android,
                        color: VirooColors.primary,
                      ),
                      prefixText: '+20 ',
                      prefixStyle: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Cairo',
                      ),
                      border: InputBorder.none,
                      errorText: _errorMessage,
                      errorStyle: const TextStyle(
                        color: VirooColors.error,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // زر إرسال الكود
                GlowingButton(
                  onPressed: _sendOTP,
                  text: 'إرسال كود التحقق',
                  icon: Icons.arrow_forward_rounded,
                  isLoading: _isLoading,
                ),

                const SizedBox(height: 20),

                // روابط مساعدة
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'إنشاء حساب جديد',
                        style: TextStyle(
                          color: VirooColors.textSecondary,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 20,
                      color: VirooColors.glassBorder,
                    ),
                    TextButton(
                      onPressed: _skipLogin,
                      child: Text(
                        'تصفح كضيف',
                        style: TextStyle(
                          color: VirooColors.primary,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const Spacer(flex: 2),

                // نص الشروط والأحكام
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    'بالتسجيل، أنت توافق على الشروط والأحكام وسياسة الخصوصية',
                    style: TextStyle(
                      fontSize: 12,
                      color: VirooColors.textTertiary,
                      fontFamily: 'Cairo',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================
// شاشة OTP
// =============================================
class OTPScreen extends StatefulWidget {
  final String verificationId;
  final String phone;

  const OTPScreen({
    super.key,
    required this.verificationId,
    required this.phone,
  });

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _verifyOTP() async {
    final otp = _otpController.text.trim();

    if (otp.length != 6) {
      setState(() => _errorMessage = 'من فضلك أدخل 6 أرقام');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final user = await AuthService.verifyOTP(
      verificationId: widget.verificationId,
      smsCode: otp,
    );

    setState(() => _isLoading = false);

    if (user != null) {
      await StorageService.setLoggedIn(
        userId: user.uid,
        phone: user.phoneNumber ?? widget.phone,
        name: user.displayName ?? 'مستخدم VirooMall',
      );

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else {
      setState(() => _errorMessage = 'الكود غير صحيح، حاول مرة أخرى');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VirooBackground(
        showOrbs: true,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 1),
                GlassContainer(
                  padding: const EdgeInsets.all(30),
                  borderRadius: BorderRadius.circular(30),
                  child: Icon(
                    Icons.message_rounded,
                    size: 80,
                    color: VirooColors.primary,
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  'تأكيد رقم الهاتف',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'تم إرسال كود التحقق إلى ${widget.phone}',
                  style: TextStyle(
                    fontSize: 16,
                    color: VirooColors.textSecondary,
                    fontFamily: 'Cairo',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                GlassContainer(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  borderRadius: BorderRadius.circular(16),
                  child: TextField(
                    controller: _otpController,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Orbitron',
                      fontSize: 24,
                      letterSpacing: 8,
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: '______',
                      hintStyle: TextStyle(
                        color: VirooColors.textSecondary.withOpacity(0.3),
                        fontFamily: 'Orbitron',
                        fontSize: 24,
                        letterSpacing: 8,
                      ),
                      border: InputBorder.none,
                      counterText: '',
                      errorText: _errorMessage,
                      errorStyle: const TextStyle(
                        color: VirooColors.error,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                GlowingButton(
                  onPressed: _verifyOTP,
                  text: 'تأكيد',
                  icon: Icons.check_circle_rounded,
                  isLoading: _isLoading,
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
