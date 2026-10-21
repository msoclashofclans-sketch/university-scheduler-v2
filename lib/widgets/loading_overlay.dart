import 'package:flutter/material.dart';
import '../utils/constants.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final String? message;
  final double? progress;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    this.message,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return const SizedBox.shrink();

    return Container(
      color: Colors.black.withValues(alpha: 0.6),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(28),
          constraints: const BoxConstraints(maxWidth: 320),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (progress != null)
                SizedBox(
                  width: 80,
                  height: 80,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 6,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: const AlwaysStoppedAnimation(
                          AppConstants.accentColor,
                        ),
                      ),
                      Text(
                        '${((progress ?? 0) * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.primaryColor,
                        ),
                      ),
                    ],
                  ),
                )
              else
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(
                    AppConstants.accentColor,
                  ),
                ),
              if (message != null) ...[
                const SizedBox(height: 20),
                Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.primaryColor,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}