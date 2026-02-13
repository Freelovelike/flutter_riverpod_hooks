import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod_hooks/features/wallet/providers/wallet_provider.dart';
import 'package:flutter_riverpod_hooks/features/wallet/services/wallet_service.dart';

enum SetupStep { home, setPassword, backupMnemonic, importMnemonic }

class WalletSetupPage extends HookConsumerWidget {
  const WalletSetupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final step = useState(SetupStep.home);
    final passwordController = useTextEditingController();
    final mnemonicController = useTextEditingController();
    final generatedMnemonic = useState<String?>(null);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: step.value != SetupStep.home
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  if (step.value == SetupStep.setPassword) {
                    step.value = SetupStep.home;
                  } else if (step.value == SetupStep.backupMnemonic ||
                      step.value == SetupStep.importMnemonic) {
                    step.value = SetupStep.setPassword;
                  }
                },
              ),
            )
          : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _buildStepContent(
            context,
            ref,
            step,
            passwordController,
            mnemonicController,
            generatedMnemonic,
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<SetupStep> step,
    TextEditingController passwordController,
    TextEditingController mnemonicController,
    ValueNotifier<String?> generatedMnemonic,
  ) {
    switch (step.value) {
      case SetupStep.home:
        return _buildHome(step, generatedMnemonic);
      case SetupStep.setPassword:
        return _buildSetPassword(step, passwordController, generatedMnemonic);
      case SetupStep.backupMnemonic:
        return _buildBackupMnemonic(
          ref,
          step,
          passwordController,
          generatedMnemonic,
        );
      case SetupStep.importMnemonic:
        return _buildImportMnemonic(
          ref,
          step,
          passwordController,
          mnemonicController,
        );
    }
  }

  Widget _buildHome(
    ValueNotifier<SetupStep> step,
    ValueNotifier<String?> generatedMnemonic,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Image.asset('assets/image/logo.png', height: 40),
        const SizedBox(height: 24),
        const Text(
          '欢迎使用 BeingDex',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        const Text(
          '创建或导入您的钱包以开始交易',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Color(0xFF969696)),
        ),
        const Spacer(),
        _button('创建新钱包', const Color(0xFF226AD1), Colors.white, () {
          generatedMnemonic.value = ""; // Flag for Create path
          step.value = SetupStep.setPassword;
        }),
        const SizedBox(height: 16),
        _button('导入已有钱包', const Color(0xFFF5F5F5), Colors.black, () {
          generatedMnemonic.value = null; // Flag for Import path
          step.value = SetupStep.setPassword;
        }),
        const SizedBox(height: 48),
      ],
    );
  }

  Widget _buildSetPassword(
    ValueNotifier<SetupStep> step,
    TextEditingController controller,
    ValueNotifier<String?> generatedMnemonic,
  ) {
    final confirmController = useTextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '设置钱包密码',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        const Text(
          '此密码仅用于本机的钱包加密存储，请妥善保管。',
          style: TextStyle(fontSize: 14, color: Color(0xFF969696)),
        ),
        const SizedBox(height: 32),
        TextField(
          controller: controller,
          obscureText: true,
          decoration: InputDecoration(
            hintText: '输入加密密码',
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: confirmController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: '确认加密密码',
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const Spacer(),
        _button('继续', const Color(0xFF226AD1), Colors.white, () {
          if (controller.text.length < 6) return;
          if (controller.text != confirmController.text) return;

          if (generatedMnemonic.value == "") {
            generatedMnemonic.value = WalletService.generateMnemonic();
            step.value = SetupStep.backupMnemonic;
          } else {
            step.value = SetupStep.importMnemonic;
          }
        }),
        const SizedBox(height: 48),
      ],
    );
  }

  Widget _buildBackupMnemonic(
    WidgetRef ref,
    ValueNotifier<SetupStep> step,
    TextEditingController passwordController,
    ValueNotifier<String?> generatedMnemonic,
  ) {
    final mnemonic = generatedMnemonic.value!;
    final words = mnemonic.split(' ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '备份助记词',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        const Text(
          '请抄写并妥善保存这12个单词。',
          style: TextStyle(fontSize: 14, color: Color(0xFF969696)),
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: words.asMap().entries.map((entry) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFEAEAEA)),
                ),
                child: Text(
                  '${entry.key + 1}. ${entry.value}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const Spacer(),
        _button('我已妥善保存', const Color(0xFF226AD1), Colors.white, () async {
          await ref
              .read(walletProvider.notifier)
              .createWallet(passwordController.text);
        }),
        const SizedBox(height: 48),
      ],
    );
  }

  Widget _buildImportMnemonic(
    WidgetRef ref,
    ValueNotifier<SetupStep> step,
    TextEditingController passwordController,
    TextEditingController mnemonicController,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '导入助记词',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        const Text(
          '请输入您的12个助记词单词，以空格分隔。',
          style: TextStyle(fontSize: 14, color: Color(0xFF969696)),
        ),
        const SizedBox(height: 32),
        TextField(
          controller: mnemonicController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: '输入助记词...',
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const Spacer(),
        _button('开始导入', const Color(0xFF226AD1), Colors.white, () async {
          if (mnemonicController.text.split(' ').length != 12) {
            return;
          }
          await ref
              .read(walletProvider.notifier)
              .importWallet(
                mnemonicController.text.trim(),
                passwordController.text,
              );
        }),
        const SizedBox(height: 48),
      ],
    );
  }

  Widget _button(
    String label,
    Color bgColor,
    Color textColor,
    VoidCallback onTap,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
