import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBanner(),
              _buildAnnouncement(),
              _buildSectionTitle('合约聚合场'),
              _buildCard(
                tag: '事件合约',
                title: '赛事/政策结果预测',
                subtitle: '基于链上预言机结算，实现去中心化事件判断',
                stats: '参与人数1892人',
                iconPath:
                    'http://localhost:3845/assets/aae9f3937faa3eb9edd4958acb96cf2754f1559d.png',
              ),
              _buildCard(
                tag: '秒合约',
                title: '1m / 3m / 5m 短时交易',
                subtitle: '秒级合约，灵活周期，快速捕捉市场波动',
                stats: '参与人数2351人',
                iconPath:
                    'http://localhost:3845/assets/010aa74e3bf102e746dd9bdd7423d099430bf2e0.png',
              ),
              _buildSectionTitle('游戏聚合场'),
              _buildCard(
                tag: '15秒竞猜',
                title: '加密货币趋势竞猜',
                subtitle: '15 秒涨跌竞猜，轻松体验即时行情挑战',
                stats: '参与人数3124人',
                iconPath:
                    'http://localhost:3845/assets/61eed7fee9c3e612a3107e3a3e7583e7d383994f.png',
              ),
              _buildCard(
                tag: '一元夺宝',
                title: '夺宝赢1 BNB',
                subtitle: '小投入·大惊喜，幸运即刻启程！',
                stats: '参与人数3124人',
                iconPath:
                    'http://localhost:3845/assets/3d426ac1be4ad22adf99263290e46622337c4c7b.png',
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
          const Expanded(
            child: Text(
              '【系统升级提示】本平台将于今晚 22:00 进行例行维护...',
              style: TextStyle(fontSize: 11, color: Color(0xFF969696)),
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
    required String iconPath,
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
              Image.network(
                iconPath,
                width: 64,
                height: 60,
                fit: BoxFit.contain,
              ),
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
