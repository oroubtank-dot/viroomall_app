import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_widgets.dart';
import '../../../core/widgets/viroo_background.dart';
import '../../../core/services/storage_service.dart';
import '../auth/login_screen.dart';

/// =============================================
/// شاشة الـ Onboarding التعريفية
/// =============================================
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // أنيميشن للانتقال بين الصفحات
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  // =============================================
  // البيانات الخاصة بالأوضاع الأربعة
  // =============================================
  final List<Map<String, dynamic>> _onboardingData = [
    {
      "title": "🛍️ تسوق شامل",
      "desc":
          "اكتشف ملايين المنتجات الجديدة والمستعملة في مكان واحد بأسعار تنافسية.",
      "color": VirooColors.shopping,
      "icon": Icons.shopping_cart_outlined,
      "gradient": VirooGradients.shopping,
    },
    {
      "title": "🏪 تجارة الجملة",
      "desc":
          "اشتري بكميات كبيرة مباشرة من الموردين ووفر فلوسك مع أقوى عروض الجملة.",
      "color": VirooColors.wholesale,
      "icon": Icons.store_mall_directory_outlined,
      "gradient": VirooGradients.wholesale,
    },
    {
      "title": "♻️ سوق المستعمل",
      "desc":
          "بيع حاجتك القديمة أو اشتري لقطات مستعملة بحالة ممتازة وبأمان تام.",
      "color": VirooColors.used,
      "icon": Icons.recycling_outlined,
      "gradient": VirooGradients.used,
    },
    {
      "title": "🔥 فرز الإنتاج",
      "desc":
          "عروض تصفية حصرية ومنتجات فرز إنتاج بخصومات خيالية لا تقبل المنافسة.",
      "color": VirooColors.outlet,
      "icon": Icons.local_fire_department_outlined,
      "gradient": VirooGradients.outlet,
    },
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // =============================================
  // الانتقال للصفحة التالية
  // =============================================
  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _animationController.forward().then((_) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
        _animationController.reverse();
      });
    } else {
      _navigateToAuth();
    }
  }

  // =============================================
  // الانتقال لشاشة تسجيل الدخول وحفظ الحالة
  // =============================================
  void _navigateToAuth() async {
    // حفظ إن المستخدم شاف الـ Onboarding
    await StorageService.setOnboardingSeen();

    // الانتقال لشاشة تسجيل الدخول
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  // =============================================
  // تخطي الـ Onboarding
  // =============================================
  void _skipOnboarding() async {
    // حفظ إن المستخدم شاف الـ Onboarding
    await StorageService.setOnboardingSeen();

    // الانتقال لشاشة تسجيل الدخول
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VirooBackground(
        showOrbs: true,
        child: Stack(
          children: [
            // =============================================
            // PageView الرئيسي
            // =============================================
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
                _animationController.reset();
              },
              itemCount: _onboardingData.length,
              itemBuilder: (context, index) {
                return _buildPageItem(
                  _onboardingData[index],
                  index,
                );
              },
            ),

            // =============================================
            // زر "تخطي" في الأعلى
            // =============================================
            Positioned(
              top: 60,
              right: 30,
              child: GestureDetector(
                onTap: _skipOnboarding,
                child: GlassContainer(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  child: const Text(
                    'تخطي',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

            // =============================================
            // مؤشر النقاط + زر التالي
            // =============================================
            Positioned(
              bottom: 50,
              left: 30,
              right: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // النقاط التفاعلية
                  Row(
                    children: List.generate(
                      _onboardingData.length,
                      (index) => _buildDot(index),
                    ),
                  ),

                  // زر "التالي" أو "ابدأ الآن"
                  GestureDetector(
                    onTap: _nextPage,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      child: GlassContainer(
                        borderRadius: BorderRadius.circular(50),
                        padding: EdgeInsets.all(
                          _currentPage == _onboardingData.length - 1 ? 20 : 15,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_currentPage == _onboardingData.length - 1) ...[
                              const Text(
                                'ابدأ الآن',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                            Icon(
                              _currentPage == _onboardingData.length - 1
                                  ? Icons.done_all_rounded
                                  : Icons.arrow_forward_ios_rounded,
                              color: _onboardingData[_currentPage]['color'],
                              size: 28,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // =============================================
            // شريط التقدم العلوي (Progress Bar)
            // =============================================
            Positioned(
              top: 130,
              left: 30,
              right: 30,
              child: Row(
                children: List.generate(
                  _onboardingData.length,
                  (index) => Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      height: 3,
                      decoration: BoxDecoration(
                        color: index <= _currentPage
                            ? _onboardingData[_currentPage]['color']
                            : Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =============================================
  // بناء عنصر الصفحة الواحدة
  // =============================================
  Widget _buildPageItem(Map<String, dynamic> data, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),

          // =========================================
          // أيقونة الوضع مع تأثير زجاجي وتوهج
          // =========================================
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutBack,
            builder: (context, value, child) {
              return Transform.scale(
                scale: 0.7 + (0.3 * value),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: data['color'].withOpacity(0.4 * value),
                        blurRadius: 60,
                        spreadRadius: 20,
                      ),
                      BoxShadow(
                        color: data['color'].withOpacity(0.2 * value),
                        blurRadius: 100,
                        spreadRadius: 40,
                      ),
                    ],
                  ),
                  child: NeonBorderContainer(
                    borderColor: data['color'],
                    borderWidth: 2.5,
                    glowRadius: 25,
                    animated: true,
                    child: GlassContainer(
                      borderRadius: BorderRadius.circular(40),
                      padding: const EdgeInsets.all(35),
                      child: Icon(
                        data['icon'],
                        size: 100,
                        color: data['color'],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 60),

          // =========================================
          // العنوان
          // =========================================
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: GradientText(
                    text: data['title'],
                    gradient: data['gradient'],
                    style: const TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 15,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          // =========================================
          // الوصف
          // =========================================
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 30 * (1 - value)),
                  child: GlassContainer(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    child: Text(
                      data['desc'],
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                        fontFamily: 'Cairo',
                        height: 1.7,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            },
          ),

          const Spacer(flex: 3),
        ],
      ),
    );
  }

  // =============================================
  // بناء النقطة (Dot)
  // =============================================
  Widget _buildDot(int index) {
    final isActive = _currentPage == index;
    final color = _onboardingData[index]['color'] as Color;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 12),
      height: 12,
      width: isActive ? 40 : 12,
      decoration: BoxDecoration(
        color: isActive ? color : Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: color.withOpacity(0.6),
                  blurRadius: 15,
                  spreadRadius: 3,
                ),
              ]
            : null,
        border: isActive
            ? Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              )
            : null,
      ),
    );
  }
}
