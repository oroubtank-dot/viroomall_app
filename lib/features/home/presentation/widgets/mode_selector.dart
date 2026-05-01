// lib/features/home/presentation/widgets/mode_selector.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: modes.map((mode) {
          final modeEnum = mode['mode'] as ShopMode;
          final isSelected = selectedMode == modeEnum;
          final color = mode['color'] as Color;
          final title = mode['title'] as String;
          final icon = mode['icon'] as String;

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: _ModeCard(
                icon: icon,
                title: title,
                color: color,
                isSelected: isSelected,
                onTap: () {
                  HapticFeedback.lightImpact();
                  ref.read(shopModeProvider.notifier).state = modeEnum;
                },
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ModeCard extends StatefulWidget {
  final String icon;
  final String title;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_ModeCard> createState() => _ModeCardState();
}

class _ModeCardState extends State<_ModeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) => _animController.forward();
  void _onTapUp(TapUpDetails details) => _animController.reverse();
  void _onTapCancel() => _animController.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnim.value, child: child);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              decoration: BoxDecoration(
                color: widget.isSelected
                    ? widget.color.withAlpha(38)
                    : VirooColors.glassDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: widget.isSelected
                      ? widget.color.withAlpha(178)
                      : VirooColors.glassBorder,
                  width: widget.isSelected ? 1.8 : 1,
                ),
                gradient: widget.isSelected
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          widget.color.withAlpha(51),
                          widget.color.withAlpha(12),
                        ],
                      )
                    : null,
                boxShadow: widget.isSelected
                    ? [
                        BoxShadow(
                          color: widget.color.withAlpha(76),
                          blurRadius: 15,
                          spreadRadius: -2,
                        ),
                        BoxShadow(
                          color: widget.color.withAlpha(38),
                          blurRadius: 25,
                          spreadRadius: -4,
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // الأيقونة
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.isSelected
                          ? widget.color.withAlpha(38)
                          : widget.color.withAlpha(12),
                      border: Border.all(
                        color: widget.isSelected
                            ? widget.color.withAlpha(178)
                            : widget.color.withAlpha(51),
                        width: 1.2,
                      ),
                      boxShadow: widget.isSelected
                          ? [
                              BoxShadow(
                                color: widget.color.withAlpha(76),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        widget.icon,
                        style: TextStyle(
                          fontSize: 20,
                          color: widget.isSelected
                              ? widget.color
                              : widget.color.withAlpha(178),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // النص
                  Text(
                    widget.title,
                    style: TextStyle(
                      color: widget.isSelected
                          ? Colors.white
                          : VirooColors.textSecondary,
                      fontSize: 12,
                      fontWeight:
                          widget.isSelected ? FontWeight.bold : FontWeight.w500,
                      fontFamily: 'Cairo',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  // المؤشر
                  Container(
                    width: widget.isSelected ? 20 : 0,
                    height: 3,
                    decoration: BoxDecoration(
                      color: widget.color,
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: widget.isSelected
                          ? [
                              BoxShadow(
                                color: widget.color.withAlpha(153),
                                blurRadius: 6,
                                spreadRadius: 1,
                              ),
                            ]
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
