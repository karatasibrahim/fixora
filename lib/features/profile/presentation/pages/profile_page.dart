import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/locale/locale_notifier.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../repairs/data/models/failure_model.dart';
import '../../../repairs/data/models/machine_model.dart';
import '../../../repairs/data/repositories/failure_repository.dart';
import '../../../repairs/data/repositories/machine_repository.dart';
import 'team_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _machineRepo = MachineRepository();
  final _failureRepo = FailureRepository();
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((p) {
      if (mounted) {
        setState(() =>
            _notificationsEnabled = p.getBool('notifications_enabled') ?? true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final top = MediaQuery.of(context).padding.top;
    final user = context.watch<AppAuthProvider>().user;

    final settings = [
      if (user?.isManager == true)
        (
          Icons.group_rounded,
          'Ekip',
          'Şirket üyelerini görüntüle',
          AppColors.primary,
          _SettingAction.team,
        ),
      (
        Icons.notifications_outlined,
        l10n.settingNotifications,
        _notificationsEnabled ? 'Açık' : 'Kapalı',
        const Color(0xFF2563EB),
        _SettingAction.notifications,
      ),
      (
        Icons.language_rounded,
        l10n.settingLanguage,
        l10n.settingLanguageCurrent,
        const Color(0xFF16A34A),
        _SettingAction.language,
      ),
      (
        Icons.dark_mode_outlined,
        l10n.settingAppearance,
        switch (themeNotifier.mode) {
          ThemeMode.dark => 'Koyu Tema',
          ThemeMode.system => 'Sistem',
          _ => 'Açık Tema',
        },
        const Color(0xFF475569),
        _SettingAction.appearance,
      ),
      (
        Icons.security_rounded,
        l10n.settingSecurity,
        'Şifre Değiştir',
        const Color(0xFFF59E0B),
        _SettingAction.security,
      ),
      (
        Icons.help_outline_rounded,
        l10n.settingHelpSupport,
        l10n.settingHelpSupportSubtitle,
        const Color(0xFF25D366),
        _SettingAction.whatsapp,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildHeader(context, l10n, top, user?.name ?? '', user?.initials ?? '?',
              user?.isManager == true ? 'Yönetici' : 'Çalışan'),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.sm),
                _buildStats(
                  companyId: user?.companyId ?? '',
                  uid: user?.uid ?? '',
                  l10n: l10n,
                ),
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

  Widget _buildHeader(
    BuildContext context,
    AppLocalizations l10n,
    double top,
    String name,
    String initials,
    String roleLabel,
  ) {
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
                child: Text(
                  initials,
                  style: const TextStyle(
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
                    Text(
                      name,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(l10n.jobTitle, style: AppTextStyles.bodySm),
                    const SizedBox(height: 6),
                    AppBadge(label: roleLabel, variant: BadgeVariant.primary),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStats({
    required String companyId,
    required String uid,
    required AppLocalizations l10n,
  }) {
    final machineStream = companyId.isEmpty
        ? Stream.value(<MachineModel>[])
        : _machineRepo.watchMachines(companyId);

    final failureStream = companyId.isEmpty
        ? Stream.value(<FailureModel>[])
        : _failureRepo.watchFailures(companyId);

    return AppCard(
      child: Row(
        children: [
          // Makine sayısı
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: StreamBuilder<List<MachineModel>>(
                    stream: machineStream,
                    builder: (_, snap) => _StatCell(
                      value: snap.hasData ? '${snap.data!.length}' : '—',
                      label: l10n.statMachinesLabel,
                    ),
                  ),
                ),
                Container(width: 1, height: 40, color: AppColors.divider),
              ],
            ),
          ),
          // Arıza sayısı (kullanıcının kendi kaydettiği)
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: StreamBuilder<List<FailureModel>>(
                    stream: failureStream,
                    builder: (_, snap) {
                      final mine = snap.hasData
                          ? snap.data!.where((f) => f.reportedBy == uid).length
                          : null;
                      return _StatCell(
                        value: mine != null ? '$mine' : '—',
                        label: l10n.statFailuresLabel,
                      );
                    },
                  ),
                ),
                Container(width: 1, height: 40, color: AppColors.divider),
              ],
            ),
          ),
          // Ortalama yanıt: kullanıcının arızaları arasındaki ort. süre
          Expanded(
            child: StreamBuilder<List<FailureModel>>(
              stream: failureStream,
              builder: (_, snap) {
                String value = '—';
                if (snap.hasData) {
                  final mine = snap.data!
                      .where((f) => f.reportedBy == uid)
                      .toList()
                    ..sort((a, b) => a.reportedAt.compareTo(b.reportedAt));
                  if (mine.length >= 2) {
                    var totalHours = 0;
                    for (int i = 1; i < mine.length; i++) {
                      totalHours += mine[i]
                          .reportedAt
                          .difference(mine[i - 1].reportedAt)
                          .inHours;
                    }
                    final avg = totalHours ~/ (mine.length - 1);
                    value = avg < 24 ? '${avg}sa' : '${avg ~/ 24}g';
                  }
                }
                return _StatCell(
                  value: value,
                  label: l10n.statAvgResponseLabel,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(
    BuildContext context,
    AppLocalizations l10n,
    List<(IconData, String, String, Color, _SettingAction)> settings,
  ) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: settings.asMap().entries.map((entry) {
          final i = entry.key;
          final (icon, label, subtitle, color, action) = entry.value;

          return Column(
            children: [
              ListTile(
                onTap: () {
                  switch (action) {
                    case _SettingAction.language:
                      _showLanguagePicker(context, l10n);
                    case _SettingAction.team:
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const TeamPage()),
                      );
                    case _SettingAction.whatsapp:
                      _openWhatsApp();
                    case _SettingAction.none:
                      break;
                  }
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
                const Divider(
                    height: 1, indent: 70, color: AppColors.divider),
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
              onPressed: () {
                Navigator.pop(ctx);
                context.read<AppAuthProvider>().signOut();
              },
              child: Text(l10n.btnLogOut,
                  style: const TextStyle(color: AppColors.danger)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openWhatsApp() async {
    final nativeUri = Uri.parse('whatsapp://send?phone=905343358496');
    if (await canLaunchUrl(nativeUri)) {
      await launchUrl(nativeUri, mode: LaunchMode.externalApplication);
      return;
    }
    final webUri = Uri.parse('https://wa.me/905343358496');
    if (await canLaunchUrl(webUri)) {
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    }
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
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.pageHorizontal),
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
                isSelected:
                    localeNotifier.locale.languageCode == 'tr',
                onTap: () {
                  localeNotifier.set(const Locale('tr'));
                  Navigator.pop(ctx);
                },
              ),
              _LanguageOption(
                flag: '🇬🇧',
                label: l10n.langEnglish,
                isSelected:
                    localeNotifier.locale.languageCode == 'en',
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

enum _SettingAction { none, language, team, whatsapp, notifications, appearance, security }

class _StatCell extends StatelessWidget {
  const _StatCell({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.stat),
        const SizedBox(height: 4),
        Text(label,
            style: AppTextStyles.caption, textAlign: TextAlign.center),
      ],
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
      contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.pageHorizontal, vertical: 4),
      leading: Text(flag, style: const TextStyle(fontSize: 28)),
      title: Text(
        label,
        style: AppTextStyles.h4.copyWith(
          color: isSelected ? AppColors.primary : AppColors.textPrimary,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_rounded,
              color: AppColors.primary, size: 22)
          : null,
    );
  }
}
