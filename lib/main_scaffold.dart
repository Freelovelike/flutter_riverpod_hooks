import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_riverpod_hooks/shared/widgets/common_header.dart';
import 'package:flutter_riverpod_hooks/features/home/presentation/home_page.dart';
import 'package:flutter_riverpod_hooks/features/assets/presentation/assets_page.dart';
import 'package:flutter_riverpod_hooks/features/mine/presentation/mine_page.dart';
import 'package:flutter_riverpod_hooks/features/wallet/presentation/wallet_management_page.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter_riverpod_hooks/core/navigation/navigation_provider.dart';

class MainScaffold extends HookConsumerWidget {
  const MainScaffold({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navigationControllerProvider);
    final pages = [
      const HomePage(),
      const AssetsPage(),
      const WalletManagementPage(),
      const MinePage(),
    ];

    return Scaffold(
      appBar: const CommonHeader(),
      body: IndexedStack(index: selectedIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) =>
            ref.read(navigationControllerProvider.notifier).setIndex(index),
        selectedItemColor: const Color(0xFF226AD1),
        unselectedItemColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFFB0B0B0)
            : const Color(0xFF969696),
        selectedFontSize: 12,
        unselectedFontSize: 12,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: 'home'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.account_balance_wallet_outlined),
            activeIcon: const Icon(Icons.account_balance_wallet),
            label: 'assets'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings_outlined),
            activeIcon: const Icon(Icons.settings),
            label: 'walletManagement'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: 'mine'.tr(),
          ),
        ],
      ),
    );
  }
}
