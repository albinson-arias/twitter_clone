import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/src/l10n/app_locales.dart';
import 'package:twitter_clone/src/l10n/app_localizations_context.dart';
import 'package:twitter_clone/src/repositories/repositories.dart';
import 'package:twitter_clone/src/routing/app_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:twitter_clone/src/theme/app_theme.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    return MaterialApp.router(
      title: 'Twitter Clone',
      debugShowCheckedModeBanner: false,
      routeInformationParser: goRouter.routeInformationParser,
      routeInformationProvider: goRouter.routeInformationProvider,
      routerDelegate: goRouter.routerDelegate,
      onGenerateTitle: (context) => context.loc.appName,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: AppLocales.supportedLocales,
      locale: ref.watch(localeStreamProvider).value,
      theme: AppTheme.theme,
    );
  }
}
