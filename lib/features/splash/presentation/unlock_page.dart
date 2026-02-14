import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:local_auth/local_auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod_hooks/features/splash/providers/app_lock_provider.dart';

import 'package:flutter_riverpod_hooks/core/theme/app_theme.dart';

class UnlockPage extends HookConsumerWidget {
  const UnlockPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColorsExtension.of(context);
    final passwordController = useTextEditingController();
    final isLoading = useState(false);
    final errorText = useState<String?>(null);
    final isBiometricAvailable = useState(false);

    // ... useEffect hooks stay the same ...
    useEffect(() {
      _checkBiometrics(isBiometricAvailable);
      return null;
    }, []);

    useEffect(() {
      if (isBiometricAvailable.value) {
        Future.microtask(
          () => _authenticateWithBiometrics(ref, context, isBiometricAvailable),
        );
      }
      return null;
    }, [isBiometricAvailable.value]);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),
              Image.asset('assets/image/logo.png', height: 48),
              const SizedBox(height: 32),
              Text(
                'unlockTitle'.tr(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'enterPasswordToUnlock'.tr(),
                style: TextStyle(fontSize: 14, color: colors.secondaryText),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: passwordController,
                obscureText: true,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                decoration: InputDecoration(
                  hintText: 'enterPassword'.tr(),
                  hintStyle: TextStyle(color: colors.secondaryText),
                  filled: true,
                  fillColor: colors.inputFill,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  errorText: errorText.value,
                ),
                onSubmitted: (_) => _unlockWithPassword(
                  ref,
                  passwordController,
                  isLoading,
                  errorText,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isLoading.value
                      ? null
                      : () => _unlockWithPassword(
                          ref,
                          passwordController,
                          isLoading,
                          errorText,
                        ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF226AD1),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'unlock'.tr(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              if (isBiometricAvailable.value)
                GestureDetector(
                  onTap: () => _authenticateWithBiometrics(
                    ref,
                    context,
                    isBiometricAvailable,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: colors.inputFill,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.fingerprint, color: Color(0xFF226AD1)),
                        const SizedBox(width: 8),
                        Text(
                          'useBiometrics'.tr(),
                          style: const TextStyle(
                            color: Color(0xFF226AD1),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _checkBiometrics(
    ValueNotifier<bool> isBiometricAvailable,
  ) async {
    final auth = LocalAuthentication();
    try {
      final canCheck = await auth.canCheckBiometrics;
      final isDeviceSupported = await auth.isDeviceSupported();
      isBiometricAvailable.value = canCheck && isDeviceSupported;
    } catch (e) {
      isBiometricAvailable.value = false;
    }
  }

  Future<void> _authenticateWithBiometrics(
    WidgetRef ref,
    BuildContext context,
    ValueNotifier<bool> isBiometricAvailable,
  ) async {
    final auth = LocalAuthentication();
    try {
      final didAuthenticate = await auth.authenticate(
        localizedReason: 'biometricReason'.tr(),
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
      if (didAuthenticate) {
        ref.read(appLockProvider.notifier).unlock();
      }
    } catch (e) {
      debugPrint('生物认证失败$e');
      // 生物认证失败，用户可以用密码解锁
    }
  }

  Future<void> _unlockWithPassword(
    WidgetRef ref,
    TextEditingController controller,
    ValueNotifier<bool> isLoading,
    ValueNotifier<String?> errorText,
  ) async {
    if (controller.text.isEmpty) return;

    isLoading.value = true;
    errorText.value = null;

    final success = await ref
        .read(appLockProvider.notifier)
        .unlockWithPassword(controller.text);

    isLoading.value = false;

    if (!success) {
      errorText.value = 'passwordIncorrect'.tr();
    }
  }
}
