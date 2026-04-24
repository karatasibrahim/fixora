import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/locale/locale_notifier.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../l10n/app_localizations.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final top = MediaQuery.of(context).padding.top;

    final stats = [
      (l10n.statMachinesLabel, '48'),
      (l10n.statFailuresLabel, '127'),
      (l10n.statAvgResponseLabel, '1.4s'),
    ];

    final settings = [
      (
        Icons.notifications_outlined,
        l10n.settingNotifications,
        l10n.settingNotificationsSubtitle,
        const Color(0xFF2563EB),
        false,
      ),
      (
        Icons.language_rounded,
        l10n.settingLanguage,
        l10n.settingLanguageCurrent,
        const Color(0xFF16A34A),
        true, // triggers language picker
      ),
      (
        Icons.dark_mode_outlined,
        l10n.settingAppearance,
        l10n.settingAppearanceSubtitle,
        const Color(0xFF475569),
        false,
      ),
      (
        Icons.security_rounded,
        l10n.settingSecurity,
        l10n.settingSecuritySubtitle,
        const Color(0xFFF59E0B),
        false,
      ),
      (
        Icons.download_rounded,
        l10n.settingExportData,
        l10n.settingExportDataSubtitle,
        const Color(0xFF2563EB),
        false,
      ),
      (
        Icons.help_outline_rounded,
        l10n.settingHelpSupport,
        l10n.settingHelpSupportSubtitle,
        const Color(0xFF475569),
        false,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildHeader(context, l10n, top),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.sm),
                _buildStats(stats),
                const SizedBox(height: AppSpacing.sectionGap),
                _buildSettingsSection(context, l10n, settings),
                const SizedBox(height: AppSpacing.itemGap),
                _buildLogout(context, l10n),
                const SizedBox(height: AppSpacing.huge),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n, double top) {
    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontal,
        top + 16,
        AppSpacing.pageHorizontal,
        AppSpacing.xl,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.pageProfile, style: AppTextStyles.h2),
              AppIconButton(
                icon: Icons.edit_outlined,
                onTap: () {},
                tooltip: l10n.tooltipEditProfile,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: AppRadius.fullAll,
                ),
                alignment: Alignment.center,
                child: const Text(
                  'İK',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'İbrahim Karataş',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(l10n.jobTitle, style: AppTextStyles.bodySm),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 12, color: AppColors.textTertiary),
                        const SizedBox(width: 3),
                        const Text(
                          'İstanbul, TR',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            color: AppColors.textTertiary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        AppBadge(label: l10n.rankSenior, variant: BadgeVariant.primary),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStats(List<(String, String)> stats) {
    return AppCard(
      child: Row(
        children: stats.asMap().entries.map((entry) {
          final i = entry.key;
          final (label, value) = entry.value;
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(value, style: AppTextStyles.stat),
                      const SizedBox(height: 4),
                      Text(label, style: AppTextStyles.caption, textAlign: TextAlign.center),
                    ],
                  ),
                ),
                if (i < stats.length - 1)
                  Container(width: 1, height: 40, color: AppColors.divider),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSettingsSection(
    BuildContext context,
    AppLocalizations l10n,
    List<(IconData, String, String, Color, bool)> settings,
  ) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: settings.asMap().entries.map((entry) {
          final i = entry.key;
          final (icon, label, subtitle, color, isLanguage) = entry.value;

          return Column(
            children: [
              ListTile(
                onTap: () {
                  if (isLanguage) _showLanguagePicker(context, l10n);
                },
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.cardPadding,
                  vertical: 4,
                ),
                leading: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: AppRadius.mdAll,
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                title: Text(label, style: AppTextStyles.h4),
                subtitle: Text(subtitle, style: AppTextStyles.bodySm),
                trailing: const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textTertiary,
                  size: 20,
                ),
              ),
              if (i < settings.length - 1)
                const Divider(height: 1, indent: 70, color: AppColors.divider),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLogout(BuildContext context, AppLocalizations l10n) {
    return AppButton(
      label: l10n.btnLogOut,
      icon: Icons.logout_rounded,
      variant: AppButtonVariant.outline,
      expand: true,
      onPressed: () => showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.dialogLogOutTitle),
          content: Text(l10n.dialogLogOutMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.btnCancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.btnLogOut,
                  style: const TextStyle(color: AppColors.danger)),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguagePicker(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: AppColors.surface,
      builder: (ctx) => ListenableBuilder(
        listenable: localeNotifier,
        builder: (context, child) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(top: 12, bottom: 20),
                decoration: const BoxDecoration(
                  color: AppColors.border,
                  borderRadius: AppRadius.fullAll,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
                child: Row(
                  children: [
                    Text(l10n.dialogLanguageTitle, style: AppTextStyles.h3),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _LanguageOption(
                flag: '🇹🇷',
                label: l10n.langTurkish,
                isSelected: localeNotifier.locale.languageCode == 'tr',
                onTap: () {
                  localeNotifier.set(const Locale('tr'));
                  Navigator.pop(ctx);
                },
              ),
              _LanguageOption(
                flag: '🇬🇧',
                label: l10n.langEnglish,
                isSelected: localeNotifier.locale.languageCode == 'en',
                onTap: () {
                  localeNotifier.set(const Locale('en'));
                  Navigator.pop(ctx);
                },
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.flag,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });
  final String flag;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal, vertical: 4),
      leading: Text(flag, style: const TextStyle(fontSize: 28)),
      title: Text(
        label,
        style: AppTextStyles.h4.copyWith(
          color: isSelected ? AppColors.primary : AppColors.textPrimary,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_rounded, color: AppColors.primary, size: 22)
          : null,
    );
  }
}
