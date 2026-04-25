import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';

enum _RegisterMode { manager, worker }

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _companyCtrl = TextEditingController();
  bool _obscure = true;
  _RegisterMode _mode = _RegisterMode.manager;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _companyCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final auth = context.read<AppAuthProvider>();
    bool ok;
    if (_mode == _RegisterMode.manager) {
      ok = await auth.registerManager(
        name: _nameCtrl.text,
        email: _emailCtrl.text,
        password: _passCtrl.text,
        companyName: _companyCtrl.text,
      );
    } else {
      ok = await auth.registerWorker(
        name: _nameCtrl.text,
        email: _emailCtrl.text,
        password: _passCtrl.text,
        companyId: _companyCtrl.text,
      );
    }
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.error ?? 'Kayıt başarısız.'),
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
        ),
      );
    }
    // On success, SplashRouter auto-navigates to MainShell
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AppAuthProvider>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            height: size.height * 0.38,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
            ),
          ),
          Positioned(
            top: -60,
            right: -50,
            child: _circle(200),
          ),
          Positioned(
            top: 40,
            left: -80,
            child: _circle(150),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        SizedBox(
                          height: size.height * 0.18,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: AppRadius.xlAll,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.15),
                                      blurRadius: 16,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(10),
                                child: Image.asset(
                                  'lib/icons/fixora.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(28),
                            ),
                          ),
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.pageHorizontal,
                            AppSpacing.xxxl,
                            AppSpacing.pageHorizontal,
                            AppSpacing.huge,
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Hesap Oluştur', style: AppTextStyles.h2),
                                const SizedBox(height: 4),
                                Text(
                                  'Hesap türünüzü seçin ve bilgilerinizi girin.',
                                  style: AppTextStyles.bodySm,
                                ),
                                const SizedBox(height: AppSpacing.lg),
                                // Mode toggle
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceVariant,
                                    borderRadius: AppRadius.lgAll,
                                  ),
                                  padding: const EdgeInsets.all(4),
                                  child: Row(
                                    children: [
                                      _ModeTab(
                                        label: 'Şirket Kur',
                                        icon: Icons.business_rounded,
                                        selected: _mode == _RegisterMode.manager,
                                        onTap: () => setState(
                                            () => _mode = _RegisterMode.manager),
                                      ),
                                      _ModeTab(
                                        label: 'Şirkete Katıl',
                                        icon: Icons.group_add_rounded,
                                        selected: _mode == _RegisterMode.worker,
                                        onTap: () => setState(
                                            () => _mode = _RegisterMode.worker),
                                      ),
                                    ],
                                  ),
                                ),
                                if (_mode == _RegisterMode.worker) ...[
                                  const SizedBox(height: AppSpacing.sm),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.md,
                                      vertical: AppSpacing.sm,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryLight,
                                      borderRadius: AppRadius.mdAll,
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.info_outline_rounded,
                                          size: 16,
                                          color: AppColors.primary,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'Yöneticinizden şirket kodunu alın.',
                                            style: AppTextStyles.bodySm.copyWith(
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                const SizedBox(height: AppSpacing.lg),
                                AppCard(
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: _nameCtrl,
                                        keyboardType: TextInputType.name,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        style: AppTextStyles.body,
                                        validator: (v) =>
                                            (v == null || v.trim().isEmpty)
                                                ? 'Ad Soyad gerekli'
                                                : null,
                                        decoration: const InputDecoration(
                                          labelText: 'Ad Soyad',
                                          prefixIcon: Icon(
                                              Icons.person_outline_rounded,
                                              size: 20),
                                        ),
                                      ),
                                      const SizedBox(height: AppSpacing.md),
                                      const AppDivider(),
                                      const SizedBox(height: AppSpacing.md),
                                      TextFormField(
                                        controller: _emailCtrl,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        style: AppTextStyles.body,
                                        validator: (v) =>
                                            (v == null || v.trim().isEmpty)
                                                ? 'E-posta gerekli'
                                                : null,
                                        decoration: const InputDecoration(
                                          labelText: 'E-posta',
                                          prefixIcon: Icon(
                                              Icons.email_outlined,
                                              size: 20),
                                        ),
                                      ),
                                      const SizedBox(height: AppSpacing.md),
                                      const AppDivider(),
                                      const SizedBox(height: AppSpacing.md),
                                      TextFormField(
                                        controller: _passCtrl,
                                        obscureText: _obscure,
                                        style: AppTextStyles.body,
                                        validator: (v) {
                                          if (v == null || v.isEmpty) {
                                            return 'Şifre gerekli';
                                          }
                                          if (v.length < 6) {
                                            return 'En az 6 karakter';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          labelText: 'Şifre',
                                          prefixIcon: const Icon(
                                              Icons.lock_outlined,
                                              size: 20),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _obscure
                                                  ? Icons.visibility_outlined
                                                  : Icons.visibility_off_outlined,
                                              size: 20,
                                              color: AppColors.textTertiary,
                                            ),
                                            onPressed: () => setState(
                                                () => _obscure = !_obscure),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: AppSpacing.md),
                                      const AppDivider(),
                                      const SizedBox(height: AppSpacing.md),
                                      TextFormField(
                                        controller: _companyCtrl,
                                        style: AppTextStyles.body,
                                        validator: (v) =>
                                            (v == null || v.trim().isEmpty)
                                                ? _mode ==
                                                        _RegisterMode.manager
                                                    ? 'Şirket adı gerekli'
                                                    : 'Şirket kodu gerekli'
                                                : null,
                                        decoration: InputDecoration(
                                          labelText: _mode ==
                                                  _RegisterMode.manager
                                              ? 'Şirket Adı'
                                              : 'Şirket Kodu',
                                          prefixIcon: Icon(
                                            _mode == _RegisterMode.manager
                                                ? Icons.business_outlined
                                                : Icons.vpn_key_outlined,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.xl),
                                AppButton(
                                  label: _mode == _RegisterMode.manager
                                      ? 'Şirket Kur'
                                      : 'Şirkete Katıl',
                                  icon: _mode == _RegisterMode.manager
                                      ? Icons.business_rounded
                                      : Icons.group_add_rounded,
                                  iconTrailing: true,
                                  expand: true,
                                  size: AppButtonSize.lg,
                                  isLoading: auth.loading,
                                  onPressed: auth.loading ? null : _submit,
                                ),
                                const SizedBox(height: AppSpacing.xl),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Zaten hesabınız var mı?',
                                      style: AppTextStyles.bodySm,
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(
                                        'Giriş Yap',
                                        style: AppTextStyles.bodySm.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _circle(double size) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.07),
        ),
      );
}

class _ModeTab extends StatelessWidget {
  const _ModeTab({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColors.surface : Colors.transparent,
            borderRadius: AppRadius.mdAll,
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: AppColors.shadowColor,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: selected ? AppColors.primary : AppColors.textTertiary,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTextStyles.bodySm.copyWith(
                  color: selected
                      ? AppColors.textPrimary
                      : AppColors.textTertiary,
                  fontWeight:
                      selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
