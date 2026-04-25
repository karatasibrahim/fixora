import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'app_card.dart';

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    this.color = AppColors.primary,
    this.trend,
    this.trendUp,
    this.onTap,
  });

  final String value;
  final String label;
  final IconData icon;
  final Color color;
  final String? trend;
  final bool? trendUp;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              if (trend != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      trendUp == true ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                      size: 14,
                      color: trendUp == true ? AppColors.success : AppColors.danger,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      trend!,
                      style: AppTextStyles.caption.copyWith(
                        color: trendUp == true ? AppColors.success : AppColors.danger,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(value, style: AppTextStyles.stat.copyWith(color: AppColors.textPrimary)),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.bodySm, maxLines: 2, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
