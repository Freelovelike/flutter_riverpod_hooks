import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

class TransferPage extends HookConsumerWidget {
  const TransferPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'transferPageTitle'.tr(),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _buildAccountSelector(),
            const SizedBox(height: 24),
            Text(
              'currency'.tr(),
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF969696),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            _buildAssetSelector(),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'transferAmount'.tr(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF969696),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'available'.tr(args: ['1328USDT']),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF969696),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildAmountInput(),
            const SizedBox(height: 24),
            _buildSlider(),
            const Spacer(),
            _buildConfirmButton(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                _buildAccountRow('from'.tr(), 'contractAccount'.tr()),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(height: 1, color: Color(0xFFEAEAEA)),
                ),
                _buildAccountRow('to'.tr(), 'spotAccount'.tr()),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.swap_vert, color: Colors.black, size: 24),
        ],
      ),
    );
  }

  Widget _buildAccountRow(String label, String account) {
    return Row(
      children: [
        SizedBox(
          width: 24,
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF969696)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            account,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Icon(Icons.chevron_right, size: 16, color: Color(0xFF969696)),
      ],
    );
  }

  Widget _buildAssetSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 9,
            backgroundColor: Color(0xFF2EBD85),
            child: Text(
              'T',
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'USDT',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          const Icon(Icons.chevron_right, size: 16, color: Color(0xFF969696)),
        ],
      ),
    );
  }

  Widget _buildAmountInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'enterAmount'.tr(),
                hintStyle: const TextStyle(
                  color: Color(0xFF969696),
                  fontSize: 14,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'all'.tr(),
              style: const TextStyle(
                color: Color(0xFF226AD1),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (index) {
            return Container(
              width: index == 0 ? 8 : 4,
              height: index == 0 ? 8 : 4,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                border: Border.all(
                  color: index == 0
                      ? const Color(0xFF226AD1)
                      : const Color(0xFFEAEAEA),
                ),
                shape: BoxShape.rectangle,
              ),
              transform: Matrix4.rotationZ(0.785398), // 45 degrees
            );
          }),
        ),
        const SizedBox(height: 8),
        Container(
          height: 2,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF226AD1).withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          'confirmTransfer'.tr(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
