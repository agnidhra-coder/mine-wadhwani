import 'package:flutter/material.dart';
import 'package:mine_wadhwani/core/theme/app_colors.dart';
import 'package:mine_wadhwani/core/theme/app_text_styles.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryContainer],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.terrain_rounded,
              size: 80,
              color: AppColors.onPrimary.withValues(alpha: 0.9),
            ),
            const SizedBox(height: 24),
            Text(
              'Wadhwani',
              style: AppTextStyles.headlineLarge.copyWith(
                color: AppColors.onPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Mining Management System',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.onPrimary.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
