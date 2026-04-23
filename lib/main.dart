// lib/main.dart
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'firebase_options.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_widgets.dart';
import 'core/widgets/viroo_background.dart';
import 'core/services/storage_service.dart';
import 'core/services/auth_service.dart';
import 'core/services/notification_service.dart'; // 👈 أضفنا الإستيراد
import 'presentation/screens/onboarding/onboarding_screen.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/cart/presentation/screens/cart_screen.dart';
import 'core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print('✅ Firebase initialized successfully');

  // 👈 تهيئة الإشعارات
  await VirooNotificationService.init();
  print('🔔 Notification service initialized');
// 👇 تهيئة الإشعارات
  await VirooNotificationService.init();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VirooMall',
      debugShowCheckedModeBanner: false,
      theme: VirooTheme.darkTheme.copyWith(
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamily: 'Cairo'),
          displayMedium: TextStyle(fontFamily: 'Cairo'),
          displaySmall: TextStyle(fontFamily: 'Cairo'),
          headlineLarge: TextStyle(fontFamily: 'Cairo'),
          headlineMedium: TextStyle(fontFamily: 'Cairo'),
          headlineSmall: TextStyle(fontFamily: 'Cairo'),
          titleLarge: TextStyle(fontFamily: 'Cairo'),
          titleMedium: TextStyle(fontFamily: 'Cairo'),
          titleSmall: TextStyle(fontFamily: 'Cairo'),
          bodyLarge: TextStyle(fontFamily: 'Cairo'),
          bodyMedium: TextStyle(fontFamily: 'Cairo'),
          bodySmall: TextStyle(fontFamily: 'Cairo'),
          labelLarge: TextStyle(fontFamily: 'Cairo'),
          labelMedium: TextStyle(fontFamily: 'Cairo'),
          labelSmall: TextStyle(fontFamily: 'Cairo'),
        ),
      ),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/cart': (context) => const CartScreen(),
      },
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
      ),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
      ),
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 2), () async {
      await _navigateToNextScreen();
    });
  }

  Future<void> _navigateToNextScreen() async {
    if (!mounted) return;

    final biometricEnabled = await StorageService.isBiometricEnabled();
    final user = AuthService.currentUser;

    if (biometricEnabled && user == null) {
      final localAuth = LocalAuthentication();
      try {
        final authenticated = await localAuth.authenticate(
          localizedReason: 'استخدم بصمتك لتسجيل الدخول إلى VirooMall',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ),
        );

        if (authenticated) {
          final userData = await StorageService.getUserData();
          if (userData['phone'] != null && userData['phone']!.isNotEmpty) {
            Navigator.pushReplacementNamed(context, '/home');
            return;
          }
        }
      } catch (e) {}
    }

    final currentUser = AuthService.currentUser;

    if (currentUser != null) {
      await StorageService.setLoggedIn(
        userId: currentUser.uid,
        phone: currentUser.phoneNumber ?? '',
        name: currentUser.displayName,
      );
      Navigator.pushReplacementNamed(context, '/home');
      return;
    }

    final isLoggedIn = await StorageService.isLoggedIn();

    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/home');
      return;
    }

    final hasSeenOnboarding = await StorageService.isOnboardingSeen();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            hasSeenOnboarding ? const LoginScreen() : const OnboardingScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VirooBackground(
        showOrbs: true,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: VirooColors.primary
                            .withOpacity(0.1 * _glowAnimation.value),
                        border: Border.all(
                          color: VirooColors.primary
                              .withOpacity(0.5 + (0.5 * _glowAnimation.value)),
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: VirooColors.primary
                                .withOpacity(0.5 * _glowAnimation.value),
                            blurRadius: 40,
                            spreadRadius: 10,
                          ),
                          BoxShadow(
                            color: VirooColors.primary
                                .withOpacity(0.3 * _glowAnimation.value),
                            blurRadius: 80,
                            spreadRadius: 20,
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(Icons.shopping_bag_outlined,
                              size: 70, color: VirooColors.primary),
                          Positioned(
                              top: 35,
                              right: 30,
                              child: Icon(Icons.star,
                                  size: 20, color: VirooColors.primary)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: GlassContainer(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      child: Text('VirooMall',
                          style: TextStyle(
                              fontSize: 44,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                    color: VirooColors.primary.withOpacity(0.7),
                                    blurRadius: 30)
                              ])),
                    ),
                  ),
                  const SizedBox(height: 12),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: GlassContainer(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      child: Text('SHOP EVERYTHING',
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Orbitron',
                              color: VirooColors.primary.withOpacity(0.8),
                              letterSpacing: 8)),
                    ),
                  ),
                  const SizedBox(height: 60),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                VirooColors.primary),
                            strokeWidth: 2)),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
