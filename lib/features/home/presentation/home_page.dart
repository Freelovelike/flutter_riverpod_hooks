import 'package:flutter/material.dart';
import 'package:flutter_riverpod_hooks/core/theme/app_theme.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  // 平台 URL 映射
  static const _platformUrls = {
    'eventContract': 'https://dev-dapp-futures.mangochain.top',
    'secondContract': 'https://dev-dapp-scontract.mangochain.top',
    'guess15s': 'https://dev-dapp-guesses.mangochain.top',
    'luckyDraw': 'https://dev-dapp-draw.mangochain.top',
    'redPacket': 'https://being-redpacket-api.demoshow.diy',
  };

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
              _buildBanner(),
              _buildAnnouncement(colors),
              _buildSectionTitle(context, 'contractAggregation'.tr(), colors),
              _buildCard(
                context,
                colors: colors,
                tag: 'eventContract'.tr(),
                title: 'eventContractDesc'.tr(),
                subtitle: 'eventContractDetail'.tr(),
                stats: 'participants'.tr(args: ['1892']),
                url: _platformUrls['eventContract']!,
              ),
              _buildCard(
                context,
                colors: colors,
                tag: 'secondContract'.tr(),
                title: 'secondContractDesc'.tr(),
                subtitle: 'secondContractDetail'.tr(),
                stats: 'participants'.tr(args: ['2351']),
                url: _platformUrls['secondContract']!,
              ),
              _buildSectionTitle(context, 'gameAggregation'.tr(), colors),
              _buildCard(
                context,
                colors: colors,
                tag: 'guess15s'.tr(),
                title: 'guess15sDesc'.tr(),
                subtitle: 'guess15sDetail'.tr(),
                stats: 'participants'.tr(args: ['3124']),
                url: _platformUrls['guess15s']!,
              ),
              _buildCard(
                context,
                colors: colors,
                tag: 'luckyDraw'.tr(),
                title: 'luckyDrawDesc'.tr(),
                subtitle: 'luckyDrawDetail'.tr(),
                stats: 'participants'.tr(args: ['3124']),
                url: _platformUrls['luckyDraw']!,
              ),
              _buildCard(
                context,
                colors: colors,
                tag: 'redPacket'.tr(),
                title: 'redPacketDesc'.tr(),
                subtitle: 'redPacketDetail'.tr(),
                stats: 'participants'.tr(args: ['5678']),
                url: _platformUrls['redPacket']!,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AspectRatio(
          aspectRatio: 343 / 188,
          child: Image.network(
            'http://localhost:3845/assets/5249f7543f8e457dcff666c1567fc3ed741df327.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.grey.withOpacity(0.1),
              child: const Icon(Icons.image_not_supported),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnnouncement(AppColorsExtension colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(Icons.volume_up, size: 14, color: colors.foregroundSecondary),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              'systemUpgradeNotice'.tr(),
              style: TextStyle(fontSize: 11, color: colors.foregroundSecondary),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(Icons.chevron_right, size: 14, color: colors.foregroundSecondary),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(
    BuildContext context,
    String title,
    AppColorsExtension colors,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: colors.foregroundPrimary,
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required AppColorsExtension colors,
    required String tag,
    required String title,
    required String subtitle,
    required String stats,
    required String url,
  }) {
    return GestureDetector(
      onTap: () {
        context.push('/webview', extra: {
          'url': url,
          'title': tag,
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.backgroundCard,
          borderRadius: BorderRadius.circular(10),
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
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colors.themePrimary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            color: colors.themePrimary,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: colors.foregroundPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.foregroundSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1, color: colors.borderDivider),
            ),
            Row(
              children: [
                Icon(
                  Icons.people_outline,
                  size: 16,
                  color: colors.foregroundSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  stats,
                  style: TextStyle(fontSize: 12, color: colors.foregroundPrimary),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: colors.themePrimary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
