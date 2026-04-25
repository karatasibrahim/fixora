import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../auth/presentation/pages/login_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  int _page = 0;

  final _slides = const [
    _Slide(
      icon: Icons.precision_manufacturing_rounded,
      title: 'Her Arızayı Kaydet',
      subtitle:
          'Makinelerin arızalarını anlık olarak kaydedin. Hangi makine, ne zaman, nasıl arıza yaptı — hepsi elinizin altında.',
    ),
    _Slide(
      icon: Icons.analytics_rounded,
      title: 'Bakımı Önceden Tahmin Et',
      subtitle:
          'Yapay zeka destekli analizlerle makinelerinizin sağlık durumunu takip edin ve arızaları oluşmadan önleyin.',
    ),
  ];

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _page == _slides.length - 1;

    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
            ),
          ),
          // Decorative circles
          Positioned(
            top: -80,
            right: -60,
            child: _DecorCircle(size: 280),
          ),
          Positioned(
            bottom: 180,
            left: -100,
            child: _DecorCircle(size: 240),
          ),
          Positioned(
            top: 160,
            left: -40,
            child: _DecorCircle(size: 120),
          ),
          // Content
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: _slides.length,
                    onPageChanged: (i) => setState(() => _page = i),
                    itemBuilder: (_, i) => _slides[i],
                  ),
                ),
                // Dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _slides.length,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _page == i ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _page == i
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.35),
                        borderRadius: AppRadius.fullAll,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                // Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.pageHorizontal,
                  ),
                  child: Column(
                    children: [
                      AppButton(
                        label: isLast ? 'Başla' : 'İleri',
                        icon: isLast
                            ? Icons.arrow_forward_rounded
                            : Icons.chevron_right_rounded,
                        iconTrailing: true,
                        expand: true,
                        size: AppButtonSize.lg,
                        onPressed: () {
                          if (isLast) {
                            _finish();
                          } else {
                            _controller.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                      ),
                      if (!isLast) ...[
                        const SizedBox(height: AppSpacing.sm),
                        TextButton(
                          onPressed: _finish,
                          child: Text(
                            'Atla',
                            style: AppTextStyles.body.copyWith(
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  const _Slide({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: AppRadius.xlAll,
            ),
            child: Icon(icon, size: 72, color: Colors.white),
          ),
          const SizedBox(height: AppSpacing.xxxl),
          Text(
            title,
            style: AppTextStyles.h1.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            subtitle,
            style: AppTextStyles.bodyLg.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _DecorCircle extends StatelessWidget {
  const _DecorCircle({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.06),
      ),
    );
  }
}
