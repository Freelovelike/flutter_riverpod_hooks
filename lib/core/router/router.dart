import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_riverpod_hooks/main_scaffold.dart';
import 'package:flutter_riverpod_hooks/features/assets/presentation/transfer_page.dart';
import 'package:flutter_riverpod_hooks/features/wallet/providers/wallet_provider.dart';
import 'package:flutter_riverpod_hooks/features/wallet/presentation/wallet_setup_page.dart';
import 'package:flutter_riverpod_hooks/core/localization/locale_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // Watch locale to force router recreation on language change
  ref.watch(localeProvider);

  final walletState = ref.watch(walletProvider);
  final listenable = ChangeNotifierProxy();

  // authState is no longer used for routing logic

  ref.listen(walletProvider, (previous, next) {
    if (previous?.value != next.value) {
      listenable.notify();
    }
  });

  return GoRouter(
    initialLocation: '/',
    refreshListenable: listenable,
    redirect: (context, state) {
      final walletAddress = walletState.value;
      final isSettingUpWallet = state.matchedLocation == '/setup-wallet';

      if (walletAddress == null) {
        return isSettingUpWallet ? null : '/setup-wallet';
      }

      if (isSettingUpWallet) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const MainScaffold()),
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
