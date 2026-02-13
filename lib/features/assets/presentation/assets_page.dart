import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod_hooks/core/localization/locale_provider.dart';

class AssetsPage extends HookConsumerWidget {
  const AssetsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = useState(0);

    final tabs = [
      'spotAccount'.tr(),
      'contractAccount'.tr(),
      'gameAccount'.tr(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildTabSelector(selectedTab, tabs),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildBalanceCard(),
                    _buildActionButtons(context, selectedTab.value),
                    _buildAssetListSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabSelector(ValueNotifier<int> selectedTab, List<String> tabs) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final label = entry.value;
          final isSelected = selectedTab.value == index;
          return GestureDetector(
            onTap: () => selectedTab.value = index,
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.black : const Color(0xFF969696),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      height: 165,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF4F8FF), Color(0xFFDAE9FF)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            bottom: 0,
            child: Opacity(
              opacity: 0.1,
              child: SvgPicture.network(
                'http://localhost:3845/assets/9770158f34b9c1d4504d3ba37795721cc2366e63.svg',
                width: 100,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'totalAssets'.tr(),
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.visibility, size: 14, color: Colors.black),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                '\$78.69',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '+\$8.02 ',
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: '(+0.23%)',
                      style: TextStyle(color: Color(0xFF2EBD85)),
                    ),
                  ],
                ),
                style: TextStyle(fontSize: 14),
              ),
              const Spacer(),
              Row(
                children: [
                  _buildBalanceInfo('availableBalance'.tr(), '\$14.38'),
                  const SizedBox(width: 40),
                  _buildBalanceInfo('lockedBalance'.tr(), '\$1.00'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF969696)),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, int tabIndex) {
    final isSpot = tabIndex == 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildActionButton(
            'transfer'.tr(),
            const Color(0xFF226AD1),
            Colors.white,
            () => context.push('/transfer'),
          ),
          const SizedBox(width: 8),
          if (isSpot) ...[
            _buildActionButton(
              'deposit'.tr(),
              const Color(0xFFF5F5F5),
              Colors.black,
              () {},
            ),
            const SizedBox(width: 8),
            _buildActionButton(
              'withdraw'.tr(),
              const Color(0xFFF5F5F5),
              Colors.black,
              () {},
            ),
          ] else ...[
            _buildActionButton(
              'transactionHistory'.tr(),
              const Color(0xFFF5F5F5),
              Colors.black,
              () {},
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    Color bgColor,
    Color textColor,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 41,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAssetListSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Text(
            'assetsListTitle'.tr(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        _buildAssetItem(
          'BNB',
          '0.00231BNB',
          '\$4.95',
          '+\$0.02',
          true,
          'http://localhost:3845/assets/9710f642c30bfabd63227c5bf22b47eb3cfdbb31.svg',
        ),
        _buildAssetItem(
          'Sui',
          '0.00231SUI',
          '\$4.95',
          '+\$0.02',
          false,
          'http://localhost:3845/assets/68fda1b6e1085bbd4f82cdf1e95e4891e31792ec.svg',
        ),
        _buildAssetItem(
          'Solana',
          '0.00231SOL',
          '\$4.95',
          '+\$0.02',
          false,
          'http://localhost:3845/assets/e6b7c771b0e35c140c7e31550affbf97db0ad1c3.svg',
        ),
        _buildAssetItem(
          'BNB',
          '0.00231BNB',
          '\$4.95',
          '+\$0.02',
          true,
          'http://localhost:3845/assets/9710f642c30bfabd63227c5bf22b47eb3cfdbb31.svg',
        ),
        _buildAssetItem(
          'Sui',
          '0.00231SUI',
          '\$4.95',
          '+\$0.02',
          false,
          'http://localhost:3845/assets/68fda1b6e1085bbd4f82cdf1e95e4891e31792ec.svg',
        ),
        _buildAssetItem(
          'Solana',
          '0.00231SOL',
          '\$4.95',
          '+\$0.02',
          false,
          'http://localhost:3845/assets/e6b7c771b0e35c140c7e31550affbf97db0ad1c3.svg',
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildAssetItem(
    String name,
    String balance,
    String value,
    String change,
    bool isPositive,
    String iconUrl,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: SvgPicture.network(iconUrl),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                balance,
                style: const TextStyle(fontSize: 12, color: Color(0xFF969696)),
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                change,
                style: TextStyle(
                  fontSize: 12,
                  color: isPositive
                      ? const Color(0xFF2EBD85)
                      : const Color(0xFFF6465D),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
