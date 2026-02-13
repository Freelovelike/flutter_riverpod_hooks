import 'package:flutter/material.dart';
import 'package:flutter_riverpod_hooks/core/localization/locale_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBanner(),
              _buildAnnouncement(),
              _buildSectionTitle('contractAggregation'.tr()),
              _buildCard(
                tag: 'eventContract'.tr(),
                title: 'eventContractDesc'.tr(),
                subtitle: 'eventContractDetail'.tr(),
                stats: 'participants'.tr(args: ['1892']),
              ),
              _buildCard(
                tag: 'secondContract'.tr(),
                title: 'secondContractDesc'.tr(),
                subtitle: 'secondContractDetail'.tr(),
                stats: 'participants'.tr(args: ['2351']),
              ),
              _buildSectionTitle('gameAggregation'.tr()),
              _buildCard(
                tag: 'guess15s'.tr(),
                title: 'guess15sDesc'.tr(),
                subtitle: 'guess15sDetail'.tr(),
                stats: 'participants'.tr(args: ['3124']),
              ),
              _buildCard(
                tag: 'luckyDraw'.tr(),
                title: 'luckyDrawDesc'.tr(),
                subtitle: 'luckyDrawDetail'.tr(),
                stats: 'participants'.tr(args: ['3124']),
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
          ),
        ),
      ),
    );
  }

  Widget _buildAnnouncement() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.volume_up, size: 14, color: Color(0xFF969696)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              'systemUpgradeNotice'.tr(),
              style: const TextStyle(fontSize: 11, color: Color(0xFF969696)),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Icon(Icons.chevron_right, size: 14, color: Color(0xFF969696)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildCard({
    required String tag,
    required String title,
    required String subtitle,
    required String stats,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
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
                        color: const Color(0x1A226AD1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          color: Color(0xFF226AD1),
                          fontSize: 10,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF969696),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Image.network(
              //   iconPath,
              //   width: 64,
              //   height: 60,
              //   fit: BoxFit.contain,
              // ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: Color(0xFFEEEEEE)),
          ),
          Row(
            children: [
              const Icon(Icons.people_outline, size: 16, color: Colors.black54),
              const SizedBox(width: 8),
              Text(
                stats,
                style: const TextStyle(fontSize: 12, color: Colors.black),
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Color(0xFF226AD1),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
