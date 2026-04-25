import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../repairs/data/models/failure_model.dart';
import '../../../repairs/data/models/machine_model.dart';
import '../../../repairs/data/models/maintenance_model.dart';
import '../../../repairs/data/repositories/failure_repository.dart';
import '../../../repairs/data/repositories/machine_repository.dart';
import '../../../repairs/presentation/pages/add_machine_page.dart';
import '../../../repairs/presentation/pages/failure_entry_page.dart';

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
    final user = context.watch<AppAuthProvider>().user;
    final companyId = user?.companyId ?? '';

    final machineRepo = MachineRepository();
    final failureRepo = FailureRepository();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _Header(
              greeting: greeting,
              top: top,
              name: user?.name ?? '',
              initials: user?.initials ?? '?',
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.pageHorizontal,
              vertical: AppSpacing.pageVertical,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildQuickActions(context, l10n),
                const SizedBox(height: AppSpacing.sectionGap),
                SectionHeader(title: l10n.sectionOverview),
                const SizedBox(height: AppSpacing.itemGap),
                StreamBuilder<List<MachineModel>>(
                  stream: companyId.isEmpty
                      ? const Stream.empty()
                      : machineRepo.watchMachines(companyId),
                  builder: (context, snap) {
                    final machines = snap.data ?? [];
                    final total = machines.length;
                    final active = machines.where((m) => m.status == 'normal').length;
                    final warnings = machines.where((m) => m.status == 'warning').length;
                    final critical = machines.where((m) => m.status == 'critical').length;
                    return _buildStats(l10n, total, active, warnings, critical);
                  },
                ),
                const SizedBox(height: AppSpacing.sectionGap),
                SectionHeader(
                  title: l10n.sectionRecentFailures,
                  action: () {},
                  actionLabel: l10n.seeAll,
                ),
                const SizedBox(height: AppSpacing.itemGap),
                StreamBuilder<List<FailureModel>>(
                  stream: companyId.isEmpty
                      ? const Stream.empty()
                      : failureRepo.watchFailures(companyId, limit: 5),
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const _LoadingCard();
                    }
                    final failures = snap.data ?? [];
                    if (failures.isEmpty) {
                      return _buildEmptyCard(
                        l10n.noFailuresFound,
                        Icons.check_circle_outline_rounded,
                        AppColors.success,
                      );
                    }
                    return Column(
                      children: failures
                          .map((f) => Padding(
                                padding: const EdgeInsets.only(
                                    bottom: AppSpacing.itemGap),
                                child: _FailureCard(failure: f),
                              ))
                          .toList(),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.sectionGap),
                SectionHeader(
                  title: l10n.sectionMaintenanceDue,
                  action: () {},
                  actionLabel: l10n.seeAll,
                ),
                const SizedBox(height: AppSpacing.itemGap),
                StreamBuilder<List<MaintenanceModel>>(
                  stream: companyId.isEmpty
                      ? const Stream.empty()
                      : failureRepo.watchMaintenance(companyId, limit: 3),
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const _LoadingCard();
                    }
                    final items = snap.data ?? [];
                    if (items.isEmpty) {
                      return _buildEmptyCard(
                        l10n.noMaintenanceFound,
                        Icons.event_available_rounded,
                        AppColors.primary,
                      );
                    }
                    return Column(
                      children: items
                          .map((m) => Padding(
                                padding: const EdgeInsets.only(
                                    bottom: AppSpacing.itemGap),
                                child: _MaintenanceCard(item: m),
                              ))
                          .toList(),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.huge),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(
    AppLocalizations l10n,
    int total,
    int active,
    int warnings,
    int critical,
  ) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: AppSpacing.itemGap,
      mainAxisSpacing: AppSpacing.itemGap,
      childAspectRatio: 1.3,
      children: [
        StatCard(
          value: '$total',
          label: l10n.statTotalMachines,
          icon: Icons.precision_manufacturing_rounded,
          color: AppColors.primary,
        ),
        StatCard(
          value: '$active',
          label: l10n.statActive,
          icon: Icons.check_circle_outline_rounded,
          color: AppColors.success,
        ),
        StatCard(
          value: '$warnings',
          label: l10n.statWarnings,
          icon: Icons.warning_amber_rounded,
          color: AppColors.warning,
        ),
        StatCard(
          value: '$critical',
          label: l10n.statCritical,
          icon: Icons.error_outline_rounded,
          color: AppColors.danger,
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

  Widget _buildEmptyCard(String message, IconData icon, Color color) {
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Column(
        children: [
          Icon(icon, size: 32, color: color.withValues(alpha: 0.5)),
          const SizedBox(height: AppSpacing.sm),
          Text(
            message,
            style: AppTextStyles.bodySm
                .copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.greeting,
    required this.top,
    required this.name,
    required this.initials,
  });
  final String greeting;
  final double top;
  final String name;
  final String initials;

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
                Text(
                  name,
                  style: const TextStyle(
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
            child: Text(
              initials,
              style: const TextStyle(
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

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return const AppCard(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

class _FailureCard extends StatelessWidget {
  const _FailureCard({required this.failure});
  final FailureModel failure;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isCritical = failure.severity == 'critical';
    final color = isCritical ? AppColors.danger : AppColors.warning;
    final variant = isCritical ? BadgeVariant.danger : BadgeVariant.warning;
    final ago = _timeAgo(failure.reportedAt, l10n);

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
                Text(failure.machineName, style: AppTextStyles.h4),
                const SizedBox(height: 2),
                Text(failure.type, style: AppTextStyles.bodySm),
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
              Text(ago, style: AppTextStyles.caption),
            ],
          ),
        ],
      ),
    );
  }
}

class _MaintenanceCard extends StatelessWidget {
  const _MaintenanceCard({required this.item});
  final MaintenanceModel item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isOverdue = item.isOverdue;
    final color = isOverdue ? AppColors.danger : AppColors.primary;
    final dueLabel = _dueLabel(item.scheduledDate, isOverdue, l10n);

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
                Text(item.machineName, style: AppTextStyles.h4),
                const SizedBox(height: 2),
                Text(item.task, style: AppTextStyles.bodySm),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          AppBadge(
            label: dueLabel,
            variant: isOverdue ? BadgeVariant.danger : BadgeVariant.primary,
          ),
        ],
      ),
    );
  }
}

String _timeAgo(DateTime dt, AppLocalizations l10n) {
  final diff = DateTime.now().difference(dt);
  if (diff.inSeconds < 60) return l10n.timeSecondsAgo(diff.inSeconds);
  if (diff.inMinutes < 60) return l10n.timeMinutesAgo(diff.inMinutes);
  if (diff.inHours < 24) return l10n.timeHoursAgo(diff.inHours);
  return l10n.timeDaysAgo(diff.inDays);
}

String _dueLabel(DateTime date, bool overdue, AppLocalizations l10n) {
  final diff = date.difference(DateTime.now());
  if (overdue) {
    final days = DateTime.now().difference(date).inDays;
    return l10n.timeDaysAgo(days);
  }
  if (diff.inHours < 24) return 'Bugün';
  if (diff.inDays == 1) return 'Yarın';
  return '${diff.inDays} gün içinde';
}
