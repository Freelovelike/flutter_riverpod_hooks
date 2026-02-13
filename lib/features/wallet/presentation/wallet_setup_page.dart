import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod_hooks/features/wallet/providers/wallet_provider.dart';
import 'package:flutter_riverpod_hooks/features/wallet/services/wallet_service.dart';
import 'package:easy_localization/easy_localization.dart';

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
        Text(
          'walletSetupWelcome'.tr(),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          'walletSetupSubtitle'.tr(),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, color: Color(0xFF969696)),
        ),
        const Spacer(),
        _button(
          'createNewWallet'.tr(),
          const Color(0xFF226AD1),
          Colors.white,
          () {
            generatedMnemonic.value = ""; // Flag for Create path
            step.value = SetupStep.setPassword;
          },
        ),
        const SizedBox(height: 16),
        _button(
          'importExistingWallet'.tr(),
          const Color(0xFFF5F5F5),
          Colors.black,
          () {
            generatedMnemonic.value = null; // Flag for Import path
            step.value = SetupStep.setPassword;
          },
        ),
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
        Text(
          'setPassword'.tr(),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          'setPasswordSubtitle'.tr(),
          style: const TextStyle(fontSize: 14, color: Color(0xFF969696)),
        ),
        const SizedBox(height: 32),
        TextField(
          controller: controller,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'enterPassword'.tr(),
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
            hintText: 'confirmPassword'.tr(),
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const Spacer(),
        _button('continue'.tr(), const Color(0xFF226AD1), Colors.white, () {
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
        Text(
          'backupMnemonic'.tr(),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          'backupMnemonicSubtitle'.tr(),
          style: const TextStyle(fontSize: 14, color: Color(0xFF969696)),
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
        _button(
          'iHaveSaved'.tr(),
          const Color(0xFF226AD1),
          Colors.white,
          () async {
            await ref
                .read(walletProvider.notifier)
                .createWallet(passwordController.text);
          },
        ),
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
        Text(
          'importMnemonic'.tr(),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          'importMnemonicSubtitle'.tr(),
          style: const TextStyle(fontSize: 14, color: Color(0xFF969696)),
        ),
        const SizedBox(height: 32),
        TextField(
          controller: mnemonicController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'enterMnemonic'.tr(),
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const Spacer(),
        _button(
          'startImport'.tr(),
          const Color(0xFF226AD1),
          Colors.white,
          () async {
            if (mnemonicController.text.split(' ').length != 12) {
              return;
            }
            await ref
                .read(walletProvider.notifier)
                .importWallet(
                  mnemonicController.text.trim(),
                  passwordController.text,
                );
          },
        ),
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
