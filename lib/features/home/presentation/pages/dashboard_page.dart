import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../repairs/presentation/pages/add_machine_page.dart';
import '../../../repairs/presentation/pages/failure_entry_page.dart';

const _failures = [
  {'machine': 'CNC Torna #1', 'type': 'Rulman Aşınması', 'severity': 'critical', 'time': '2s önce'},
  {'machine': 'Hidrolik Pres #3', 'type': 'Hidrolik Sızıntı', 'severity': 'warning', 'time': '5s önce'},
  {'machine': 'Hava Kompresörü A', 'type': 'Elektrik Arızası', 'severity': 'warning', 'time': '1g önce'},
];

const _maintenance = [
  {'machine': 'Konveyör Bant #2', 'type': 'Rutin Bakım', 'due': 'Yarın', 'overdue': false},
  {'machine': 'Su Pompası #1', 'type': 'Yağ Değişimi', 'due': '3 gün gecikmiş', 'overdue': true},
];

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final top = MediaQuery.of(context).padding.top;
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? l10n.greetingMorning
        : hour < 17
            ? l10n.greetingAfternoon
            : l10n.greetingEvening;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _Header(greeting: greeting, top: top)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.pageHorizontal,
              vertical: AppSpacing.pageVertical,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildAlert(l10n),
                const SizedBox(height: AppSpacing.sectionGap),
                SectionHeader(title: l10n.sectionOverview),
                const SizedBox(height: AppSpacing.itemGap),
                _buildStats(l10n),
                const SizedBox(height: AppSpacing.lg),
                _buildQuickActions(context, l10n),
                const SizedBox(height: AppSpacing.sectionGap),
                SectionHeader(
                  title: l10n.sectionRecentFailures,
                  action: () {},
                  actionLabel: l10n.seeAll,
                ),
                const SizedBox(height: AppSpacing.itemGap),
                ..._failures.map((f) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.itemGap),
                      child: _FailureCard(data: f),
                    )),
                const SizedBox(height: AppSpacing.sectionGap),
                SectionHeader(
                  title: l10n.sectionMaintenanceDue,
                  action: () {},
                  actionLabel: l10n.seeAll,
                ),
                const SizedBox(height: AppSpacing.itemGap),
                ..._maintenance.map((m) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.itemGap),
                      child: _MaintenanceCard(data: m),
                    )),
                const SizedBox(height: AppSpacing.huge),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlert(AppLocalizations l10n) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      color: AppColors.dangerLight,
      border: Border.all(color: AppColors.danger.withValues(alpha: 0.2)),
      shadows: const [],
      child: Row(
        children: [
          const Icon(Icons.error_rounded, color: AppColors.danger, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              l10n.alertCritical,
              style: AppTextStyles.bodySm
                  .copyWith(color: AppColors.danger, fontWeight: FontWeight.w600),
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.danger, size: 18),
        ],
      ),
    );
  }

  Widget _buildStats(AppLocalizations l10n) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: AppSpacing.itemGap,
      mainAxisSpacing: AppSpacing.itemGap,
      childAspectRatio: 1.45,
      children: [
        StatCard(
          value: '48',
          label: l10n.statTotalMachines,
          icon: Icons.precision_manufacturing_rounded,
          color: AppColors.primary,
        ),
        StatCard(
          value: '41',
          label: l10n.statActive,
          icon: Icons.check_circle_outline_rounded,
          color: AppColors.success,
          trend: '+2',
          trendUp: true,
        ),
        StatCard(
          value: '5',
          label: l10n.statWarnings,
          icon: Icons.warning_amber_rounded,
          color: AppColors.warning,
        ),
        StatCard(
          value: '2',
          label: l10n.statCritical,
          icon: Icons.error_outline_rounded,
          color: AppColors.danger,
          trend: '+1',
          trendUp: false,
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context, AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: AppButton(
            label: l10n.btnAddMachine,
            icon: Icons.add_rounded,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddMachinePage()),
            ),
            expand: true,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: AppButton(
            label: l10n.btnLogFailure,
            icon: Icons.report_problem_outlined,
            variant: AppButtonVariant.outline,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FailureEntryPage()),
            ),
            expand: true,
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.greeting, required this.top});
  final String greeting;
  final double top;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontal,
        top + 16,
        AppSpacing.pageHorizontal,
        20,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(greeting, style: AppTextStyles.bodySm),
                const SizedBox(height: 2),
                const Text(
                  'İbrahim Karataş',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
          AppIconButton(
            icon: Icons.notifications_outlined,
            onTap: () {},
            tooltip: l10n.tooltipNotifications,
          ),
          const SizedBox(width: AppSpacing.sm),
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: AppRadius.fullAll,
            ),
            alignment: Alignment.center,
            child: const Text(
              'İK',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FailureCard extends StatelessWidget {
  const _FailureCard({required this.data});
  final Map<String, String> data;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isCritical = data['severity'] == 'critical';
    final color = isCritical ? AppColors.danger : AppColors.warning;
    final variant = isCritical ? BadgeVariant.danger : BadgeVariant.warning;

    return AppCard(
      onTap: () {},
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: AppRadius.mdAll,
            ),
            child: Icon(Icons.build_rounded, color: color, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data['machine']!, style: AppTextStyles.h4),
                const SizedBox(height: 2),
                Text(data['type']!, style: AppTextStyles.bodySm),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AppBadge(
                label: isCritical ? l10n.statusCritical : l10n.statusWarning,
                variant: variant,
                dot: true,
              ),
              const SizedBox(height: 4),
              Text(data['time']!, style: AppTextStyles.caption),
            ],
          ),
        ],
      ),
    );
  }
}

class _MaintenanceCard extends StatelessWidget {
  const _MaintenanceCard({required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final isOverdue = data['overdue'] as bool;
    final color = isOverdue ? AppColors.danger : AppColors.primary;

    return AppCard(
      onTap: () {},
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: AppRadius.mdAll,
            ),
            child: Icon(Icons.build_circle_outlined, color: color, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data['machine'] as String, style: AppTextStyles.h4),
                const SizedBox(height: 2),
                Text(data['type'] as String, style: AppTextStyles.bodySm),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          AppBadge(
            label: data['due'] as String,
            variant: isOverdue ? BadgeVariant.danger : BadgeVariant.primary,
          ),
        ],
      ),
    );
  }
}
