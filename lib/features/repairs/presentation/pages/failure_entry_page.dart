import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/failure_model.dart';
import '../../data/models/machine_model.dart';
import '../../data/repositories/failure_repository.dart';
import '../../data/repositories/machine_repository.dart';

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

const _severityKeys = ['low', 'medium', 'high', 'critical'];

class FailureEntryPage extends StatefulWidget {
  const FailureEntryPage({super.key, this.preselectedMachine});
  final MachineModel? preselectedMachine;

  @override
  State<FailureEntryPage> createState() => _FailureEntryPageState();
}

class _FailureEntryPageState extends State<FailureEntryPage> {
  final _repo = FailureRepository();
  final _machineRepo = MachineRepository();
  final _storageService = StorageService();
  final _picker = ImagePicker();
  MachineModel? _selectedMachine;
  int _failureTypeIndex = 0;
  int _severityIndex = 1;
  final _descCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _submitting = false;
  final List<File> _images = [];

  @override
  void initState() {
    super.initState();
    _selectedMachine = widget.preselectedMachine;
  }

  @override
  void dispose() {
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 1920,
    );
    if (picked != null && _images.length < 5) {
      setState(() => _images.add(File(picked.path)));
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: AppRadius.fullAll,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Galeriden Seç'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Fotoğraf Çek'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.camera);
              },
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final l10n = AppLocalizations.of(context)!;
    if (_selectedMachine == null) {
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

    setState(() => _submitting = true);
    final auth = context.read<AppAuthProvider>();
    final user = auth.user!;
    final failureTypes = _failureTypeKeys(l10n);

    try {
      final imageUrls = _images.isEmpty
          ? <String>[]
          : await _storageService.uploadFailureImages(
              companyId: user.companyId,
              uid: user.uid,
              images: _images,
            );

      await _repo.addFailure(FailureModel(
        id: '',
        companyId: user.companyId,
        machineId: _selectedMachine!.id,
        machineName: _selectedMachine!.name,
        type: failureTypes[_failureTypeIndex],
        severity: _severityKeys[_severityIndex],
        description: _descCtrl.text.trim(),
        reportedBy: user.uid,
        reportedByName: user.name,
        reportedAt: DateTime.now(),
        imageUrls: imageUrls,
      ));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.successFailureLogged),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Kayıt sırasında bir hata oluştu.'),
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
        ),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  List<String> _failureTypeKeys(AppLocalizations l10n) => [
        l10n.failureTypeMechanical,
        l10n.failureTypeElectrical,
        l10n.failureTypeHydraulic,
        l10n.failureTypeSoftware,
        l10n.failureTypeStructural,
        l10n.failureTypeOther,
      ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = context.watch<AppAuthProvider>().user;
    final companyId = user?.companyId ?? '';
    final failureTypes = _failureTypeKeys(l10n);

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
            _buildMachinePicker(l10n, companyId),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.primaryLight
                            : AppColors.surfaceVariant,
                        borderRadius: AppRadius.fullAll,
                        border: Border.all(
                          color: selected
                              ? AppColors.primary
                              : AppColors.border,
                        ),
                      ),
                      child: Text(
                        t,
                        style: AppTextStyles.label.copyWith(
                          color: selected
                              ? AppColors.primary
                              : AppColors.textSecondary,
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
                      padding: EdgeInsets.only(
                          right: i < severityLabels.length - 1 ? 8 : 0),
                      child: GestureDetector(
                        onTap: () => setState(() => _severityIndex = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding:
                              const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: selected
                                ? color.withValues(alpha: 0.12)
                                : AppColors.surfaceVariant,
                            borderRadius: AppRadius.mdAll,
                            border: Border.all(
                              color: selected ? color : AppColors.border,
                              width: selected ? 1.5 : 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(_severityIcons[i],
                                  color: color, size: 18),
                              const SizedBox(height: 4),
                              Text(
                                severityLabels[i],
                                style: AppTextStyles.caption.copyWith(
                                  color: selected
                                      ? color
                                      : AppColors.textSecondary,
                                  fontWeight: selected
                                      ? FontWeight.w700
                                      : FontWeight.w400,
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
            _buildSection(
              title: 'Fotoğraflar (max 5)',
              child: Column(
                children: [
                  if (_images.isNotEmpty)
                    SizedBox(
                      height: 90,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _images.length,
                        separatorBuilder: (context, i) =>
                            const SizedBox(width: AppSpacing.sm),
                        itemBuilder: (_, i) => Stack(
                          children: [
                            ClipRRect(
                              borderRadius: AppRadius.mdAll,
                              child: Image.file(
                                _images[i],
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () =>
                                    setState(() => _images.removeAt(i)),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: AppRadius.fullAll,
                                  ),
                                  padding: const EdgeInsets.all(3),
                                  child: const Icon(Icons.close,
                                      size: 14, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (_images.isNotEmpty)
                    const SizedBox(height: AppSpacing.md),
                  if (_images.length < 5)
                    GestureDetector(
                      onTap: _showImageSourceSheet,
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: AppRadius.mdAll,
                          border: Border.all(
                              color: AppColors.border,
                              style: BorderStyle.solid),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add_a_photo_outlined,
                                color: AppColors.textSecondary, size: 20),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              'Fotoğraf Ekle',
                              style: AppTextStyles.body.copyWith(
                                  color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
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
                      Text(
                        _formatNow(),
                        style: AppTextStyles.body
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
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
                      Text(
                        _firstName(user?.name ?? ''),
                        style: AppTextStyles.body
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
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
              isLoading: _submitting,
              onPressed: _submitting ? null : _submit,
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

  Widget _buildMachinePicker(AppLocalizations l10n, String companyId) {
    return AppCard(
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
                        style: AppTextStyles.body
                            .copyWith(color: AppColors.textTertiary),
                      ),
                      icon: const Icon(Icons.expand_more_rounded,
                          color: AppColors.textSecondary),
                      style: AppTextStyles.body,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                      ),
                      onChanged: (id) {
                        setState(() {
                          _selectedMachine = machines
                              .where((m) => m.id == id)
                              .firstOrNull;
                        });
                      },
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

  String _firstName(String fullName) {
    final parts = fullName.trim().split(' ');
    if (parts.length <= 1) return fullName;
    return '${parts.first} ${parts.last[0]}.';
  }
}
