import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../auth/data/models/user_model.dart';

class TeamPage extends StatelessWidget {
  const TeamPage({super.key});

  Stream<List<UserModel>> _watchTeam(String companyId) {
    return FirebaseFirestore.instance
        .collection('users')
        .where('companyId', isEqualTo: companyId)
        .snapshots()
        .map((s) => s.docs
            .map((d) => UserModel.fromMap(d.data(), d.id))
            .toList()
          ..sort((a, b) => a.name.compareTo(b.name)));
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AppAuthProvider>().user;
    final companyId = user?.companyId ?? '';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Ekip'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.border),
        ),
      ),
      body: companyId.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<List<UserModel>>(
              stream: _watchTeam(companyId),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting &&
                    !snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final members = snap.data ?? [];

                return ListView(
                  padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
                  children: [
                    const SizedBox(height: AppSpacing.sm),
                    _CompanyCodeCard(companyId: companyId),
                    const SizedBox(height: AppSpacing.sectionGap),
                    Padding(
                      padding:
                          const EdgeInsets.only(bottom: AppSpacing.itemGap),
                      child: Text(
                        'Üyeler (${members.length})',
                        style: AppTextStyles.label,
                      ),
                    ),
                    AppCard(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: members.asMap().entries.map((entry) {
                          final i = entry.key;
                          final m = entry.value;
                          return Column(
                            children: [
                              ListTile(
                                contentPadding:
                                    const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.cardPadding,
                                  vertical: 6,
                                ),
                                leading: Container(
                                  width: 42,
                                  height: 42,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: AppRadius.fullAll,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    m.initials,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ),
                                title: Text(m.name, style: AppTextStyles.h4),
                                subtitle: Text(m.email,
                                    style: AppTextStyles.bodySm),
                                trailing: AppBadge(
                                  label: m.isManager ? 'Yönetici' : 'Çalışan',
                                  variant: m.isManager
                                      ? BadgeVariant.primary
                                      : BadgeVariant.neutral,
                                ),
                              ),
                              if (i < members.length - 1)
                                const Divider(
                                  height: 1,
                                  indent: 70,
                                  color: AppColors.divider,
                                ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.huge),
                  ],
                );
              },
            ),
    );
  }
}

class _CompanyCodeCard extends StatefulWidget {
  const _CompanyCodeCard({required this.companyId});
  final String companyId;

  @override
  State<_CompanyCodeCard> createState() => _CompanyCodeCardState();
}

class _CompanyCodeCardState extends State<_CompanyCodeCard> {
  bool _copied = false;

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.companyId));
    setState(() => _copied = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.primaryLight,
      border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      shadows: const [],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.vpn_key_rounded,
                  color: AppColors.primary, size: 16),
              const SizedBox(width: 8),
              Text(
                'Şirket Kodu',
                style: AppTextStyles.label
                    .copyWith(color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Çalışanlarınız bu kodu kullanarak şirkete katılabilir.',
            style: AppTextStyles.bodySm
                .copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: AppRadius.mdAll,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    widget.companyId,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                      color: AppColors.textPrimary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              GestureDetector(
                onTap: _copy,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: _copied ? AppColors.success : AppColors.primary,
                    borderRadius: AppRadius.mdAll,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _copied
                            ? Icons.check_rounded
                            : Icons.copy_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _copied ? 'Kopyalandı' : 'Kopyala',
                        style: AppTextStyles.label
                            .copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
