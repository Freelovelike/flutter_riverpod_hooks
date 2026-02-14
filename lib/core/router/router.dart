import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_riverpod_hooks/main_scaffold.dart';
import 'package:flutter_riverpod_hooks/features/assets/presentation/transfer_page.dart';
import 'package:flutter_riverpod_hooks/features/wallet/providers/wallet_provider.dart';
import 'package:flutter_riverpod_hooks/features/wallet/presentation/wallet_setup_page.dart';
import 'package:flutter_riverpod_hooks/features/splash/presentation/splash_page.dart';
import 'package:flutter_riverpod_hooks/features/splash/presentation/unlock_page.dart';
import 'package:flutter_riverpod_hooks/features/splash/providers/app_lock_provider.dart';
import 'package:flutter_riverpod_hooks/core/localization/locale_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // Watch locale to force router recreation on language change
  ref.watch(localeProvider);

  final walletState = ref.watch(walletProvider);
  final appLockState = ref.watch(appLockProvider);
  final listenable = ChangeNotifierProxy();

  ref.listen(walletProvider, (previous, next) {
    if (previous?.value != next.value) {
      listenable.notify();
    }
  });

  ref.listen(appLockProvider, (previous, next) {
    if (previous?.value != next.value) {
      listenable.notify();
    }
  });

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: listenable,
    redirect: (context, state) {
      final lockState = appLockState.value;
      final walletAddress = walletState.value;
      final currentLocation = state.matchedLocation;

      // 1. 还在加载中 → 保持在 splash
      if (lockState == null || lockState == AppLockState.loading) {
        return currentLocation == '/splash' ? null : '/splash';
      }

      // 2. 已锁定且有钱包 → 去解锁页
      if (lockState == AppLockState.locked && walletAddress != null) {
        return currentLocation == '/unlock' ? null : '/unlock';
      }

      // 3. 已解锁但无钱包 → 去钱包设置
      if (walletAddress == null) {
        return currentLocation == '/setup-wallet' ? null : '/setup-wallet';
      }

      // 4. 已解锁且有钱包，如果还在 splash/unlock/setup-wallet → 跳转主页
      if (currentLocation == '/splash' ||
          currentLocation == '/unlock' ||
          currentLocation == '/setup-wallet') {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/unlock',
        builder: (context, state) => const UnlockPage(),
      ),
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
