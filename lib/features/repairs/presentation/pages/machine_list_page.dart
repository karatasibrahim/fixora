import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../l10n/app_localizations.dart';
import 'add_machine_page.dart';
import 'failure_entry_page.dart';
import 'machine_detail_page.dart';

const _machines = [
  {'name': 'CNC Torna #1', 'type': 'CNC', 'location': 'Salon A · Hat 3', 'status': 'critical', 'health': 0.32, 'lastCheckSec': 2},
  {'name': 'Hidrolik Pres #3', 'type': 'Hydraulic', 'location': 'Salon B · Hat 1', 'status': 'warning', 'health': 0.61, 'lastCheckSec': 5},
  {'name': 'Hava Kompresörü A', 'type': 'Compressor', 'location': 'Teknik Oda', 'status': 'warning', 'health': 0.58, 'lastCheckSec': 86400},
  {'name': 'Konveyör Bant #2', 'type': 'Conveyor', 'location': 'Salon A · Hat 2', 'status': 'active', 'health': 0.87, 'lastCheckSec': 3},
  {'name': 'Su Pompası #1', 'type': 'Pump', 'location': 'Bodrum Kat', 'status': 'active', 'health': 0.79, 'lastCheckSec': 6},
  {'name': 'Elektrik Motoru #5', 'type': 'Motor', 'location': 'Salon C · Hat 2', 'status': 'active', 'health': 0.93, 'lastCheckSec': 1},
  {'name': 'Damga Presi #2', 'type': 'Press', 'location': 'Salon B · Hat 4', 'status': 'offline', 'health': 0.0, 'lastCheckSec': 172800},
  {'name': 'Soğutma Kulesi', 'type': 'HVAC', 'location': 'Çatı Katı', 'status': 'active', 'health': 0.84, 'lastCheckSec': 4},
];

class MachineListPage extends StatefulWidget {
  const MachineListPage({super.key});

  @override
  State<MachineListPage> createState() => _MachineListPageState();
}

class _MachineListPageState extends State<MachineListPage> {
  String _filterKey = 'all';
  String _search = '';

  List<Map<String, dynamic>> _filtered(AppLocalizations l10n) {
    return _machines.cast<Map<String, dynamic>>().where((m) {
      final matchSearch = _search.isEmpty ||
          m['name'].toString().toLowerCase().contains(_search.toLowerCase());
      final matchFilter = _filterKey == 'all' || m['status'] == _filterKey;
      return matchSearch && matchFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final top = MediaQuery.of(context).padding.top;
    final filtered = _filtered(l10n);

    final filterDefs = [
      ('all', l10n.filterAll),
      ('active', l10n.statusActive),
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
            child: filtered.isEmpty
                ? _buildEmpty(l10n)
                : ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
                    itemCount: filtered.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppSpacing.itemGap),
                    itemBuilder: (context, i) => _MachineCard(
                      data: filtered[i],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MachineDetailPage(data: filtered[i]),
                        ),
                      ),
                      onLogFailure: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const FailureEntryPage()),
                      ),
                    ),
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
      padding: EdgeInsets.fromLTRB(AppSpacing.pageHorizontal, top + 16, AppSpacing.pageHorizontal, 16),
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
      padding: const EdgeInsets.fromLTRB(AppSpacing.pageHorizontal, 0, AppSpacing.pageHorizontal, 12),
      child: TextField(
        onChanged: (v) => setState(() => _search = v),
        style: AppTextStyles.body,
        decoration: InputDecoration(
          hintText: l10n.searchHint,
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textTertiary, size: 20),
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
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
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
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary : AppColors.surfaceVariant,
                    borderRadius: AppRadius.fullAll,
                    border: Border.all(color: selected ? AppColors.primary : AppColors.border),
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
          const Icon(Icons.search_off_rounded, size: 48, color: AppColors.textTertiary),
          const SizedBox(height: AppSpacing.md),
          Text(l10n.noMachinesFound, style: AppTextStyles.h4.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text(l10n.tryDifferentFilter, style: AppTextStyles.bodySm),
        ],
      ),
    );
  }
}

class _MachineCard extends StatelessWidget {
  const _MachineCard({required this.data, required this.onTap, required this.onLogFailure});
  final Map<String, dynamic> data;
  final VoidCallback onTap;
  final VoidCallback onLogFailure;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final status = data['status'] as String;
    final health = data['health'] as double;
    final statusColor = _statusColor(status);

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
                child: Icon(_machineIcon(data['type'] as String), color: statusColor, size: 22),
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
                            data['name'] as String,
                            style: AppTextStyles.h4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        _StatusBadge(status: status),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 12, color: AppColors.textTertiary),
                        const SizedBox(width: 3),
                        Text(data['location'] as String, style: AppTextStyles.caption),
                        const Spacer(),
                        Text(l10n.checkedAgo(_formatTimeAgo(data['lastCheckSec'] as int, l10n)), style: AppTextStyles.caption),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (status != 'offline') ...[
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
      'active' => (l10n.statusActive, BadgeVariant.success),
      'warning' => (l10n.statusWarning, BadgeVariant.warning),
      'critical' => (l10n.statusCritical, BadgeVariant.danger),
      _ => (l10n.statusOffline, BadgeVariant.neutral),
    };
    return AppBadge(label: label, variant: variant, dot: true);
  }
}

Color _statusColor(String status) => switch (status) {
      'active' => AppColors.success,
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

String _formatTimeAgo(int seconds, AppLocalizations l10n) {
  if (seconds < 60) return l10n.timeSecondsAgo(seconds);
  if (seconds < 3600) return l10n.timeMinutesAgo(seconds ~/ 60);
  if (seconds < 86400) return l10n.timeHoursAgo(seconds ~/ 3600);
  return l10n.timeDaysAgo(seconds ~/ 86400);
}
