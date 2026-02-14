import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_riverpod_hooks/features/wallet/providers/wallet_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod_hooks/core/theme/app_theme.dart';

class WalletManagementPage extends ConsumerWidget {
  const WalletManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletState = ref.watch(walletProvider);
    final colors = AppColorsExtension.of(context);

    return Scaffold(
      backgroundColor: colors.backgroundBase,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'walletManagementTitle'.tr(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colors.foregroundPrimary,
                ),
              ),
            ),
            walletState.when(
              data: (address) => Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colors.backgroundCard,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'currentWallet'.tr(),
                        style: TextStyle(
                          fontSize: 14,
                          color: colors.foregroundSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: colors.themePrimary,
                            child: Icon(
                              Icons.account_balance_wallet,
                              size: 14,
                              color: colors.foregroundCtaText,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              address ?? 'notConnected'.tr(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: colors.foregroundPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(height: 40, color: colors.borderDivider),
                      Center(
                        child: TextButton(
                          onPressed: () =>
                              ref.read(walletProvider.notifier).deleteWallet(),
                          child: Text(
                            'removeWallet'.tr(),
                            style: TextStyle(color: colors.foregroundError),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('Error: $e')),
            ),
          ],
        ),
      ),
    );
  }
}

