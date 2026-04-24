// lib/presentation/screens/auth/widgets/login_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';
import '../../../../core/services/auth_service.dart';
import '../otp_screen.dart';

class LoginBottomSheet extends StatefulWidget {
  final VoidCallback? onLoginSuccess;

  const LoginBottomSheet({super.key, this.onLoginSuccess});

  @override
  State<LoginBottomSheet> createState() => _LoginBottomSheetState();
}

class _LoginBottomSheetState extends State<LoginBottomSheet> {
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
        setState(() => _isLoading = false);

        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPScreen(
              verificationId: verificationId,
              phone: formattedPhone,
              onLoginSuccess: widget.onLoginSuccess,
            ),
          ),
        );
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
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: VirooColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 50,
            height: 5,
            decoration: BoxDecoration(
                color: Colors.white24, borderRadius: BorderRadius.circular(10)),
          ),
          const SizedBox(height: 20),
          GlassContainer(
            padding: const EdgeInsets.all(25),
            borderRadius: BorderRadius.circular(30),
            child: const Icon(Icons.lock_person_rounded,
                size: 60, color: VirooColors.primary),
          ),
          const SizedBox(height: 20),
          const Text('تسجيل الدخول للمتابعة',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Cairo')),
          const SizedBox(height: 8),
          const Text('سجل دخولك عشان تقدر تشتري وتتواصل مع البائعين',
              style: TextStyle(
                  fontSize: 14,
                  color: VirooColors.textSecondary,
                  fontFamily: 'Cairo'),
              textAlign: TextAlign.center),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GlassContainer(
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
                  prefixIcon:
                      const Icon(Icons.phone_android, color: VirooColors.primary),
                  prefixText: '+20 ',
                  prefixStyle:
                      const TextStyle(color: Colors.white, fontFamily: 'Cairo'),
                  border: InputBorder.none,
                  errorText: _errorMessage,
                  errorStyle: const TextStyle(
                      color: VirooColors.error, fontFamily: 'Cairo'),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GlowingButton(
              onPressed: _sendOTP,
              text: 'إرسال كود التحقق',
              icon: Icons.arrow_forward_rounded,
              isLoading: _isLoading,
              height: 55,
              width: double.infinity,
            ),
          ),
          const SizedBox(height: 10),
          // 👇 تم حذف "تصفح كضيف"
        ],
      ),
    );
  }
}
