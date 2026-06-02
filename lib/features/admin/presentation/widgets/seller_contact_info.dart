// lib/features/admin/presentation/widgets/seller_contact_info.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class SellerContactInfo extends StatelessWidget {
  final String phone;
  final String whatsapp;
  final Function(String) onPhoneChanged;
  final Function(String) onWhatsappChanged;

  const SellerContactInfo({
    super.key,
    required this.phone,
    required this.whatsapp,
    required this.onPhoneChanged,
    required this.onWhatsappChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: VirooColors.surface.withAlpha(51),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: VirooColors.amberPrimary.withAlpha(76)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('📞 بيانات التواصل',
              style: TextStyle(
                  color: VirooColors.amberPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: phone,
            keyboardType: TextInputType.phone,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'رقم الهاتف',
              prefixIcon: Icon(Icons.phone_android_rounded),
              labelStyle: TextStyle(color: VirooColors.textSecondary),
            ),
            onChanged: onPhoneChanged,
            validator: (v) =>
                v == null || v.isEmpty ? 'الرجاء إدخال رقم الهاتف' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: whatsapp,
            keyboardType: TextInputType.phone,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'رقم واتساب (اختياري)',
              prefixIcon: Icon(Icons.chat_bubble_outline_rounded),
              labelStyle: TextStyle(color: VirooColors.textSecondary),
            ),
            onChanged: onWhatsappChanged,
          ),
        ],
      ),
    );
  }
}
