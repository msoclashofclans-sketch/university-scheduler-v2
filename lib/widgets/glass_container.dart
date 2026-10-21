import 'dart:ui';
import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double blur;
  final double opacity;
  final BorderRadius? borderRadius;

  const GlassContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.blur = 12,
    this.opacity = 0.15,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(20);

    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: opacity),
            borderRadius: radius,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}