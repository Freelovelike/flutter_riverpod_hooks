import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod_hooks/core/theme/app_theme.dart';

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

    final colors = AppColorsExtension.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            AssetTabSelector(selectedTab: selectedTab, tabs: tabs),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const AssetBalanceCard(),
                    AssetActionButtons(tabIndex: selectedTab.value),
                    const AssetListSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AssetTabSelector extends StatelessWidget {
  final ValueNotifier<int> selectedTab;
  final List<String> tabs;

  const AssetTabSelector({
    super.key,
    required this.selectedTab,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
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
                  color: isSelected
                      ? colors.foregroundPrimary
                      : colors.foregroundSecondary,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class AssetBalanceCard extends StatelessWidget {
  const AssetBalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('AssetBalanceCard Rebuilding');
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      height: 165,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF226AD1), const Color(0xFF1A4A8F)]
              : [const Color(0xFFF4F8FF), const Color(0xFFDAE9FF)],
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
                placeholderBuilder: (context) => const SizedBox.shrink(),
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
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.visibility,
                    size: 14,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '\$78.69',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '+\$8.02 ',
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                    const TextSpan(
                      text: '(+0.23%)',
                      style: TextStyle(color: Color(0xFF2EBD85)),
                    ),
                  ],
                ),
                style: const TextStyle(fontSize: 14),
              ),
              const Spacer(),
              Row(
                children: [
                  BalanceInfoItem(
                    label: 'availableBalance'.tr(),
                    value: '\$14.38',
                    isDark: isDark,
                  ),
                  const SizedBox(width: 40),
                  BalanceInfoItem(
                    label: 'lockedBalance'.tr(),
                    value: '\$1.00',
                    isDark: isDark,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BalanceInfoItem extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;

  const BalanceInfoItem({
    super.key,
    required this.label,
    required this.value,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white70 : const Color(0xFF969696),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class AssetActionButtons extends StatelessWidget {
  final int tabIndex;

  const AssetActionButtons({super.key, required this.tabIndex});

  @override
  Widget build(BuildContext context) {
    final isSpot = tabIndex == 0;

    final colors = AppColorsExtension.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          AssetActionButton(
            label: 'transfer'.tr(),
            bgColor: const Color(0xFF226AD1),
            textColor: Colors.white,
            onTap: () => context.push('/transfer'),
          ),
          const SizedBox(width: 8),
          if (isSpot) ...[
            AssetActionButton(
              label: 'deposit'.tr(),
              bgColor: colors.inputFill,
              textColor: Theme.of(context).colorScheme.onSurface,
              onTap: () {},
            ),
            const SizedBox(width: 8),
            AssetActionButton(
              label: 'withdraw'.tr(),
              bgColor: colors.inputFill,
              textColor: Theme.of(context).colorScheme.onSurface,
              onTap: () {},
            ),
          ] else ...[
            AssetActionButton(
              label: 'transactionHistory'.tr(),
              bgColor: colors.inputFill,
              textColor: Theme.of(context).colorScheme.onSurface,
              onTap: () {},
            ),
          ],
        ],
      ),
    );
  }
}

class AssetActionButton extends StatelessWidget {
  final String label;
  final Color bgColor;
  final Color textColor;
  final VoidCallback onTap;

  const AssetActionButton({
    super.key,
    required this.label,
    required this.bgColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
}

class AssetListSection extends StatelessWidget {
  const AssetListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Text(
            'assetsListTitle'.tr(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColorsExtension.of(context).foregroundPrimary,
            ),
          ),
        ),
        const AssetItem(
          name: 'BNB',
          balance: '0.00231BNB',
          value: '\$4.95',
          change: '+\$0.02',
          isPositive: true,
          iconUrl:
              'http://localhost:3845/assets/9710f642c30bfabd63227c5bf22b47eb3cfdbb31.svg',
        ),
        const AssetItem(
          name: 'Sui',
          balance: '0.00231SUI',
          value: '\$4.95',
          change: '+\$0.02',
          isPositive: false,
          iconUrl:
              'http://localhost:3845/assets/68fda1b6e1085bbd4f82cdf1e95e4891e31792ec.svg',
        ),
        const AssetItem(
          name: 'Solana',
          balance: '0.00231SOL',
          value: '\$4.95',
          change: '+\$0.02',
          isPositive: false,
          iconUrl:
              'http://localhost:3845/assets/e6b7c771b0e35c140c7e31550affbf97db0ad1c3.svg',
        ),
        const AssetItem(
          name: 'BNB',
          balance: '0.00231BNB',
          value: '\$4.95',
          change: '+\$0.02',
          isPositive: true,
          iconUrl:
              'http://localhost:3845/assets/9710f642c30bfabd63227c5bf22b47eb3cfdbb31.svg',
        ),
        const AssetItem(
          name: 'Sui',
          balance: '0.00231SUI',
          value: '\$4.95',
          change: '+\$0.02',
          isPositive: false,
          iconUrl:
              'http://localhost:3845/assets/68fda1b6e1085bbd4f82cdf1e95e4891e31792ec.svg',
        ),
        const AssetItem(
          name: 'Solana',
          balance: '0.00231SOL',
          value: '\$4.95',
          change: '+\$0.02',
          isPositive: false,
          iconUrl:
              'http://localhost:3845/assets/e6b7c771b0e35c140c7e31550affbf97db0ad1c3.svg',
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class AssetItem extends StatelessWidget {
  final String name;
  final String balance;
  final String value;
  final String change;
  final bool isPositive;
  final String iconUrl;

  const AssetItem({
    super.key,
    required this.name,
    required this.balance,
    required this.value,
    required this.change,
    required this.isPositive,
    required this.iconUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: SvgPicture.network(
              iconUrl,
              placeholderBuilder: (context) => Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.toll, size: 16, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColorsExtension.of(context).foregroundPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                balance,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColorsExtension.of(context).foregroundSecondary,
                ),
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColorsExtension.of(context).foregroundPrimary,
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
