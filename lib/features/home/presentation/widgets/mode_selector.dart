// lib/features/home/presentation/widgets/mode_selector.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';
import '../providers/home_provider.dart';

class ModeSelector extends ConsumerWidget {
  final List<Map<String, dynamic>> modes;
  final ShopMode selectedMode;

  const ModeSelector({
    super.key,
    required this.modes,
    required this.selectedMode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: modes.map((mode) {
          final isSelected = selectedMode == mode['mode'];
          return Expanded(
            child: _ModeCard(
              mode: mode,
              isSelected: isSelected,
              onTap: () {
                // 👈 السحر: تغيير الوضع المختار
                ref.read(shopModeProvider.notifier).state = mode['mode'];
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  final Map<String, dynamic> mode;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeCard({
    required this.mode,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: GlassContainer(
          padding: const EdgeInsets.symmetric(vertical: 12),
          borderRadius: BorderRadius.circular(16),
          backgroundColor: isSelected
              ? mode['color'].withOpacity(0.15)
              : Colors.white.withOpacity(0.03),
          child: Column(
            children: [
              Text(
                mode['icon'],
                style: TextStyle(
                  fontSize: 24,
                  shadows: isSelected
                      ? [
                          Shadow(
                            color: mode['color'].withOpacity(0.5),
                            blurRadius: 10,
                          ),
                        ]
                      : null,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                mode['title'],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? mode['color'] : Colors.white70,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
