import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod_hooks/core/theme/app_theme.dart';
import 'package:flutter_riverpod_hooks/core/theme/theme_provider.dart';
import 'package:flutter_riverpod_hooks/core/localization/locale_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColorsExtension.of(context);
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final currentLocale = context.locale;

    return Scaffold(
      backgroundColor: colors.backgroundBase,
      body: SafeArea(
        child: Column(
          children: [
            // 顶部导航栏
            _buildAppBar(context, colors),
            // 内容区域
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  const SizedBox(height: 24),
                  // 设定分组
                  _buildSection(
                    colors: colors,
                    title: 'settingsGroup'.tr(),
                    items: [
                      _SettingsItem(
                        icon: Icons.language,
                        title: 'nodeSettings'.tr(),
                        onTap: () {},
                      ),
                      _SettingsItem(
                        icon: Icons.delete_outline,
                        title: 'clearCache'.tr(),
                        onTap: () {},
                      ),
                      _SettingsItem(
                        icon: Icons.palette_outlined,
                        title: 'theme'.tr(),
                        trailing: isDark ? 'darkMode'.tr() : 'lightMode'.tr(),
                        onTap: () {
                          _showThemePicker(context, ref, colors, isDark);
                        },
                      ),
                      _SettingsItem(
                        icon: Icons.public,
                        title: 'language'.tr(),
                        trailing: currentLocale.languageCode == 'zh'
                            ? 'simplifiedChinese'.tr()
                            : 'English',
                        onTap: () {
                          _showLanguagePicker(context, ref, colors, currentLocale);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // 安全分组
                  _buildSection(
                    colors: colors,
                    title: 'securityGroup'.tr(),
                    items: [
                      _SettingsItem(
                        icon: Icons.shield_outlined,
                        title: 'passwordPay'.tr(),
                        trailing: 'enabled'.tr(),
                        showArrow: false,
                        onTap: () {},
                      ),
                      _SettingsItem(
                        icon: Icons.lock_outline,
                        title: 'changePassword'.tr(),
                        onTap: () {},
                      ),
                      _SettingsItem(
                        icon: Icons.dns_outlined,
                        title: 'oneKeyMigration'.tr(),
                        onTap: () {},
                      ),
                      _SettingsItem(
                        icon: Icons.security_outlined,
                        title: 'walletSecurity'.tr(),
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // 关于分组
                  _buildSection(
                    colors: colors,
                    title: 'aboutGroup'.tr(),
                    items: [
                      _SettingsItem(
                        icon: Icons.info_outline,
                        title: 'faq'.tr(),
                        onTap: () {},
                      ),
                      _SettingsItem(
                        icon: Icons.person_outline,
                        title: 'userAgreement'.tr(),
                        onTap: () {},
                      ),
                      _SettingsItem(
                        icon: Icons.verified_user_outlined,
                        title: 'privacyPolicy'.tr(),
                        onTap: () {},
                      ),
                      _SettingsItem(
                        icon: Icons.share_outlined,
                        title: 'shareApp'.tr(),
                        onTap: () {},
                      ),
                      _SettingsItem(
                        icon: Icons.update,
                        title: 'currentVersion'.tr(),
                        trailing: '2.4.0',
                        showArrow: false,
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // 关注我们分组
                  _buildSection(
                    colors: colors,
                    title: 'followUs'.tr(),
                    items: [
                      _SettingsItem(
                        icon: Icons.monitor,
                        title: 'walletWebsite'.tr(),
                        onTap: () {},
                      ),
                      _SettingsItem(
                        icon: Icons.flutter_dash,
                        title: 'Twitter',
                        onTap: () {},
                      ),
                      _SettingsItem(
                        icon: Icons.telegram,
                        title: 'Telegram',
                        onTap: () {},
                      ),
                      _SettingsItem(
                        icon: Icons.facebook,
                        title: 'Facebook',
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, AppColorsExtension colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Icon(
              Icons.arrow_back_ios,
              size: 16,
              color: colors.foregroundPrimary,
            ),
          ),
          const Spacer(),
          Text(
            'settings'.tr(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: colors.foregroundPrimary,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 16), // 平衡返回按钮的空间
        ],
      ),
    );
  }

  Widget _buildSection({
    required AppColorsExtension colors,
    required String title,
    required List<_SettingsItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: colors.foregroundSecondary,
          ),
        ),
        const SizedBox(height: 16),
        ...items.map((item) => _buildMenuItem(colors, item)),
      ],
    );
  }

  Widget _buildMenuItem(AppColorsExtension colors, _SettingsItem item) {
    return GestureDetector(
      onTap: item.onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Row(
          children: [
            Icon(
              item.icon,
              size: 14,
              color: colors.foregroundPrimary,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                item.title,
                style: TextStyle(
                  fontSize: 14,
                  color: colors.foregroundPrimary,
                ),
              ),
            ),
            if (item.trailing != null)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  item.trailing!,
                  style: TextStyle(
                    fontSize: 14,
                    color: colors.foregroundSecondary,
                  ),
                ),
              ),
            if (item.showArrow)
              Icon(
                Icons.arrow_forward_ios,
                size: 12,
                color: colors.foregroundSecondary,
              ),
          ],
        ),
      ),
    );
  }

  void _showThemePicker(
    BuildContext context,
    WidgetRef ref,
    AppColorsExtension colors,
    bool isDark,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.backgroundCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: colors.foregroundSecondary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            _buildPickerOption(
              colors: colors,
              icon: Icons.wb_sunny_outlined,
              title: 'lightMode'.tr(),
              selected: !isDark,
              onTap: () {
                ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.light);
                Navigator.pop(context);
              },
            ),
            Divider(height: 1, color: colors.borderDivider),
            _buildPickerOption(
              colors: colors,
              icon: Icons.nightlight_round,
              title: 'darkMode'.tr(),
              selected: isDark,
              onTap: () {
                ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.dark);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showLanguagePicker(
    BuildContext context,
    WidgetRef ref,
    AppColorsExtension colors,
    Locale currentLocale,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.backgroundCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: colors.foregroundSecondary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            _buildPickerOption(
              colors: colors,
              icon: Icons.translate,
              title: '简体中文',
              selected: currentLocale.languageCode == 'zh',
              onTap: () {
                const locale = Locale('zh');
                context.setLocale(locale);
                ref.read(localeProvider.notifier).setLocale(locale);
                Navigator.pop(context);
              },
            ),
            Divider(height: 1, color: colors.borderDivider),
            _buildPickerOption(
              colors: colors,
              icon: Icons.translate,
              title: 'English',
              selected: currentLocale.languageCode == 'en',
              onTap: () {
                const locale = Locale('en');
                context.setLocale(locale);
                ref.read(localeProvider.notifier).setLocale(locale);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPickerOption({
    required AppColorsExtension colors,
    required IconData icon,
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 18, color: colors.foregroundPrimary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: colors.foregroundPrimary,
                ),
              ),
            ),
            if (selected)
              Icon(Icons.check, size: 18, color: colors.themePrimary),
          ],
        ),
      ),
    );
  }
}

class _SettingsItem {
  final IconData icon;
  final String title;
  final String? trailing;
  final bool showArrow;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.icon,
    required this.title,
    this.trailing,
    this.showArrow = true,
    required this.onTap,
  });
}
