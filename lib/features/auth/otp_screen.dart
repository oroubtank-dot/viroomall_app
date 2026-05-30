// lib/presentation/screens/auth/otp_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_widgets.dart';
import '../../../core/widgets/viroo_background.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/storage_service.dart';

class OTPScreen extends StatefulWidget {
  final String verificationId;
  final String phone;
  final VoidCallback? onLoginSuccess;

  const OTPScreen({
    super.key,
    required this.verificationId,
    required this.phone,
    this.onLoginSuccess,
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
        verificationId: widget.verificationId, smsCode: otp);
    setState(() => _isLoading = false);

    if (user != null) {
      await StorageService.setLoggedIn(
          userId: user.uid,
          phone: user.phoneNumber ?? widget.phone,
          name: user.displayName ?? 'مستخدم VirooMall');
      if (mounted) {
        if (widget.onLoginSuccess != null) {
          Navigator.popUntil(context, (route) => route.isFirst);
          widget.onLoginSuccess!();
        } else {
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    } else {
      setState(() => _errorMessage = 'الكود غير صحيح، حاول مرة أخرى');
    }
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
                          GlassContainer(
                              padding: const EdgeInsets.all(30),
                              borderRadius: BorderRadius.circular(30),
                              child: const Icon(Icons.message_rounded,
                                  size: 80, color: VirooColors.primary)),
                          const SizedBox(height: 40),
                          const Text('تأكيد رقم الهاتف',
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Cairo')),
                          const SizedBox(height: 12),
                          Text('تم إرسال كود التحقق إلى ${widget.phone}',
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: VirooColors.textSecondary,
                                  fontFamily: 'Cairo'),
                              textAlign: TextAlign.center),
                          const SizedBox(height: 40),
                          GlassContainer(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 4),
                            borderRadius: BorderRadius.circular(16),
                            child: TextField(
                              controller: _otpController,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Orbitron',
                                  fontSize: 24,
                                  letterSpacing: 8),
                              keyboardType: TextInputType.number,
                              maxLength: 6,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                hintText: '______',
                                hintStyle: TextStyle(
                                    color: VirooColors.textSecondary
                                        .withOpacity(0.3),
                                    fontFamily: 'Orbitron',
                                    fontSize: 24,
                                    letterSpacing: 8),
                                border: InputBorder.none,
                                counterText: '',
                                errorText: _errorMessage,
                                errorStyle: const TextStyle(
                                    color: VirooColors.error,
                                    fontFamily: 'Cairo'),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          GlowingButton(
                              onPressed: _verifyOTP,
                              text: 'تأكيد',
                              icon: Icons.check_circle_rounded,
                              isLoading: _isLoading,
                              height: 60,
                              width: double.infinity),
                          const Spacer(flex: 2),
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
}
