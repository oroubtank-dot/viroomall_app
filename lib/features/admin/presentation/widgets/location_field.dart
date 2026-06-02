// lib/features/admin/presentation/widgets/location_field.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class LocationField extends StatelessWidget {
  final String location;
  final Function(String) onLocationChanged;

  const LocationField({
    super.key,
    required this.location,
    required this.onLocationChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: location,
      style: const TextStyle(color: Colors.white),
      decoration: const InputDecoration(
        labelText: 'الموقع (المدينة/المحافظة)',
        hintText: 'مثال: القاهرة',
        labelStyle: TextStyle(color: VirooColors.textSecondary),
      ),
      onChanged: onLocationChanged,
      validator: (v) => v == null || v.isEmpty ? 'الرجاء إدخال الموقع' : null,
    );
  }
}
