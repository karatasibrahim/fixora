import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/locale/locale_notifier.dart';
import 'core/theme/theme.dart';
import 'l10n/app_localizations.dart';
import 'shared/presentation/main_shell.dart';

class FixoraApp extends StatelessWidget {
  const FixoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = AppTheme.light;

    return ListenableBuilder(
      listenable: localeNotifier,
      builder: (context, child) => MaterialApp(
        title: 'Fixora',
        debugShowCheckedModeBanner: false,
        locale: localeNotifier.locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        theme: base.copyWith(
          textTheme: GoogleFonts.interTextTheme(base.textTheme),
        ),
        home: const MainShell(),
      ),
    );
  }
}
