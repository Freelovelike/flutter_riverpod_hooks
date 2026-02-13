import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oktoast/oktoast.dart';
import 'auth_provider.dart';
import 'auth_page.dart';
import 'router.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return OKToast(
      child: MaterialApp.router(
        title: 'BeingDex',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF226AD1)),
          useMaterial3: true,
          fontFamily: 'Montserrat', // Using common font for DEX apps
        ),
        routerConfig: router,
      ),
    );
  }
}
