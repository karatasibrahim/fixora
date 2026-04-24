import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../theme/app_text_styles.dart';

enum BadgeVariant { primary, success, warning, danger, neutral }

class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.label,
    this.variant = BadgeVariant.neutral,
    this.dot = false,
  });

  final String label;
  final BadgeVariant variant;
  final bool dot;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = _resolveColors();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: AppRadius.fullAll),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: fg, shape: BoxShape.circle),
            ),
            const SizedBox(width: 5),
          ],
          Text(label, style: AppTextStyles.label.copyWith(color: fg)),
        ],
      ),
    );
  }

  (Color, Color) _resolveColors() => switch (variant) {
        BadgeVariant.primary => (AppColors.primaryLight, AppColors.primary),
        BadgeVariant.success => (AppColors.successLight, AppColors.success),
        BadgeVariant.warning => (AppColors.warningLight, Color(0xFFB45309)),
        BadgeVariant.danger => (AppColors.dangerLight, AppColors.danger),
        BadgeVariant.neutral => (AppColors.surfaceVariant, AppColors.textSecondary),
      };
}
