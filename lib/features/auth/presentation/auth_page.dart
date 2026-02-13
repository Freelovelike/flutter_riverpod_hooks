import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter_riverpod_hooks/features/auth/providers/auth_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AuthPage extends HookConsumerWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final usernameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final isLogin = useState(true);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.appTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF226AD1),
                ),
              ),
              const SizedBox(height: 48),
              Text(
                isLogin.value ? l10n.welcomeBack : l10n.startJourney,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isLogin.value ? l10n.loginSubtitle : l10n.registerSubtitle,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: l10n.username,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: l10n.password,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  final username = usernameController.text;
                  final password = passwordController.text;
                  if (username.isEmpty || password.isEmpty) {
                    showToast(l10n.fillFields);
                    return;
                  }
                  try {
                    if (isLogin.value) {
                      await ref
                          .read(authProvider.notifier)
                          .login(username, password);
                    } else {
                      await ref
                          .read(authProvider.notifier)
                          .register(username, password);
                    }
                  } catch (e) {
                    showToast('${l10n.operationFailed}: $e');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF226AD1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  isLogin.value ? l10n.login : l10n.register,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => isLogin.value = !isLogin.value,
                child: Text(
                  isLogin.value
                      ? l10n.noAccountRegister
                      : l10n.haveAccountLogin,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
