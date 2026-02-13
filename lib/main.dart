import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter_riverpod_hooks/core/router/router.dart';

import 'package:flutter_riverpod_hooks/core/theme/theme_provider.dart';
import 'package:flutter_riverpod_hooks/core/localization/locale_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('zh')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: ProviderScope(child: MyApp()),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return OKToast(
      child: MaterialApp.router(
        title: 'BeingDex',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF226AD1)),
          useMaterial3: true,
          fontFamily: 'Montserrat',
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF226AD1),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
          fontFamily: 'Montserrat',
        ),
        themeMode: themeMode,
        routerConfig: router,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: locale ?? context.locale,
      ),
    );
  }
}
