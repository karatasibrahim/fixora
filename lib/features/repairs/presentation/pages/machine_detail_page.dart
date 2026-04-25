import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/failure_model.dart';
import '../../data/models/machine_model.dart';
import '../../data/models/maintenance_model.dart';
import '../../data/repositories/failure_repository.dart';
import 'add_maintenance_page.dart';
import 'failure_entry_page.dart';

class MachineDetailPage extends StatelessWidget {
  const MachineDetailPage({super.key, required this.machine});
  final MachineModel machine;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = context.read<AppAuthProvider>().user;
    final companyId = user?.companyId ?? '';
    final isManager = user?.isManager ?? false;
    final repo = FailureRepository();
    final statusColor = _statusColor(machine.status);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(machine.name),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.border),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
        children: [
          const SizedBox(height: AppSpacing.sm),
          _buildStatusCard(l10n, statusColor),
          const SizedBox(height: AppSpacing.itemGap),
          _buildInfoCard(l10n),
          const SizedBox(height: AppSpacing.sectionGap),
          SectionHeader(title: l10n.sectionRecentFailures),
          const SizedBox(height: AppSpacing.itemGap),
          StreamBuilder<List<FailureModel>>(
            stream: companyId.isEmpty
                ? const Stream.empty()
                : repo.watchFailures(companyId, machineId: machine.id),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting &&
                  !snap.hasData) {
                return const _LoadingCard();
              }
              final failures = snap.data ?? [];
              if (failures.isEmpty) {
                return _buildEmpty(
                  l10n.noFailuresFound,
                  Icons.check_circle_outline_rounded,
                  AppColors.success,
                );
              }
              return Column(
                children: failures
                    .map((f) => Padding(
                          padding:
                              const EdgeInsets.only(bottom: AppSpacing.itemGap),
                          child: _FailureItem(failure: f, l10n: l10n),
                        ))
                    .toList(),
              );
            },
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          SectionHeader(title: l10n.sectionMaintenanceDue),
          const SizedBox(height: AppSpacing.itemGap),
          StreamBuilder<List<MaintenanceModel>>(
            stream: companyId.isEmpty
                ? const Stream.empty()
                : repo.watchMaintenance(companyId, machineId: machine.id),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting &&
                  !snap.hasData) {
                return const _LoadingCard();
              }
              final items = snap.data ?? [];
              if (items.isEmpty) {
                return _buildEmpty(
                  l10n.noMaintenanceFound,
                  Icons.event_available_rounded,
                  AppColors.primary,
                );
              }
              return Column(
                children: items
                    .map((m) => Padding(
                          padding:
                              const EdgeInsets.only(bottom: AppSpacing.itemGap),
                          child: _MaintenanceItem(item: m),
                        ))
                    .toList(),
              );
            },
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          if (isManager)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: AppButton(
                label: l10n.btnPlanMaintenance,
                icon: Icons.event_available_rounded,
                expand: true,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        AddMaintenancePage(preselectedMachine: machine),
                  ),
                ),
              ),
            ),
          AppButton(
            label: l10n.btnLogFailure,
            icon: Icons.report_problem_outlined,
            variant: AppButtonVariant.outline,
            expand: true,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    FailureEntryPage(preselectedMachine: machine),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.huge),
        ],
      ),
    );
  }

  Widget _buildStatusCard(AppLocalizations l10n, Color statusColor) {
    final health = machine.healthFraction;
    return AppCard(
      child: Row(
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    value: health,
                    backgroundColor: AppColors.border,
                    valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                    strokeWidth: 8,
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${machine.healthScore}%',
                      style: AppTextStyles.h4.copyWith(color: statusColor),
                    ),
                    Text(
                      l10n.labelHealthScore,
                      style: AppTextStyles.caption.copyWith(fontSize: 9),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StatusBadgeLocal(status: machine.status, l10n: l10n),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    const Icon(Icons.schedule_rounded,
                        size: 14, color: AppColors.textTertiary),
                    const SizedBox(width: 4),
                    Text(l10n.labelLastChecked, style: AppTextStyles.caption),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  _formatTimeAgo(machine.createdAt, l10n),
                  style: AppTextStyles.h4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(AppLocalizations l10n) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.sectionMachineInfo, style: AppTextStyles.label),
          const SizedBox(height: AppSpacing.md),
          _InfoRow(
            icon: Icons.category_outlined,
            label: l10n.labelType,
            value: machine.type,
          ),
          const SizedBox(height: AppSpacing.sm),
          const AppDivider(),
          const SizedBox(height: AppSpacing.sm),
          _InfoRow(
            icon: Icons.location_on_outlined,
            label: l10n.fieldLocation,
            value: machine.location,
          ),
          if (machine.manufacturer != null) ...[
            const SizedBox(height: AppSpacing.sm),
            const AppDivider(),
            const SizedBox(height: AppSpacing.sm),
            _InfoRow(
              icon: Icons.business_outlined,
              label: l10n.fieldManufacturer,
              value: machine.manufacturer!,
            ),
          ],
          if (machine.model != null) ...[
            const SizedBox(height: AppSpacing.sm),
            const AppDivider(),
            const SizedBox(height: AppSpacing.sm),
            _InfoRow(
              icon: Icons.tag_rounded,
              label: l10n.fieldModel,
              value: machine.model!,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmpty(String message, IconData icon, Color color) {
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Column(
        children: [
          Icon(icon, size: 36, color: color.withValues(alpha: 0.5)),
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

class _StatusBadgeLocal extends StatelessWidget {
  const _StatusBadgeLocal({required this.status, required this.l10n});
  final String status;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final (label, variant) = switch (status) {
      'normal' => (l10n.statusActive, BadgeVariant.success),
      'warning' => (l10n.statusWarning, BadgeVariant.warning),
      'critical' => (l10n.statusCritical, BadgeVariant.danger),
      _ => (l10n.statusOffline, BadgeVariant.neutral),
    };
    return AppBadge(label: label, variant: variant, dot: true);
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(
      {required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textTertiary),
        const SizedBox(width: AppSpacing.sm),
        Text(label, style: AppTextStyles.caption),
        const Spacer(),
        Text(value, style: AppTextStyles.h4),
      ],
    );
  }
}

class _FailureItem extends StatelessWidget {
  const _FailureItem({required this.failure, required this.l10n});
  final FailureModel failure;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final isCritical = failure.severity == 'critical';
    final color = isCritical ? AppColors.danger : AppColors.warning;
    final variant = isCritical ? BadgeVariant.danger : BadgeVariant.warning;

    return AppCard(
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: AppRadius.mdAll,
            ),
            child: Icon(Icons.build_rounded, color: color, size: 18),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(failure.type, style: AppTextStyles.h4),
                const SizedBox(height: 2),
                Text(_formatTimeAgo(failure.reportedAt, l10n),
                    style: AppTextStyles.caption),
              ],
            ),
          ),
          AppBadge(
            label: isCritical ? l10n.statusCritical : l10n.statusWarning,
            variant: variant,
            dot: true,
          ),
        ],
      ),
    );
  }
}

class _MaintenanceItem extends StatelessWidget {
  const _MaintenanceItem({required this.item});
  final MaintenanceModel item;

  @override
  Widget build(BuildContext context) {
    final isOverdue = item.isOverdue;
    final color = isOverdue ? AppColors.danger : AppColors.primary;
    final dueLabel = _dueLabel(item.scheduledDate, isOverdue);

    return AppCard(
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: AppRadius.mdAll,
            ),
            child:
                Icon(Icons.build_circle_outlined, color: color, size: 18),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Text(item.task, style: AppTextStyles.h4)),
          AppBadge(
            label: dueLabel,
            variant: isOverdue ? BadgeVariant.danger : BadgeVariant.primary,
          ),
        ],
      ),
    );
  }
}

Color _statusColor(String status) => switch (status) {
      'normal' => AppColors.success,
      'warning' => AppColors.warning,
      'critical' => AppColors.danger,
      _ => AppColors.textTertiary,
    };

String _formatTimeAgo(DateTime dt, AppLocalizations l10n) {
  final diff = DateTime.now().difference(dt);
  if (diff.inSeconds < 60) return l10n.timeSecondsAgo(diff.inSeconds);
  if (diff.inMinutes < 60) return l10n.timeMinutesAgo(diff.inMinutes);
  if (diff.inHours < 24) return l10n.timeHoursAgo(diff.inHours);
  return l10n.timeDaysAgo(diff.inDays);
}

String _dueLabel(DateTime date, bool overdue) {
  final diff = date.difference(DateTime.now());
  if (overdue) return 'Gecikmiş';
  if (diff.inHours < 24) return 'Bugün';
  if (diff.inDays == 1) return 'Yarın';
  return '${diff.inDays} gün içinde';
}
