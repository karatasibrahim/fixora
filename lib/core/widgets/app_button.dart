import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../theme/app_text_styles.dart';

enum AppButtonVariant { primary, secondary, outline, ghost, danger }
enum AppButtonSize { sm, md, lg }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.md,
    this.icon,
    this.iconTrailing = false,
    this.isLoading = false,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? icon;
  final bool iconTrailing;
  final bool isLoading;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final (bgColor, fgColor, side) = _resolveStyle();
    final (hPad, vPad, textStyle) = _resolveSize();

    Widget content = isLoading
        ? SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(fgColor),
            ),
          )
        : Row(
            mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null && !iconTrailing) ...[
                Icon(icon, size: _iconSize, color: fgColor),
                const SizedBox(width: 8),
              ],
              Text(label, style: textStyle.copyWith(color: fgColor)),
              if (icon != null && iconTrailing) ...[
                const SizedBox(width: 8),
                Icon(icon, size: _iconSize, color: fgColor),
              ],
            ],
          );

    return SizedBox(
      width: expand ? double.infinity : null,
      child: MaterialButton(
        onPressed: isLoading ? null : onPressed,
        color: bgColor,
        splashColor: fgColor.withValues(alpha: 0.1),
        highlightColor: fgColor.withValues(alpha: 0.06),
        elevation: 0,
        hoverElevation: 0,
        focusElevation: 0,
        highlightElevation: 0,
        disabledColor: AppColors.border,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.mdAll,
          side: side,
        ),
        padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
        child: content,
      ),
    );
  }

  (Color, Color, BorderSide) _resolveStyle() {
    return switch (variant) {
      AppButtonVariant.primary => (
          AppColors.primary,
          Colors.white,
          BorderSide.none,
        ),
      AppButtonVariant.secondary => (
          AppColors.primaryLight,
          AppColors.primary,
          BorderSide.none,
        ),
      AppButtonVariant.outline => (
          Colors.transparent,
          AppColors.primary,
          const BorderSide(color: AppColors.border, width: 1.5),
        ),
      AppButtonVariant.ghost => (
          Colors.transparent,
          AppColors.textSecondary,
          BorderSide.none,
        ),
      AppButtonVariant.danger => (
          AppColors.danger,
          Colors.white,
          BorderSide.none,
        ),
    };
  }

  (double, double, TextStyle) _resolveSize() {
    return switch (size) {
      AppButtonSize.sm => (14.0, 9.0, AppTextStyles.buttonSm),
      AppButtonSize.md => (20.0, 13.0, AppTextStyles.button),
      AppButtonSize.lg => (24.0, 16.0, AppTextStyles.button),
    };
  }

  double get _iconSize => switch (size) {
        AppButtonSize.sm => 14,
        AppButtonSize.md => 16,
        AppButtonSize.lg => 18,
      };
}
