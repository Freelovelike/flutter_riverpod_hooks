import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_riverpod_hooks/features/wallet/providers/wallet_provider.dart';
import 'package:flutter_riverpod_hooks/core/theme/app_theme.dart';
import 'package:easy_localization/easy_localization.dart';

class MinePage extends ConsumerWidget {
  const MinePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColorsExtension.of(context);
    return Scaffold(
      backgroundColor: colors.backgroundBase,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInviteSection(colors),
              _buildCommissionCard(
                colors,
                title: 'totalCommission'.tr(),
                unit: 'USDT',
                total: '192834',
                claimed: '3000.00',
                pending: '123.01',
                pendingUnit: 'USDT',
              ),
              _buildCommissionCard(
                colors,
                title: 'totalCommission'.tr(),
                unit: 'MGO',
                total: '123.12',
                claimed: '1000.00',
                pending: '123.01',
                pendingUnit: 'MGO',
              ),
              _buildMenuItemView(
                colors,
                'tradingCompetitionAuth'.tr(),
                Icons.groups_outlined,
              ),
              _buildInvitedUsersSection(colors),
              const SizedBox(height: 20),
              _buildLogoutButton(ref),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInviteSection(AppColorsExtension colors) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.backgroundSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.backgroundBase, width: 2),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: colors.themePrimary,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Center(
              child: Text(
                'inviteFriends'.tr(),
                style: TextStyle(
                  color: colors.foregroundCtaText,
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'invitedCount'.tr(),
            style: TextStyle(color: colors.foregroundSecondary, fontSize: 14),
          ),
          const SizedBox(height: 10),
          Text(
            '1212',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: colors.foregroundPrimary,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.symmetric(vertical: 16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: colors.themePrimary,
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                  color: colors.themePrimary.withOpacity(0.25),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'inviteNow'.tr(),
                style: TextStyle(
                  color: colors.foregroundCtaText,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'CPA_00QWMF0TAT',
                style:
                    TextStyle(color: colors.foregroundSecondary, fontSize: 12),
              ),
              const SizedBox(width: 4),
              Image.asset(
                'assets/image/copy.png',
                width: 12,
                height: 12,
                color: colors.foregroundSecondary,
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildCommissionCard(
    AppColorsExtension colors, {
    required String title,
    required String unit,
    required String total,
    required String claimed,
    required String pending,
    required String pendingUnit,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.backgroundCard,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '$title ',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: colors.foregroundPrimary,
                            ),
                          ),
                          TextSpan(
                            text: '($unit)',
                            style: TextStyle(
                              fontSize: 12,
                              color: colors.foregroundSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      total,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: colors.foregroundPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${'claimed'.tr()} ',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: colors.foregroundPrimary,
                            ),
                          ),
                          TextSpan(
                            text: '($unit)',
                            style: TextStyle(
                              fontSize: 12,
                              color: colors.foregroundSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      claimed,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: colors.foregroundPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Image.asset(
                'assets/image/history.png',
                width: 18,
                height: 18,
                color: colors.foregroundPrimary,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: colors.borderDivider),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colors.backgroundSecondary.withOpacity(0.5),
                  colors.backgroundBase
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: colors.themePrimary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 16,
                    color: colors.foregroundCtaText,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'pendingCommission'.tr(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: colors.foregroundPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '+$pending$pendingUnit',
                  style: TextStyle(
                    fontSize: 14,
                    color: colors.foregroundError,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: colors.themePrimary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'claim'.tr(),
                    style: TextStyle(
                      color: colors.foregroundCtaText,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItemView(AppColorsExtension colors, String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.backgroundCollection,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: colors.foregroundPrimary),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: colors.foregroundPrimary,
            ),
          ),
          const Spacer(),
          Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: colors.themePrimary,
          ),
        ],
      ),
    );
  }

  Widget _buildInvitedUsersSection(AppColorsExtension colors) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'invitedUsers'.tr(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: colors.foregroundPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildUserListItem(
            colors,
            '0x03e2...39b1',
            '9.00 USDT',
            '0x...a2fb',
            '0 USDT',
            isAgent: true,
          ),
          const SizedBox(height: 12),
          _buildUserListItem(
            colors,
            '0x03e2...39b1',
            '9.00 USDT',
            '0x...a2fb',
            '0 USDT',
            isAgent: false,
          ),
        ],
      ),
    );
  }

  Widget _buildUserListItem(
    AppColorsExtension colors,
    String address,
    String volume,
    String upline,
    String commission, {
    bool isAgent = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.backgroundCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.borderDivider),
      ),
      child: Column(
        children: [
          _buildUserRow(colors, 'invitedUsers'.tr(), address, isAgent: isAgent),
          const SizedBox(height: 10),
          _buildUserRow(colors, 'tradingVolume'.tr(), volume),
          const SizedBox(height: 10),
          _buildUserRow(colors, 'uplineUser'.tr(), upline),
          const SizedBox(height: 10),
          _buildUserRow(colors, 'commissionAmount'.tr(), commission),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'operation'.tr(),
                style:
                    TextStyle(color: colors.foregroundSecondary, fontSize: 12),
              ),
              Icon(
                Icons.more_horiz,
                size: 16,
                color: colors.foregroundSecondary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserRow(AppColorsExtension colors, String label, String value,
      {bool isAgent = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: colors.foregroundSecondary, fontSize: 12),
        ),
        Row(
          children: [
            Text(
              value,
              style: TextStyle(fontSize: 12, color: colors.foregroundPrimary),
            ),
            if (isAgent) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.themePrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'agent'.tr(),
                  style: TextStyle(
                    color: colors.themePrimary,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildLogoutButton(WidgetRef ref) {
    return Center(
      child: TextButton(
        onPressed: () => ref.read(walletProvider.notifier).deleteWallet(),
        child: Text(
          'removeWallet'.tr(),
          style: const TextStyle(color: Colors.red, fontSize: 14),
        ),
      ),
    );
  }
}

