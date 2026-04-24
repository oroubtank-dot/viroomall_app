import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_colors.dart';

/// =============================================
/// ⚙️ Settings Portal Button - بوابة الإعدادات السحرية
/// =============================================
///
/// تصميم Cyber-Glassy بتأثيرات كونية:
/// - زرار عائم زجاجي بحواف دائرية (Radius 15)
/// - ترس نيون أبيض ثلجي
/// - دوران 360° عند الضغط
/// - نبض برتقالي كل 5 ثواني
/// - Haptic Feedback (تكة هزاز)
/// - Split Reveal: الشاشة بتتقسم نصين بBlur عالي
/// - نقطة تنبيه برتقالية للإشعارات
/// =============================================
class SettingsPortalButton extends StatefulWidget {
  final VoidCallback onSettingsTap;

  const SettingsPortalButton({
    super.key,
    required this.onSettingsTap,
    this.hasNotification = false,
  });

  final bool hasNotification;

  @override
  State<SettingsPortalButton> createState() => _SettingsPortalButtonState();
}

class _SettingsPortalButtonState extends State<SettingsPortalButton>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _rotationController;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();

    // 🕐 نبض كل 5 ثواني
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // 🔄 دوران 360 درجة
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // بدء دورة النبض
    _startPulseCycle();
  }

  void _startPulseCycle() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        _pulseController.forward().then((_) {
          _pulseController.reverse().then((_) {
            _startPulseCycle();
          });
        });
      }
    });
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    HapticFeedback.mediumImpact(); // تكة هزاز
    _rotationController.forward(from: 0.0); // دوران الترس
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    widget.onSettingsTap(); // تنفيذ الإجراء الخارجي
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: Listenable.merge([_pulseController, _rotationController]),
        builder: (context, child) {
          return Transform.scale(
            // 👆 يصغر 10% عند الضغط
            scale: _isPressed ? 0.9 : 1.0,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // ✨ Glow خلفي دائري
                Positioned(
                  top: -6,
                  left: -6,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: VirooColors.amberPrimary
                              .withOpacity(0.3 * _pulseAnimation.value),
                          blurRadius: 18 + (10 * _pulseAnimation.value),
                          spreadRadius: 2 * _pulseAnimation.value,
                        ),
                      ],
                    ),
                  ),
                ),

                // 🧊 الجسم الزجاجي الرئيسي
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: VirooColors.glassDark,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: _pulseAnimation.value > 0.5
                              ? VirooColors.amberPrimary.withOpacity(0.6)
                              : VirooColors.glassBorder,
                          width: 1.5,
                        ),
                        // ظل داخلي (محفور في الزجاج)
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 4,
                            offset: const Offset(2, 2),
                          ),
                          BoxShadow(
                            color: Colors.white.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(-2, -2),
                          ),
                        ],
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.1),
                            Colors.white.withOpacity(0.02),
                          ],
                        ),
                      ),
                      child: Transform.rotate(
                        // 🔄 دوران الترس 360°
                        angle: _rotationController.value * 2 * pi,
                        child: const Icon(
                          Icons.settings_outlined,
                          color: VirooColors.warmWhite,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ),

                // 🔴 نقطة التنبيه البرتقالية
                if (widget.hasNotification)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: VirooColors.amberPrimary,
                        border: Border.all(
                          color: VirooColors.background,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// =============================================
/// 🌌 إعدادات الـ Split Reveal - شاشة الإعدادات المنبثقة
/// =============================================
class SettingsRevealOverlay extends StatefulWidget {
  final Widget background;
  final Widget settingsPanel;
  final bool isOpen;
  final VoidCallback onClose;

  const SettingsRevealOverlay({
    super.key,
    required this.background,
    required this.settingsPanel,
    required this.isOpen,
    required this.onClose,
  });

  @override
  State<SettingsRevealOverlay> createState() => _SettingsRevealOverlayState();
}

class _SettingsRevealOverlayState extends State<SettingsRevealOverlay>
    with TickerProviderStateMixin {
  late AnimationController _blurController;
  late Animation<double> _blurAnimation;

  @override
  void initState() {
    super.initState();
    _blurController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _blurAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _blurController, curve: Curves.easeInOut),
    );

    if (widget.isOpen) {
      _blurController.forward();
    }
  }

  @override
  void didUpdateWidget(SettingsRevealOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOpen && !oldWidget.isOpen) {
      _blurController.forward();
    } else if (!widget.isOpen && oldWidget.isOpen) {
      _blurController.reverse();
    }
  }

  @override
  void dispose() {
    _blurController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // الخلفية (الصفحة الرئيسية) - موجودة دايماً وتتفاعل
        widget.background,

        // طبقة الـ Blur والظل - بتظهر بس لما الإعدادات مفتوحة
        if (widget.isOpen || _blurAnimation.value > 0)
          AnimatedBuilder(
            animation: _blurAnimation,
            builder: (context, child) {
              if (_blurAnimation.value == 0) return const SizedBox.shrink();
              return Positioned.fill(
                child: GestureDetector(
                  onTap: widget.onClose,
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 15 * _blurAnimation.value,
                        sigmaY: 15 * _blurAnimation.value,
                      ),
                      child: Container(
                        color: Colors.black.withOpacity(
                          0.5 * _blurAnimation.value,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

        // لوحة الإعدادات (تنزلق من الجنب)
        if (widget.isOpen || _blurAnimation.value > 0)
          Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            child: AnimatedBuilder(
              animation: _blurAnimation,
              builder: (context, child) {
                if (_blurAnimation.value == 0) return const SizedBox.shrink();
                return Transform.translate(
                  offset: Offset(
                    50 * (1 - _blurAnimation.value),
                    0,
                  ),
                  child: Opacity(
                    opacity: _blurAnimation.value.clamp(0.0, 1.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: widget.settingsPanel,
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
