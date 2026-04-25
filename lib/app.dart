import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/constants/constants.dart';
import 'core/locale/locale_notifier.dart';
import 'core/providers/auth_provider.dart';
import 'core/services/auth_service.dart';
import 'core/services/firestore_service.dart';
import 'core/theme/theme.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/onboarding/presentation/pages/onboarding_page.dart';
import 'l10n/app_localizations.dart';
import 'shared/presentation/main_shell.dart';

class FixoraApp extends StatelessWidget {
  const FixoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    final lightBase = AppTheme.light;
    final darkBase = AppTheme.dark;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppAuthProvider(AuthService(), FirestoreService()),
        ),
      ],
      child: ListenableBuilder(
        listenable: Listenable.merge([localeNotifier, themeNotifier]),
        builder: (context, child) => MaterialApp(
          title: 'Fixora',
          debugShowCheckedModeBanner: false,
          locale: localeNotifier.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          themeMode: themeNotifier.mode,
          theme: lightBase.copyWith(
            textTheme: GoogleFonts.interTextTheme(lightBase.textTheme),
          ),
          darkTheme: darkBase.copyWith(
            textTheme: GoogleFonts.interTextTheme(darkBase.textTheme),
          ),
          home: const SplashRouter(),
        ),
      ),
    );
  }
}

class SplashRouter extends StatelessWidget {
  const SplashRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _SplashScreen();
        }
        if (snapshot.data != null) {
          // Logged in — load user data then show main shell
          return const _AuthenticatedRouter();
        }
        return const _OnboardingOrLoginRouter();
      },
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: AppRadius.xlAll,
              ),
              child: const Icon(
                Icons.precision_manufacturing_rounded,
                color: Colors.white,
                size: 44,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Fixora',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthenticatedRouter extends StatefulWidget {
  const _AuthenticatedRouter();

  @override
  State<_AuthenticatedRouter> createState() => _AuthenticatedRouterState();
}

class _AuthenticatedRouterState extends State<_AuthenticatedRouter> {
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<AppAuthProvider>().loadCurrentUser();
      if (mounted) setState(() => _loaded = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) return const _SplashScreen();
    return const MainShell();
  }
}

class _OnboardingOrLoginRouter extends StatefulWidget {
  const _OnboardingOrLoginRouter();

  @override
  State<_OnboardingOrLoginRouter> createState() =>
      _OnboardingOrLoginRouterState();
}

class _OnboardingOrLoginRouterState extends State<_OnboardingOrLoginRouter> {
  bool? _onboardingDone;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    final prefs = await SharedPreferences.getInstance();
    final done = prefs.getBool('onboarding_done') ?? false;
    if (mounted) setState(() => _onboardingDone = done);
  }

  @override
  Widget build(BuildContext context) {
    if (_onboardingDone == null) return const _SplashScreen();
    if (_onboardingDone!) return const LoginPage();
    return const OnboardingPage();
  }
}
