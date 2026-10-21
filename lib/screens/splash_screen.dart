import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/constants.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const HomeScreen(),
        transitionDuration: const Duration(milliseconds: 600),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppConstants.primaryGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.school_rounded,
                  size: 80,
                  color: Colors.white,
                ),
              )
                  .animate()
                  .scale(duration: 800.ms, curve: Curves.easeOutBack)
                  .then()
                  .shimmer(duration: 1500.ms),
              const SizedBox(height: 32),
              const Text(
                'سامانه مدیریت کلاس‌ها',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              )
                  .animate()
                  .fadeIn(delay: 400.ms, duration: 600.ms)
                  .slideY(begin: 0.3, end: 0),
              const SizedBox(height: 8),
              Text(
                'حضور و غیاب اساتید',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              )
                  .animate()
                  .fadeIn(delay: 700.ms, duration: 600.ms),
              const SizedBox(height: 60),
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(
                    Colors.white.withValues(alpha: 0.8),
                  ),
                  strokeWidth: 3,
                ),
              ).animate().fadeIn(delay: 1000.ms),
            ],
          ),
        ),
      ),
    );
  }
}