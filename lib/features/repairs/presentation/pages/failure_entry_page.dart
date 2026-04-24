import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../l10n/app_localizations.dart';

const _machineNames = [
  'CNC Torna #1',
  'Hidrolik Pres #3',
  'Hava Kompresörü A',
  'Konveyör Bant #2',
  'Su Pompası #1',
  'Elektrik Motoru #5',
  'Damga Presi #2',
  'Soğutma Kulesi',
];

const _severityIcons = [
  Icons.arrow_downward_rounded,
  Icons.remove_rounded,
  Icons.arrow_upward_rounded,
  Icons.priority_high_rounded,
];

const _severityColors = [
  Color(0xFF16A34A),
  Color(0xFFF59E0B),
  Color(0xFFEA580C),
  Color(0xFFDC2626),
];

class FailureEntryPage extends StatefulWidget {
  const FailureEntryPage({super.key});

  @override
  State<FailureEntryPage> createState() => _FailureEntryPageState();
}

class _FailureEntryPageState extends State<FailureEntryPage> {
  String? _machine;
  int _failureTypeIndex = 0;
  int _severityIndex = 1;
  final _descCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _descCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final l10n = AppLocalizations.of(context)!;
      if (_machine == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.validationSelectMachine),
            backgroundColor: AppColors.warning,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
          ),
        );
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.successFailureLogged),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final failureTypes = [
      l10n.failureTypeMechanical,
      l10n.failureTypeElectrical,
      l10n.failureTypeHydraulic,
      l10n.failureTypeSoftware,
      l10n.failureTypeStructural,
      l10n.failureTypeOther,
    ];

    final severityLabels = [
      l10n.severityLow,
      l10n.severityMedium,
      l10n.severityHigh,
      l10n.severityCritical,
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.pageLogFailure),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.border),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
          children: [
            const SizedBox(height: AppSpacing.sm),
            _buildMachinePicker(l10n),
            const SizedBox(height: AppSpacing.itemGap),
            _buildSection(
              title: l10n.sectionFailureType,
              child: Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: failureTypes.asMap().entries.map((entry) {
                  final i = entry.key;
                  final t = entry.value;
                  final selected = _failureTypeIndex == i;
                  return GestureDetector(
                    onTap: () => setState(() => _failureTypeIndex = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected ? AppColors.primaryLight : AppColors.surfaceVariant,
                        borderRadius: AppRadius.fullAll,
                        border: Border.all(
                          color: selected ? AppColors.primary : AppColors.border,
                        ),
                      ),
                      child: Text(
                        t,
                        style: AppTextStyles.label.copyWith(
                          color: selected ? AppColors.primary : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.itemGap),
            _buildSection(
              title: l10n.sectionSeverity,
              child: Row(
                children: List.generate(severityLabels.length, (i) {
                  final color = _severityColors[i];
                  final selected = _severityIndex == i;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: i < severityLabels.length - 1 ? 8 : 0),
                      child: GestureDetector(
                        onTap: () => setState(() => _severityIndex = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: selected ? color.withValues(alpha: 0.12) : AppColors.surfaceVariant,
                            borderRadius: AppRadius.mdAll,
                            border: Border.all(
                              color: selected ? color : AppColors.border,
                              width: selected ? 1.5 : 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(_severityIcons[i], color: color, size: 18),
                              const SizedBox(height: 4),
                              Text(
                                severityLabels[i],
                                style: AppTextStyles.caption.copyWith(
                                  color: selected ? color : AppColors.textSecondary,
                                  fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: AppSpacing.itemGap),
            _buildSection(
              title: l10n.sectionDescription,
              child: TextFormField(
                controller: _descCtrl,
                maxLines: 5,
                style: AppTextStyles.body,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? l10n.validationDescriptionRequired
                    : null,
                decoration: InputDecoration(hintText: l10n.hintDescription),
              ),
            ),
            const SizedBox(height: AppSpacing.itemGap),
            AppCard(
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: AppRadius.mdAll,
                    ),
                    child: const Icon(Icons.schedule_rounded,
                        color: AppColors.textSecondary, size: 18),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.reportedAt, style: AppTextStyles.label),
                      const SizedBox(height: 2),
                      Text(_formatNow(),
                          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: AppRadius.mdAll,
                    ),
                    child: const Icon(Icons.person_outline_rounded,
                        color: AppColors.textSecondary, size: 18),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.reportedBy, style: AppTextStyles.label),
                      const SizedBox(height: 2),
                      Text('İbrahim K.',
                          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sectionGap),
            AppButton(
              label: l10n.btnSubmitFailure,
              icon: Icons.send_rounded,
              iconTrailing: true,
              onPressed: _submit,
              variant: AppButtonVariant.danger,
              expand: true,
              size: AppButtonSize.lg,
            ),
            const SizedBox(height: AppSpacing.huge),
          ],
        ),
      ),
    );
  }

  Widget _buildMachinePicker(AppLocalizations l10n) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.fieldMachine, style: AppTextStyles.label),
          const SizedBox(height: AppSpacing.sm),
          DropdownButtonFormField<String>(
            // ignore: deprecated_member_use
            value: _machine,
            hint: Text(l10n.hintSelectMachine,
                style: AppTextStyles.body.copyWith(color: AppColors.textTertiary)),
            icon: const Icon(Icons.expand_more_rounded, color: AppColors.textSecondary),
            style: AppTextStyles.body,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            onChanged: (v) => setState(() => _machine = v),
            items: _machineNames
                .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.label),
          const SizedBox(height: AppSpacing.md),
          child,
        ],
      ),
    );
  }

  String _formatNow() {
    final now = DateTime.now();
    final h = now.hour.toString().padLeft(2, '0');
    final m = now.minute.toString().padLeft(2, '0');
    return '${now.day}/${now.month}/${now.year}  $h:$m';
  }
}
