import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../l10n/app_localizations.dart';

class AddMachinePage extends StatefulWidget {
  const AddMachinePage({super.key});

  @override
  State<AddMachinePage> createState() => _AddMachinePageState();
}

class _AddMachinePageState extends State<AddMachinePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _manufacturerCtrl = TextEditingController();
  final _modelCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  int _typeIndex = 0;
  DateTime? _installDate;

  List<String> _typeLabels(AppLocalizations l10n) => [
        l10n.machineTypeCNC,
        l10n.machineTypeHydraulic,
        l10n.machineTypeCompressor,
        l10n.machineTypeConveyor,
        l10n.machineTypePump,
        l10n.machineTypeMotor,
        l10n.machineTypeHVAC,
        l10n.machineTypePress,
        l10n.machineTypeOther,
      ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _locationCtrl.dispose();
    _manufacturerCtrl.dispose();
    _modelCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _installDate = picked);
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.successMachineAdded(_nameCtrl.text)),
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
    final types = _typeLabels(l10n);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.pageAddMachine),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _submit,
            child: Text(
              l10n.save,
              style: AppTextStyles.button.copyWith(color: AppColors.primary),
            ),
          ),
          const SizedBox(width: 8),
        ],
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
            _buildIconPicker(types),
            const SizedBox(height: AppSpacing.sectionGap),
            _buildSection(
              title: l10n.sectionBasicInfo,
              children: [
                _field(l10n.fieldMachineName, _nameCtrl, l10n,
                    hint: l10n.hintMachineName, required: true),
                const SizedBox(height: AppSpacing.md),
                _buildTypeSelector(types),
                const SizedBox(height: AppSpacing.md),
                _field(l10n.fieldLocation, _locationCtrl, l10n,
                    hint: l10n.hintLocation, required: true),
              ],
            ),
            const SizedBox(height: AppSpacing.itemGap),
            _buildSection(
              title: l10n.sectionSpecifications,
              children: [
                _field(l10n.fieldManufacturer, _manufacturerCtrl, l10n,
                    hint: l10n.hintManufacturer),
                const SizedBox(height: AppSpacing.md),
                _field(l10n.fieldModel, _modelCtrl, l10n, hint: l10n.hintModel),
                const SizedBox(height: AppSpacing.md),
                _buildDatePicker(l10n),
              ],
            ),
            const SizedBox(height: AppSpacing.itemGap),
            _buildSection(
              title: l10n.sectionNotes,
              children: [
                TextFormField(
                  controller: _notesCtrl,
                  maxLines: 4,
                  style: AppTextStyles.body,
                  decoration: InputDecoration(hintText: l10n.hintNotes),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sectionGap),
            AppButton(
              label: l10n.btnSaveMachine,
              icon: Icons.check_rounded,
              onPressed: _submit,
              expand: true,
              size: AppButtonSize.lg,
            ),
            const SizedBox(height: AppSpacing.huge),
          ],
        ),
      ),
    );
  }

  Widget _buildIconPicker(List<String> types) {
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: AppRadius.xlAll,
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(_machineIconForIndex(_typeIndex), size: 40, color: AppColors.primary),
          ),
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: AppRadius.fullAll,
            ),
            child: const Icon(Icons.edit_rounded, size: 14, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.label),
          const SizedBox(height: AppSpacing.md),
          ...children,
        ],
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController ctrl,
    AppLocalizations l10n, {
    String hint = '',
    bool required = false,
  }) {
    return TextFormField(
      controller: ctrl,
      style: AppTextStyles.body,
      validator: required
          ? (v) =>
              (v == null || v.trim().isEmpty) ? l10n.validationRequired(label) : null
          : null,
      decoration: InputDecoration(labelText: label, hintText: hint),
    );
  }

  Widget _buildTypeSelector(List<String> types) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.fieldMachineType, style: AppTextStyles.label),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: types.asMap().entries.map((entry) {
            final i = entry.key;
            final t = entry.value;
            final selected = _typeIndex == i;
            return GestureDetector(
              onTap: () => setState(() => _typeIndex = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : AppColors.surfaceVariant,
                  borderRadius: AppRadius.fullAll,
                  border: Border.all(color: selected ? AppColors.primary : AppColors.border),
                ),
                child: Text(
                  t,
                  style: AppTextStyles.label.copyWith(
                    color: selected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDatePicker(AppLocalizations l10n) {
    return GestureDetector(
      onTap: _pickDate,
      child: AbsorbPointer(
        child: TextFormField(
          readOnly: true,
          style: AppTextStyles.body,
          decoration: InputDecoration(
            labelText: l10n.fieldInstallDate,
            hintText: l10n.hintSelectDate,
            suffixIcon: const Icon(Icons.calendar_today_rounded, size: 18),
          ),
          controller: TextEditingController(
            text: _installDate == null
                ? ''
                : '${_installDate!.day}/${_installDate!.month}/${_installDate!.year}',
          ),
        ),
      ),
    );
  }
}

IconData _machineIconForIndex(int index) {
  const icons = [
    Icons.precision_manufacturing_rounded,
    Icons.settings_input_component_rounded,
    Icons.air_rounded,
    Icons.linear_scale_rounded,
    Icons.water_drop_rounded,
    Icons.electric_bolt_rounded,
    Icons.ac_unit_rounded,
    Icons.compress_rounded,
    Icons.build_rounded,
  ];
  return index < icons.length ? icons[index] : Icons.build_rounded;
}
