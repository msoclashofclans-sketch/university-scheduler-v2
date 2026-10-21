import 'package:flutter/material.dart';

class GradientCard extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final bool showGlow;

  const GradientCard({
    super.key,
    required this.child,
    required this.gradient,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.width,
    this.height,
    this.showGlow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: showGlow
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          splashColor: Colors.white.withValues(alpha: 0.15),
          highlightColor: Colors.white.withValues(alpha: 0.05),
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}