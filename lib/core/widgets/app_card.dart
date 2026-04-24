import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_shadows.dart';
import '../constants/app_spacing.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    this.child,
    this.padding,
    this.onTap,
    this.color,
    this.borderRadius,
    this.shadows,
    this.border,
  });

  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? color;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? shadows;
  final Border? border;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color ?? AppColors.surface,
        borderRadius: borderRadius ?? AppRadius.lgAll,
        boxShadow: shadows ?? AppShadows.card,
        border: border ?? Border.all(color: AppColors.border, width: 0.5),
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? AppRadius.lgAll,
        child: onTap != null
            ? Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  splashColor: AppColors.primary.withValues(alpha: 0.06),
                  highlightColor: AppColors.primary.withValues(alpha: 0.04),
                  child: Padding(
                    padding: padding ?? const EdgeInsets.all(AppSpacing.cardPadding),
                    child: child,
                  ),
                ),
              )
            : Padding(
                padding: padding ?? const EdgeInsets.all(AppSpacing.cardPadding),
                child: child,
              ),
      ),
    );
  }
}
