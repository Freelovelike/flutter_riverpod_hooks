import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_riverpod_hooks/features/auth/providers/auth_provider.dart';
import 'package:easy_localization/easy_localization.dart';

class MinePage extends ConsumerWidget {
  const MinePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInviteSection(),
              _buildCommissionCard(
                title: 'totalCommission'.tr(),
                unit: 'USDT',
                total: '192834',
                claimed: '3000.00',
                pending: '123.01',
                pendingUnit: 'USDT',
              ),
              _buildCommissionCard(
                title: 'totalCommission'.tr(),
                unit: 'MGO',
                total: '123.12',
                claimed: '1000.00',
                pending: '123.01',
                pendingUnit: 'MGO',
              ),
              _buildMenuItemView(
                'tradingCompetitionAuth'.tr(),
                Icons.groups_outlined,
              ),
              _buildInvitedUsersSection(),
              const SizedBox(height: 20),
              _buildLogoutButton(ref),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInviteSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4FE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF226AD1),
              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Center(
              child: Text(
                'inviteFriends'.tr(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'invitedCount'.tr(),
            style: const TextStyle(color: Color(0xFF5D5F68), fontSize: 14),
          ),
          const SizedBox(height: 10),
          const Text(
            '1212',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.symmetric(vertical: 16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF226AD1),
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0449E4).withValues(alpha: 0.25),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'inviteNow'.tr(),
                style: const TextStyle(
                  color: Colors.white,
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
              const Text(
                'CPA_00QWMF0TAT',
                style: TextStyle(color: Color(0xFFB5B5B5), fontSize: 12),
              ),
              const SizedBox(width: 4),
              Image.asset('assets/image/copy.png', width: 12, height: 12),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildCommissionCard({
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
        color: Colors.white,
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
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          TextSpan(
                            text: '($unit)',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      total,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
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
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          TextSpan(
                            text: '($unit)',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      claimed,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Image.asset('assets/image/history.png', width: 18, height: 18),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFEDF4FC), Color(0xFFFEFFFF)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Color(0xFF226AD1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'pendingCommission'.tr(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '+$pending$pendingUnit',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFFE53A36),
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
                    color: const Color(0xFF226AD1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'claim'.tr(),
                    style: const TextStyle(
                      color: Colors.white,
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

  Widget _buildMenuItemView(String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.black87),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          const Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: Color(0xFF226AD1),
          ),
        ],
      ),
    );
  }

  Widget _buildInvitedUsersSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'invitedUsers'.tr(),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          _buildUserListItem(
            '0x03e2...39b1',
            '9.00 USDT',
            '0x...a2fb',
            '0 USDT',
            isAgent: true,
          ),
          const SizedBox(height: 12),
          _buildUserListItem(
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
    String address,
    String volume,
    String upline,
    String commission, {
    bool isAgent = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE9EAEB)),
      ),
      child: Column(
        children: [
          _buildUserRow('invitedUsers'.tr(), address, isAgent: isAgent),
          const SizedBox(height: 10),
          _buildUserRow('tradingVolume'.tr(), volume),
          const SizedBox(height: 10),
          _buildUserRow('uplineUser'.tr(), upline),
          const SizedBox(height: 10),
          _buildUserRow('commissionAmount'.tr(), commission),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'operation'.tr(),
                style: const TextStyle(color: Color(0xFFB9B9B9), fontSize: 12),
              ),
              const Icon(Icons.more_horiz, size: 16, color: Colors.black54),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserRow(String label, String value, {bool isAgent = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: const Color(0xFFB9B9B9), fontSize: 12),
        ),
        Row(
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 12, color: Colors.black),
            ),
            if (isAgent) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0x1A226AD1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'agent'.tr(),
                  style: const TextStyle(
                    color: Color(0xFF226AD1),
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
        onPressed: () => ref.read(authProvider.notifier).logout(),
        child: Text(
          'logout'.tr(),
          style: const TextStyle(color: Colors.red, fontSize: 14),
        ),
      ),
    );
  }
}
