// lib/features/home/presentation/widgets/mode_selector.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/product_type.dart';
import '../providers/home_provider.dart';

class ModeSelector extends ConsumerWidget {
  final List<ProductType> modes;
  final ProductType selectedMode;

  const ModeSelector({
    super.key,
    required this.modes,
    required this.selectedMode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: modes.map((mode) {
          final isSelected = selectedMode == mode;
          return _NeonCircle(
            mode: mode,
            isSelected: isSelected,
            onTap: () {
              ref.read(shopModeProvider.notifier).state = mode;
            },
          );
        }).toList(),
      ),
    );
  }
}

class _NeonCircle extends StatefulWidget {
  final ProductType mode;
  final bool isSelected;
  final VoidCallback onTap;

  const _NeonCircle({
    required this.mode,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_NeonCircle> createState() => _NeonCircleState();
}

class _NeonCircleState extends State<_NeonCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.isSelected) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(_NeonCircle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.isSelected && oldWidget.isSelected) {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.mode.color;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.isSelected ? _pulseAnimation.value : 1.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // الدايرة الخارجية مع Neon Glow
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.isSelected
                        ? color.withValues(alpha: 0.25)
                        : Colors.transparent,
                    border: Border.all(
                      color: widget.isSelected
                          ? color.withValues(alpha: 0.8)
                          : Colors.white.withValues(alpha: 0.2),
                      width: widget.isSelected ? 2.5 : 1.5,
                    ),
                    boxShadow: widget.isSelected
                        ? [
                            BoxShadow(
                              color: color.withValues(alpha: 0.6),
                              blurRadius: 20,
                              spreadRadius: 4,
                            ),
                            BoxShadow(
                              color: color.withValues(alpha: 0.3),
                              blurRadius: 40,
                              spreadRadius: 8,
                            ),
                          ]
                        : [],
                  ),
                  child: Center(
                    child: Text(
                      _getIcon(widget.mode),
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // اسم الوضع
                Text(
                  _getShortName(widget.mode),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight:
                        widget.isSelected ? FontWeight.bold : FontWeight.w500,
                    color: widget.isSelected
                        ? color
                        : Colors.white.withValues(alpha: 0.6),
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getIcon(ProductType type) {
    switch (type) {
      case ProductType.shopping:
        return '🛍️';
      case ProductType.wholesale:
        return '📦';
      case ProductType.used:
        return '🔄';
      case ProductType.outlet:
        return '🏷️';
    }
  }

  String _getShortName(ProductType type) {
    switch (type) {
      case ProductType.shopping:
        return 'تسوق';
      case ProductType.wholesale:
        return 'جملة';
      case ProductType.used:
        return 'مستعمل';
      case ProductType.outlet:
        return 'عروض';
    }
  }
}
