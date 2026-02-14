import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter_riverpod_hooks/core/router/router.dart';
import 'package:flutter_riverpod_hooks/core/localization/locale_provider.dart';
import 'package:flutter_riverpod_hooks/features/splash/providers/app_lock_provider.dart';
import 'package:flutter_riverpod_hooks/core/theme/app_theme.dart';
import 'package:flutter_riverpod_hooks/core/theme/theme_provider.dart';

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

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  DateTime? _lastPausedTime;
  static const _backgroundLockThreshold = Duration(minutes: 5);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _lastPausedTime = DateTime.now();
    } else if (state == AppLifecycleState.resumed) {
      if (_lastPausedTime != null) {
        final durationInBackground = DateTime.now().difference(_lastPausedTime!);
        if (durationInBackground >= _backgroundLockThreshold) {
          // 只有后台停留超过阈值时才锁定应用
          ref.read(appLockProvider.notifier).lock();
        }
      }
      _lastPausedTime = null;
    }
  }

  @override
  Widget build(BuildContext context) {
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
          extensions: [lightAppColors],
          scaffoldBackgroundColor: lightAppColors.background,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF226AD1),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
          fontFamily: 'Montserrat',
          extensions: [darkAppColors],
          scaffoldBackgroundColor: darkAppColors.background,
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
