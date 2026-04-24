import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../l10n/app_localizations.dart';
import 'failure_entry_page.dart';

const _failuresByMachine = {
  'CNC Torna #1': [
    {'type': 'Rulman Aşınması', 'severity': 'critical', 'sec': 7200},
    {'type': 'Titreşim Anomalisi', 'severity': 'warning', 'sec': 86400},
  ],
  'Hidrolik Pres #3': [
    {'type': 'Hidrolik Sızıntı', 'severity': 'warning', 'sec': 18000},
  ],
  'Hava Kompresörü A': [
    {'type': 'Elektrik Arızası', 'severity': 'warning', 'sec': 86400},
    {'type': 'Basınç Düşüşü', 'severity': 'critical', 'sec': 259200},
  ],
};

const _maintenanceByMachine = {
  'CNC Torna #1': [
    {'task': 'Ana Mil Rulman Değişimi', 'due': 'Acil', 'overdue': true},
  ],
  'Konveyör Bant #2': [
    {'task': 'Rutin Bant Gerginlik Kontrolü', 'due': 'Yarın', 'overdue': false},
  ],
  'Su Pompası #1': [
    {'task': 'Yağ Değişimi', 'due': '3 gün gecikmiş', 'overdue': true},
  ],
  'Soğutma Kulesi': [
    {'task': 'Filtre Temizliği', 'due': '7 gün içinde', 'overdue': false},
  ],
};

class MachineDetailPage extends StatelessWidget {
  const MachineDetailPage({super.key, required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final name = data['name'] as String;
    final status = data['status'] as String;
    final health = data['health'] as double;
    final lastCheckSec = data['lastCheckSec'] as int;
    final statusColor = _statusColor(status);
    final failures = _failuresByMachine[name] ?? [];
    final maintenance = _maintenanceByMachine[name] ?? [];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(name),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.border),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
        children: [
          const SizedBox(height: AppSpacing.sm),
          _buildStatusCard(l10n, status, health, statusColor, lastCheckSec),
          const SizedBox(height: AppSpacing.itemGap),
          _buildInfoCard(l10n),
          const SizedBox(height: AppSpacing.sectionGap),
          SectionHeader(title: l10n.sectionRecentFailures),
          const SizedBox(height: AppSpacing.itemGap),
          failures.isEmpty
              ? _buildEmpty(l10n.noFailuresFound, Icons.check_circle_outline_rounded, AppColors.success)
              : Column(
                  children: failures.map((f) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.itemGap),
                    child: _FailureItem(data: f, l10n: l10n),
                  )).toList(),
                ),
          const SizedBox(height: AppSpacing.sectionGap),
          SectionHeader(title: l10n.sectionMaintenanceDue),
          const SizedBox(height: AppSpacing.itemGap),
          maintenance.isEmpty
              ? _buildEmpty(l10n.noMaintenanceFound, Icons.event_available_rounded, AppColors.primary)
              : Column(
                  children: maintenance.map((m) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.itemGap),
                    child: _MaintenanceItem(data: m),
                  )).toList(),
                ),
          const SizedBox(height: AppSpacing.sectionGap),
          AppButton(
            label: l10n.btnLogFailure,
            icon: Icons.report_problem_outlined,
            variant: AppButtonVariant.outline,
            expand: true,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FailureEntryPage()),
            ),
          ),
          const SizedBox(height: AppSpacing.huge),
        ],
      ),
    );
  }

  Widget _buildStatusCard(
    AppLocalizations l10n,
    String status,
    double health,
    Color statusColor,
    int lastCheckSec,
  ) {
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
                      '${(health * 100).round()}%',
                      style: AppTextStyles.h4.copyWith(color: statusColor),
                    ),
                    Text(l10n.labelHealthScore, style: AppTextStyles.caption.copyWith(fontSize: 9)),
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
                _StatusBadgeLocal(status: status, l10n: l10n),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    const Icon(Icons.schedule_rounded, size: 14, color: AppColors.textTertiary),
                    const SizedBox(width: 4),
                    Text(l10n.labelLastChecked, style: AppTextStyles.caption),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  _formatTimeAgo(lastCheckSec, l10n),
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
            value: data['type'] as String,
          ),
          const SizedBox(height: AppSpacing.sm),
          const AppDivider(),
          const SizedBox(height: AppSpacing.sm),
          _InfoRow(
            icon: Icons.location_on_outlined,
            label: l10n.fieldLocation,
            value: data['location'] as String,
          ),
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
          Text(message, style: AppTextStyles.bodySm.copyWith(color: AppColors.textSecondary)),
        ],
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
      'active' => (l10n.statusActive, BadgeVariant.success),
      'warning' => (l10n.statusWarning, BadgeVariant.warning),
      'critical' => (l10n.statusCritical, BadgeVariant.danger),
      _ => (l10n.statusOffline, BadgeVariant.neutral),
    };
    return AppBadge(label: label, variant: variant, dot: true);
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value});
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
  const _FailureItem({required this.data, required this.l10n});
  final Map<String, dynamic> data;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final isCritical = data['severity'] == 'critical';
    final color = isCritical ? AppColors.danger : AppColors.warning;
    final variant = isCritical ? BadgeVariant.danger : BadgeVariant.warning;
    final sec = data['sec'] as int;

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
                Text(data['type'] as String, style: AppTextStyles.h4),
                const SizedBox(height: 2),
                Text(_formatTimeAgo(sec, l10n), style: AppTextStyles.caption),
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
  const _MaintenanceItem({required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final isOverdue = data['overdue'] as bool;
    final color = isOverdue ? AppColors.danger : AppColors.primary;

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
            child: Icon(Icons.build_circle_outlined, color: color, size: 18),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(data['task'] as String, style: AppTextStyles.h4),
          ),
          AppBadge(
            label: data['due'] as String,
            variant: isOverdue ? BadgeVariant.danger : BadgeVariant.primary,
          ),
        ],
      ),
    );
  }
}

Color _statusColor(String status) => switch (status) {
      'active' => AppColors.success,
      'warning' => AppColors.warning,
      'critical' => AppColors.danger,
      _ => AppColors.textTertiary,
    };

String _formatTimeAgo(int seconds, AppLocalizations l10n) {
  if (seconds < 60) return l10n.timeSecondsAgo(seconds);
  if (seconds < 3600) return l10n.timeMinutesAgo(seconds ~/ 60);
  if (seconds < 86400) return l10n.timeHoursAgo(seconds ~/ 3600);
  return l10n.timeDaysAgo(seconds ~/ 86400);
}
