import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/machine_model.dart';
import '../../data/repositories/machine_repository.dart';
import 'add_machine_page.dart';
import 'failure_entry_page.dart';
import 'machine_detail_page.dart';

class MachineListPage extends StatefulWidget {
  const MachineListPage({super.key});

  @override
  State<MachineListPage> createState() => _MachineListPageState();
}

class _MachineListPageState extends State<MachineListPage> {
  final _repo = MachineRepository();
  String _filterKey = 'all';
  String _search = '';

  List<MachineModel> _filtered(List<MachineModel> machines, AppLocalizations l10n) {
    return machines.where((m) {
      final matchSearch = _search.isEmpty ||
          m.name.toLowerCase().contains(_search.toLowerCase());
      final matchFilter = _filterKey == 'all' || m.status == _filterKey;
      return matchSearch && matchFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final top = MediaQuery.of(context).padding.top;
    final companyId = context.watch<AppAuthProvider>().user?.companyId ?? '';

    final filterDefs = [
      ('all', l10n.filterAll),
      ('normal', l10n.statusActive),
      ('warning', l10n.statusWarning),
      ('critical', l10n.statusCritical),
      ('offline', l10n.statusOffline),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(context, l10n, top),
          _buildSearch(l10n),
          _buildFilters(filterDefs),
          const Divider(height: 1, color: AppColors.divider),
          Expanded(
            child: companyId.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : StreamBuilder<List<MachineModel>>(
                    stream: _repo.watchMachines(companyId),
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.waiting &&
                          !snap.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final filtered = _filtered(snap.data ?? [], l10n);
                      return filtered.isEmpty
                          ? _buildEmpty(l10n)
                          : ListView.separated(
                              padding: const EdgeInsets.all(
                                  AppSpacing.pageHorizontal),
                              itemCount: filtered.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(height: AppSpacing.itemGap),
                              itemBuilder: (context, i) => _MachineCard(
                                machine: filtered[i],
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => MachineDetailPage(
                                        machine: filtered[i]),
                                  ),
                                ),
                                onLogFailure: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => FailureEntryPage(
                                        preselectedMachine: filtered[i]),
                                  ),
                                ),
                              ),
                            );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddMachinePage()),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        icon: const Icon(Icons.add_rounded),
        label: Text(
          l10n.btnAddMachine,
          style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n, double top) {
    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.fromLTRB(
          AppSpacing.pageHorizontal, top + 16, AppSpacing.pageHorizontal, 16),
      child: Row(
        children: [
          Expanded(child: Text(l10n.pageMachines, style: AppTextStyles.h2)),
          AppIconButton(
            icon: Icons.tune_rounded,
            onTap: () {},
            tooltip: l10n.tooltipFilter,
          ),
        ],
      ),
    );
  }

  Widget _buildSearch(AppLocalizations l10n) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.pageHorizontal, 0, AppSpacing.pageHorizontal, 12),
      child: TextField(
        onChanged: (v) => setState(() => _search = v),
        style: AppTextStyles.body,
        decoration: InputDecoration(
          hintText: l10n.searchHint,
          prefixIcon: const Icon(Icons.search_rounded,
              color: AppColors.textTertiary, size: 20),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          suffixIcon: _search.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close_rounded, size: 18),
                  onPressed: () => setState(() => _search = ''),
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildFilters(List<(String, String)> filterDefs) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.only(bottom: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pageHorizontal),
        child: Row(
          children: filterDefs.map((def) {
            final (key, label) = def;
            final selected = _filterKey == key;
            return Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: GestureDetector(
                onTap: () => setState(() => _filterKey = key),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.primary
                        : AppColors.surfaceVariant,
                    borderRadius: AppRadius.fullAll,
                    border: Border.all(
                        color:
                            selected ? AppColors.primary : AppColors.border),
                  ),
                  child: Text(
                    label,
                    style: AppTextStyles.label.copyWith(
                      color: selected ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildEmpty(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.search_off_rounded,
              size: 48, color: AppColors.textTertiary),
          const SizedBox(height: AppSpacing.md),
          Text(l10n.noMachinesFound,
              style:
                  AppTextStyles.h4.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text(l10n.tryDifferentFilter, style: AppTextStyles.bodySm),
        ],
      ),
    );
  }
}

class _MachineCard extends StatelessWidget {
  const _MachineCard({
    required this.machine,
    required this.onTap,
    required this.onLogFailure,
  });
  final MachineModel machine;
  final VoidCallback onTap;
  final VoidCallback onLogFailure;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final statusColor = _statusColor(machine.status);
    final health = machine.healthFraction;

    return AppCard(
      onTap: onTap,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: AppRadius.mdAll,
                ),
                child: Icon(_machineIcon(machine.type),
                    color: statusColor, size: 22),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            machine.name,
                            style: AppTextStyles.h4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        _StatusBadge(status: machine.status),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 12, color: AppColors.textTertiary),
                        const SizedBox(width: 3),
                        Text(machine.location, style: AppTextStyles.caption),
                        const Spacer(),
                        Text(
                          l10n.checkedAgo(
                              _formatTimeAgo(machine.createdAt, l10n)),
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (machine.status != 'offline') ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: AppRadius.fullAll,
                    child: LinearProgressIndicator(
                      value: health,
                      minHeight: 5,
                      backgroundColor: AppColors.border,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        health >= 0.8
                            ? AppColors.success
                            : health >= 0.6
                                ? AppColors.warning
                                : AppColors.danger,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  '${(health * 100).round()}%',
                  style: AppTextStyles.label.copyWith(
                    color: health >= 0.8
                        ? AppColors.success
                        : health >= 0.6
                            ? AppColors.warning
                            : AppColors.danger,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final (label, variant) = switch (status) {
      'normal' => (l10n.statusActive, BadgeVariant.success),
      'warning' => (l10n.statusWarning, BadgeVariant.warning),
      'critical' => (l10n.statusCritical, BadgeVariant.danger),
      _ => (l10n.statusOffline, BadgeVariant.neutral),
    };
    return AppBadge(label: label, variant: variant, dot: true);
  }
}

Color _statusColor(String status) => switch (status) {
      'normal' => AppColors.success,
      'warning' => AppColors.warning,
      'critical' => AppColors.danger,
      _ => AppColors.textTertiary,
    };

IconData _machineIcon(String type) => switch (type.toLowerCase()) {
      'cnc' => Icons.precision_manufacturing_rounded,
      'pump' => Icons.water_drop_rounded,
      'compressor' => Icons.air_rounded,
      'conveyor' => Icons.linear_scale_rounded,
      'motor' => Icons.electric_bolt_rounded,
      'hydraulic' => Icons.settings_input_component_rounded,
      'hvac' => Icons.ac_unit_rounded,
      _ => Icons.build_rounded,
    };

String _formatTimeAgo(DateTime dt, AppLocalizations l10n) {
  final diff = DateTime.now().difference(dt);
  if (diff.inSeconds < 60) return l10n.timeSecondsAgo(diff.inSeconds);
  if (diff.inMinutes < 60) return l10n.timeMinutesAgo(diff.inMinutes);
  if (diff.inHours < 24) return l10n.timeHoursAgo(diff.inHours);
  return l10n.timeDaysAgo(diff.inDays);
}
