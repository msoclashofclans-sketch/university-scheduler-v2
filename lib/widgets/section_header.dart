import 'package:flutter/material.dart';
import '../utils/constants.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Widget? trailing;

  const SectionHeader({
    super.key,
    required this.title,
    this.icon,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppConstants.accentColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppConstants.accentColor,
                size: 16,
              ),
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppConstants.primaryColor,
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}