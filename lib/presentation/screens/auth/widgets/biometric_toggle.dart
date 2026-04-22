// lib/presentation/screens/auth/widgets/biometric_toggle.dart
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/storage_service.dart';

class BiometricToggle extends StatelessWidget {
  final bool enabled;
  final Function(bool) onChanged;
  final Function(String) showSnackBar;

  const BiometricToggle(
      {super.key,
      required this.enabled,
      required this.onChanged,
      required this.showSnackBar});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('تفعيل الدخول بالبصمة',
            style: TextStyle(
                color: Colors.white70, fontFamily: 'Cairo', fontSize: 14)),
        const Spacer(),
        Switch(
          value: enabled,
          onChanged: (val) async {
            if (val) {
              final localAuth = LocalAuthentication();
              final canAuthenticate = await localAuth.canCheckBiometrics;
              if (canAuthenticate) {
                onChanged(true);
                await StorageService.setBiometricEnabled(true);
              } else {
                showSnackBar('جهازك لا يدعم البصمة');
              }
            } else {
              onChanged(false);
              await StorageService.setBiometricEnabled(false);
            }
          },
          activeColor: VirooColors.primary,
        ),
      ],
    );
  }
}
