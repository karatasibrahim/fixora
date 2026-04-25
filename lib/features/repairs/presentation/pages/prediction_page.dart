import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/machine_model.dart';
import '../../data/repositories/machine_repository.dart';

class PredictionPage extends StatefulWidget {
  const PredictionPage({super.key});

  @override
  State<PredictionPage> createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  final _repo = MachineRepository();
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final top = MediaQuery.of(context).padding.top;
    final companyId =
        context.watch<AppAuthProvider>().user?.companyId ?? '';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: companyId.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<List<MachineModel>>(
              stream: _repo.watchMachines(companyId),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting &&
                    !snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final machines = snap.data ?? [];
                if (machines.isEmpty) {
                  return _buildEmpty(l10n, top);
                }
                final idx =
                    _selected < machines.length ? _selected : 0;
                final current = machines[idx];

                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: _buildHeader(l10n, top)),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.pageHorizontal,
                        vertical: AppSpacing.pageVertical,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          _buildHealthGauge(l10n, current),
                          const SizedBox(height: AppSpacing.itemGap),
                          _buildRiskBanner(current),
                          const SizedBox(height: AppSpacing.sectionGap),
                          SectionHeader(title: l10n.sectionHealthMetrics),
                          const SizedBox(height: AppSpacing.itemGap),
                          _buildMetrics(current),
                          const SizedBox(height: AppSpacing.sectionGap),
                          SectionHeader(title: l10n.sectionRecommendations),
                          const SizedBox(height: AppSpacing.itemGap),
                          _buildRecommendations(current),
                          const SizedBox(height: AppSpacing.sectionGap),
                          SectionHeader(title: l10n.sectionAllMachines),
                          const SizedBox(height: AppSpacing.itemGap),
                          _buildMachineList(l10n, machines, idx),
                          const SizedBox(height: AppSpacing.huge),
                        ]),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n, double top) {
    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.fromLTRB(
          AppSpacing.pageHorizontal, top + 16, AppSpacing.pageHorizontal, 16),
      child: Row(
        children: [
          Expanded(
              child: Text(l10n.pagePredictions, style: AppTextStyles.h2)),
          AppIconButton(
            icon: Icons.info_outline_rounded,
            onTap: () {},
            tooltip: l10n.tooltipAboutPredictions,
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(AppLocalizations l10n, double top) {
    return Column(
      children: [
        _buildHeader(l10n, top),
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.precision_manufacturing_rounded,
                    size: 48, color: AppColors.textTertiary),
                const SizedBox(height: AppSpacing.md),
                Text('Henüz makine eklenmedi.',
                    style: AppTextStyles.h4
                        .copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHealthGauge(AppLocalizations l10n, MachineModel m) {
    final color = _healthColor(m.healthScore);

    return AppCard(
      child: Column(
        children: [
          Text(m.name, style: AppTextStyles.h3),
          const SizedBox(height: 4),
          Text(m.type, style: AppTextStyles.bodySm),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: 160,
            height: 160,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 160,
                  height: 160,
                  child: CircularProgressIndicator(
                    value: m.healthFraction,
                    backgroundColor: AppColors.border,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    strokeWidth: 14,
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${m.healthScore}%',
                      style: AppTextStyles.statLg.copyWith(color: color),
                    ),
                    const SizedBox(height: 2),
                    Text(l10n.labelHealthScore, style: AppTextStyles.caption),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _GaugeStat(
                label: l10n.labelNextService,
                value: _nextServiceLabel(m),
                icon: Icons.build_circle_outlined,
                color: AppColors.primary,
              ),
              Container(width: 1, height: 40, color: AppColors.divider),
              _GaugeStat(
                label: l10n.labelRiskLevel,
                value: _riskLabel(m.status, l10n),
                icon: Icons.shield_outlined,
                color: color,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRiskBanner(MachineModel m) {
    final color = _healthColor(m.healthScore);
    final bgColor = m.healthScore >= 80
        ? AppColors.successLight
        : m.healthScore >= 60
            ? AppColors.warningLight
            : AppColors.dangerLight;

    return AppCard(
      color: bgColor,
      shadows: const [],
      border: Border.all(color: color.withValues(alpha: 0.25)),
      child: Row(
        children: [
          Icon(Icons.auto_graph_rounded, color: color, size: 20),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              _riskDescription(m),
              style: AppTextStyles.bodySm.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetrics(MachineModel m) {
    final metrics = _syntheticMetrics(m);
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: AppSpacing.itemGap,
      mainAxisSpacing: AppSpacing.itemGap,
      childAspectRatio: 2.0,
      children: metrics.map((metric) {
        final color = _statusColor(metric.$3);
        return AppCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration:
                    BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(metric.$1, style: AppTextStyles.caption),
                    const SizedBox(height: 2),
                    Text(
                      metric.$2,
                      style: AppTextStyles.h4.copyWith(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRecommendations(MachineModel m) {
    final recs = _recommendations(m);
    return AppCard(
      child: Column(
        children: recs.asMap().entries.map((entry) {
          final i = entry.key;
          final rec = entry.value;
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: AppRadius.fullAll,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${i + 1}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: Text(rec, style: AppTextStyles.body)),
                ],
              ),
              if (i < recs.length - 1) ...[
                const SizedBox(height: AppSpacing.md),
                const AppDivider(),
                const SizedBox(height: AppSpacing.md),
              ],
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMachineList(
      AppLocalizations l10n, List<MachineModel> machines, int selectedIdx) {
    return Column(
      children: machines.asMap().entries.map((entry) {
        final i = entry.key;
        final m = entry.value;
        final color = _healthColor(m.healthScore);
        final isSelected = selectedIdx == i;

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.itemGap),
          child: GestureDetector(
            onTap: () => setState(() => _selected = i),
            child: AppCard(
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: isSelected ? 1.5 : 0.5,
              ),
              shadows: isSelected ? AppShadows.md : AppShadows.card,
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: AppRadius.mdAll,
                    ),
                    child:
                        Icon(_machineIcon(m.type), color: color, size: 20),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(m.name, style: AppTextStyles.h4),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: AppRadius.fullAll,
                                child: LinearProgressIndicator(
                                  value: m.healthFraction,
                                  minHeight: 4,
                                  backgroundColor: AppColors.border,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(color),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              '${m.healthScore}%',
                              style: AppTextStyles.caption.copyWith(
                                color: color,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textTertiary,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _GaugeStat extends StatelessWidget {
  const _GaugeStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.h4.copyWith(color: color)),
        const SizedBox(height: 2),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}

// Rule-based synthetic metrics derived from healthScore + status
List<(String, String, String)> _syntheticMetrics(MachineModel m) {
  final h = m.healthScore;
  return [
    ('Titreşim', h >= 80 ? 'Normal' : h >= 60 ? 'Orta' : 'Yüksek',
        h >= 80 ? 'normal' : h >= 60 ? 'warning' : 'critical'),
    ('Sıcaklık', '${(40 + (100 - h) * 0.6).round()}°C',
        h >= 80 ? 'normal' : h >= 60 ? 'warning' : 'critical'),
    ('Gürültü', h >= 80 ? 'Minimal' : h >= 60 ? 'Orta' : 'Anormal',
        h >= 80 ? 'normal' : h >= 60 ? 'warning' : 'critical'),
    ('Yağ Basıncı', h >= 60 ? 'Normal' : 'Düşük',
        h >= 60 ? 'normal' : 'warning'),
  ];
}

List<String> _recommendations(MachineModel m) {
  if (m.healthScore < 40) {
    return [
      'Acil bakım planlaması yapın',
      'Ana bileşenleri inceleyin ve gerekirse değiştirin',
      'Yağlama sistemini kontrol edin',
    ];
  }
  if (m.healthScore < 70) {
    return [
      'Yakın dönemde bakım planlayın',
      'Titreşim ve sıcaklık değerlerini izleyin',
      'Wear parçalarını kontrol edin',
    ];
  }
  return ['Standart dönemsel bakımı sürdürün'];
}

String _riskDescription(MachineModel m) {
  if (m.healthScore < 40) return 'Kritik arıza riski yüksek — acil müdahale gerekli';
  if (m.healthScore < 70) return 'Performans düşüşü tespit edildi — yakında bakım önerilir';
  return 'Normal parametreler dahilinde çalışıyor';
}

String _nextServiceLabel(MachineModel m) {
  if (m.healthScore < 40) return 'Acil';
  if (m.healthScore < 60) return '1 hafta içinde';
  if (m.healthScore < 80) return '1 ay içinde';
  return '3 ay içinde';
}

Color _healthColor(int health) =>
    health >= 80 ? AppColors.success : health >= 60 ? AppColors.warning : AppColors.danger;

Color _statusColor(String status) => switch (status) {
      'normal' => AppColors.success,
      'warning' => AppColors.warning,
      'critical' => AppColors.danger,
      _ => AppColors.textTertiary,
    };

String _riskLabel(String status, AppLocalizations l10n) => switch (status) {
      'normal' => l10n.riskLow,
      'warning' => l10n.riskMedium,
      'critical' => l10n.riskHigh,
      _ => l10n.riskUnknown,
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
