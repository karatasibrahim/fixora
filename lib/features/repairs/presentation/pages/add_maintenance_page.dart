import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/machine_model.dart';
import '../../data/models/maintenance_model.dart';
import '../../data/repositories/failure_repository.dart';
import '../../data/repositories/machine_repository.dart';

class AddMaintenancePage extends StatefulWidget {
  const AddMaintenancePage({super.key, this.preselectedMachine});
  final MachineModel? preselectedMachine;

  @override
  State<AddMaintenancePage> createState() => _AddMaintenancePageState();
}

class _AddMaintenancePageState extends State<AddMaintenancePage> {
  final _repo = FailureRepository();
  final _machineRepo = MachineRepository();
  final _formKey = GlobalKey<FormState>();
  final _taskCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  MachineModel? _selectedMachine;
  DateTime? _scheduledDate;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _selectedMachine = widget.preselectedMachine;
  }

  @override
  void dispose() {
    _taskCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _scheduledDate = picked);
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final l10n = AppLocalizations.of(context)!;

    if (_selectedMachine == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(l10n.validationSelectMachine),
        backgroundColor: AppColors.warning,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
      ));
      return;
    }
    if (_scheduledDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(l10n.validationScheduledDateRequired),
        backgroundColor: AppColors.warning,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
      ));
      return;
    }

    setState(() => _submitting = true);
    final user = context.read<AppAuthProvider>().user!;

    try {
      await _repo.addMaintenance(MaintenanceModel(
        id: '',
        companyId: user.companyId,
        machineId: _selectedMachine!.id,
        machineName: _selectedMachine!.name,
        task: _taskCtrl.text.trim(),
        scheduledDate: _scheduledDate!,
        isOverdue: false,
        status: 'pending',
        createdAt: DateTime.now(),
      ));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(l10n.successMaintenancePlanned),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
      ));
      Navigator.pop(context);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Kayıt sırasında bir hata oluştu.'),
        backgroundColor: AppColors.danger,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
      ));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final companyId = context.watch<AppAuthProvider>().user?.companyId ?? '';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.pageAddMaintenance),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _submitting ? null : _submit,
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

            // Makine seçici
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.fieldMachine, style: AppTextStyles.label),
                  const SizedBox(height: AppSpacing.sm),
                  companyId.isEmpty
                      ? const SizedBox.shrink()
                      : StreamBuilder<List<MachineModel>>(
                          stream: _machineRepo.watchMachines(companyId),
                          builder: (context, snap) {
                            final machines = snap.data ?? [];
                            return DropdownButtonFormField<String>(
                              initialValue: _selectedMachine?.id,
                              hint: Text(
                                l10n.hintSelectMachine,
                                style: AppTextStyles.body.copyWith(
                                    color: AppColors.textTertiary),
                              ),
                              icon: const Icon(Icons.expand_more_rounded,
                                  color: AppColors.textSecondary),
                              style: AppTextStyles.body,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 12),
                              ),
                              onChanged: (id) => setState(() {
                                _selectedMachine = machines
                                    .where((m) => m.id == id)
                                    .firstOrNull;
                              }),
                              items: machines
                                  .map((m) => DropdownMenuItem(
                                        value: m.id,
                                        child: Text(m.name),
                                      ))
                                  .toList(),
                            );
                          },
                        ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.itemGap),

            // Görev & tarih
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.sectionMaintenanceTask, style: AppTextStyles.label),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _taskCtrl,
                    style: AppTextStyles.body,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? l10n.validationTaskRequired
                        : null,
                    decoration: InputDecoration(
                      labelText: l10n.fieldMaintenanceTask,
                      hintText: l10n.hintMaintenanceTask,
                      prefixIcon: const Icon(Icons.build_circle_outlined,
                          size: 20),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const AppDivider(),
                  const SizedBox(height: AppSpacing.md),
                  GestureDetector(
                    onTap: _pickDate,
                    child: AbsorbPointer(
                      child: TextFormField(
                        readOnly: true,
                        style: AppTextStyles.body,
                        controller: TextEditingController(
                          text: _scheduledDate == null
                              ? ''
                              : _formatDate(_scheduledDate!),
                        ),
                        decoration: InputDecoration(
                          labelText: l10n.fieldScheduledDate,
                          hintText: l10n.hintScheduledDate,
                          prefixIcon: const Icon(
                              Icons.calendar_today_rounded,
                              size: 20),
                          suffixIcon: _scheduledDate != null
                              ? _DateChip(date: _scheduledDate!)
                              : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.itemGap),

            // Notlar
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.sectionNotes, style: AppTextStyles.label),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _notesCtrl,
                    maxLines: 3,
                    style: AppTextStyles.body,
                    decoration: InputDecoration(hintText: l10n.hintNotes),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.sectionGap),

            AppButton(
              label: l10n.btnSaveMaintenance,
              icon: Icons.event_available_rounded,
              iconTrailing: true,
              isLoading: _submitting,
              onPressed: _submitting ? null : _submit,
              expand: true,
              size: AppButtonSize.lg,
            ),

            const SizedBox(height: AppSpacing.huge),
          ],
        ),
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  const _DateChip({required this.date});
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final diff = date.difference(DateTime.now()).inDays;
    final Color color;
    final String label;
    if (diff == 0) {
      color = AppColors.warning;
      label = 'Bugün';
    } else if (diff == 1) {
      color = AppColors.primary;
      label = 'Yarın';
    } else {
      color = AppColors.primary;
      label = '$diff gün sonra';
    }

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label,
            style: AppTextStyles.caption.copyWith(color: color)),
        backgroundColor: color.withValues(alpha: 0.1),
        side: BorderSide(color: color.withValues(alpha: 0.3)),
        padding: EdgeInsets.zero,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

String _formatDate(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
