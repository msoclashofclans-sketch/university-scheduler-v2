import 'package:flutter/material.dart';

class PageTransitions {
  static Route<T> slideFromRight<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (_, __, ___) => page,
      transitionDuration: const Duration(milliseconds: 350),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (_, animation, __, child) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(-1.0, 0.0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          ),
        );
        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }

  static Route<T> scaleIn<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (_, __, ___) => page,
      transitionDuration: const Duration(milliseconds: 400),
      transitionsBuilder: (_, animation, __, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutBack,
          ),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }
}