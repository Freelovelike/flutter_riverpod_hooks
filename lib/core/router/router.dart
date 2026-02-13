import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_riverpod_hooks/main_scaffold.dart';
import 'package:flutter_riverpod_hooks/features/auth/presentation/auth_page.dart';
import 'package:flutter_riverpod_hooks/features/assets/presentation/transfer_page.dart';
import 'package:flutter_riverpod_hooks/features/auth/providers/auth_provider.dart';
import 'package:flutter_riverpod_hooks/features/wallet/providers/wallet_provider.dart';
import 'package:flutter_riverpod_hooks/features/wallet/presentation/wallet_setup_page.dart';
import 'package:flutter_riverpod_hooks/core/localization/locale_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);
  final walletState = ref.watch(walletProvider);
  final listenable = ChangeNotifierProxy();

  ref.listen(authProvider, (previous, next) {
    if (previous?.value != next.value) {
      listenable.notify();
    }
  });

  ref.listen(walletProvider, (previous, next) {
    if (previous?.value != next.value) {
      listenable.notify();
    }
  });

  ref.listen(localeProvider, (previous, next) {
    listenable.notify();
  });

  return GoRouter(
    initialLocation: '/',
    refreshListenable: listenable,
    redirect: (context, state) {
      final isAuth = authState.value ?? false;
      final walletAddress = walletState.value;
      final isLoggingIn = state.matchedLocation == '/auth';
      final isSettingUpWallet = state.matchedLocation == '/setup-wallet';

      if (!isAuth) {
        return isLoggingIn ? null : '/auth';
      }

      if (walletAddress == null) {
        return isSettingUpWallet ? null : '/setup-wallet';
      }

      if (isLoggingIn || isSettingUpWallet) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const MainScaffold()),
      GoRoute(path: '/auth', builder: (context, state) => const AuthPage()),
      GoRoute(
        path: '/setup-wallet',
        builder: (context, state) => const WalletSetupPage(),
      ),
      GoRoute(
        path: '/transfer',
        builder: (context, state) => const TransferPage(),
      ),
    ],
  );
});

class ChangeNotifierProxy extends ChangeNotifier {
  void notify() => notifyListeners();
}
