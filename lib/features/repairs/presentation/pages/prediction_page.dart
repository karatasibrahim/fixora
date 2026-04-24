import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../l10n/app_localizations.dart';

const _machineHealth = [
  {
    'name': 'CNC Torna #1',
    'type': 'CNC',
    'health': 32,
    'status': 'critical',
    'risk': '3 gün içinde rulman arızası yüksek riski',
    'nextMaintenance': 'Acil',
    'recommendations': [
      'Ana iş mili yatağını değiştirin',
      'Yağlama sistemini kontrol edin',
      'Tahrik kayışı gerginliğini inceleyin',
    ],
    'metrics': [
      {'label': 'Titreşim', 'value': 'Yüksek', 'status': 'critical'},
      {'label': 'Sıcaklık', 'value': '94°C', 'status': 'warning'},
      {'label': 'Gürültü', 'value': 'Anormal', 'status': 'critical'},
      {'label': 'Yağ Basıncı', 'value': 'Normal', 'status': 'active'},
    ],
  },
  {
    'name': 'Hidrolik Pres #3',
    'type': 'Hydraulic',
    'health': 61,
    'status': 'warning',
    'risk': 'Hidrolik conta bozunması tespit edildi',
    'nextMaintenance': '2 hafta içinde',
    'recommendations': [
      'Hidrolik contaları inceleyin',
      'Sıvı seviyesi ve kalitesini kontrol edin',
      'Basınç farkını izleyin',
    ],
    'metrics': [
      {'label': 'Basınç', 'value': '180 bar', 'status': 'warning'},
      {'label': 'Sıcaklık', 'value': '68°C', 'status': 'active'},
      {'label': 'Titreşim', 'value': 'Normal', 'status': 'active'},
      {'label': 'Sıvı Seviyesi', 'value': 'Düşük', 'status': 'warning'},
    ],
  },
  {
    'name': 'Konveyör Bant #2',
    'type': 'Conveyor',
    'health': 87,
    'status': 'active',
    'risk': 'Anlık risk tespit edilmedi',
    'nextMaintenance': '45 gün içinde',
    'recommendations': [
      'Rutin bant gerginlik kontrolü',
      'Tahrik zincirini yağlayın',
    ],
    'metrics': [
      {'label': 'Bant Gerginliği', 'value': 'Normal', 'status': 'active'},
      {'label': 'Hız', 'value': '1.2 m/s', 'status': 'active'},
      {'label': 'Titreşim', 'value': 'Düşük', 'status': 'active'},
      {'label': 'Motor Sıcaklığı', 'value': '42°C', 'status': 'active'},
    ],
  },
  {
    'name': 'Elektrik Motoru #5',
    'type': 'Motor',
    'health': 93,
    'status': 'active',
    'risk': 'Normal parametreler dahilinde çalışıyor',
    'nextMaintenance': '60 gün içinde',
    'recommendations': [
      'Standart dönemsel bakım',
    ],
    'metrics': [
      {'label': 'Akım Çekimi', 'value': 'Normal', 'status': 'active'},
      {'label': 'Sıcaklık', 'value': '38°C', 'status': 'active'},
      {'label': 'Titreşim', 'value': 'Minimal', 'status': 'active'},
      {'label': 'İzolasyon', 'value': 'İyi', 'status': 'active'},
    ],
  },
];

class PredictionPage extends StatefulWidget {
  const PredictionPage({super.key});

  @override
  State<PredictionPage> createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  int _selected = 0;

  Map<String, dynamic> get _current =>
      _machineHealth[_selected] as Map<String, dynamic>;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final top = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader(l10n, top)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.pageHorizontal,
              vertical: AppSpacing.pageVertical,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildHealthGauge(l10n),
                const SizedBox(height: AppSpacing.itemGap),
                _buildRiskBanner(),
                const SizedBox(height: AppSpacing.sectionGap),
                SectionHeader(title: l10n.sectionHealthMetrics),
                const SizedBox(height: AppSpacing.itemGap),
                _buildMetrics(),
                const SizedBox(height: AppSpacing.sectionGap),
                SectionHeader(title: l10n.sectionRecommendations),
                const SizedBox(height: AppSpacing.itemGap),
                _buildRecommendations(),
                const SizedBox(height: AppSpacing.sectionGap),
                SectionHeader(title: l10n.sectionAllMachines),
                const SizedBox(height: AppSpacing.itemGap),
                _buildMachineList(l10n),
                const SizedBox(height: AppSpacing.huge),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n, double top) {
    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.fromLTRB(AppSpacing.pageHorizontal, top + 16, AppSpacing.pageHorizontal, 16),
      child: Row(
        children: [
          Expanded(child: Text(l10n.pagePredictions, style: AppTextStyles.h2)),
          AppIconButton(
            icon: Icons.info_outline_rounded,
            onTap: () {},
            tooltip: l10n.tooltipAboutPredictions,
          ),
        ],
      ),
    );
  }

  Widget _buildHealthGauge(AppLocalizations l10n) {
    final health = _current['health'] as int;
    final status = _current['status'] as String;
    final color = _healthColor(health);

    return AppCard(
      child: Column(
        children: [
          Text(_current['name'] as String, style: AppTextStyles.h3),
          const SizedBox(height: 4),
          Text(_current['type'] as String, style: AppTextStyles.bodySm),
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
                    value: health / 100,
                    backgroundColor: AppColors.border,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    strokeWidth: 14,
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('$health%', style: AppTextStyles.statLg.copyWith(color: color)),
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
                value: _current['nextMaintenance'] as String,
                icon: Icons.build_circle_outlined,
                color: AppColors.primary,
              ),
              Container(width: 1, height: 40, color: AppColors.divider),
              _GaugeStat(
                label: l10n.labelRiskLevel,
                value: _riskLabel(status, l10n),
                icon: Icons.shield_outlined,
                color: color,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRiskBanner() {
    final health = _current['health'] as int;
    final color = _healthColor(health);
    final bgColor = health >= 80
        ? AppColors.successLight
        : health >= 60
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
              _current['risk'] as String,
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

  Widget _buildMetrics() {
    final metrics = (_current['metrics'] as List).cast<Map<String, dynamic>>();

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: AppSpacing.itemGap,
      mainAxisSpacing: AppSpacing.itemGap,
      childAspectRatio: 2.0,
      children: metrics.map((m) {
        final mStatus = m['status'] as String;
        final color = _statusColor(mStatus);
        return AppCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(m['label'] as String, style: AppTextStyles.caption),
                    const SizedBox(height: 2),
                    Text(m['value'] as String,
                        style: AppTextStyles.h4.copyWith(fontSize: 14),
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRecommendations() {
    final recs = (_current['recommendations'] as List).cast<String>();

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

  Widget _buildMachineList(AppLocalizations l10n) {
    return Column(
      children: _machineHealth.asMap().entries.map((entry) {
        final i = entry.key;
        final m = entry.value as Map<String, dynamic>;
        final health = m['health'] as int;
        final color = _healthColor(health);
        final isSelected = _selected == i;

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
                    child: Icon(_machineIcon(m['type'] as String), color: color, size: 20),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(m['name'] as String, style: AppTextStyles.h4),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: AppRadius.fullAll,
                                child: LinearProgressIndicator(
                                  value: health / 100,
                                  minHeight: 4,
                                  backgroundColor: AppColors.border,
                                  valueColor: AlwaysStoppedAnimation<Color>(color),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              '$health%',
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
                    color: isSelected ? AppColors.primary : AppColors.textTertiary,
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

Color _healthColor(int health) =>
    health >= 80 ? AppColors.success : health >= 60 ? AppColors.warning : AppColors.danger;

Color _statusColor(String status) => switch (status) {
      'active' => AppColors.success,
      'warning' => AppColors.warning,
      'critical' => AppColors.danger,
      _ => AppColors.textTertiary,
    };

String _riskLabel(String status, AppLocalizations l10n) => switch (status) {
      'active' => l10n.riskLow,
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
