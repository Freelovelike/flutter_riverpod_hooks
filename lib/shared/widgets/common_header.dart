import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_riverpod_hooks/core/theme/theme_provider.dart';
import 'package:flutter_riverpod_hooks/core/localization/locale_provider.dart';

class CommonHeader extends HookConsumerWidget implements PreferredSizeWidget {
  const CommonHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return AppBar(
      backgroundColor: Theme.of(context).cardColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
        child: Row(
          children: [
            // Logo
            Image.asset(
              isDark
                  ? 'assets/image/logo.png'
                  : 'assets/image/logo.png', // Change if you have a dark logo
              height: 20,
            ),
            const Spacer(),
            // Wallet Chip
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF226AD1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 8,
                      // backgroundImage: NetworkImage(
                      //   'http://localhost:3845/assets/7295164430571b46b9fbb1781cd8a3e8631971eb.png',
                      // ),
                    ),
                    SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        '0x9b...E652',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Language Dropdown
            DropdownButtonHideUnderline(
              child: DropdownButton<Locale>(
                value: context.locale,
                icon: const Icon(Icons.language, size: 20),
                items: const [
                  DropdownMenuItem(value: Locale('en'), child: Text('EN')),
                  DropdownMenuItem(value: Locale('zh'), child: Text('中文')),
                ],
                onChanged: (Locale? newLocale) {
                  if (newLocale != null) {
                    context.setLocale(newLocale);
                    ref.read(localeProvider.notifier).setLocale(newLocale);
                  }
                },
              ),
            ),
            const SizedBox(width: 4),
            // Theme Switcher
            IconButton(
              icon: Icon(
                isDark ? Icons.wb_sunny : Icons.nightlight_round,
                size: 20,
              ),
              onPressed: () {
                ref.read(themeModeProvider.notifier).toggleTheme();
              },
            ),
          ],
        ),
      ),
    );
  }
}
