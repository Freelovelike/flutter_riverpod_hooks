import 'package:flutter/material.dart';

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color foregroundPrimary;
  final Color foregroundSecondary;
  final Color foregroundAuxiliary;
  final Color foregroundBottom;
  final Color foregroundHint;
  final Color foregroundSuccess;
  final Color foregroundError;
  final Color backgroundBase;
  final Color backgroundModal;
  final Color backgroundCard;
  final Color backgroundSecondary;
  final Color backgroundElevated;
  final Color backgroundCollection;
  final Color themePrimary;
  final Color borderDivider;
  final Color borderDividerWeak;
  final Color foregroundCtaText;
  final Color bgSecondary;

  // 兼容旧名字的别名
  Color get background => backgroundBase;
  Color get cardBackground => backgroundCard;
  Color get secondaryText => foregroundSecondary;
  Color get inputFill => backgroundCollection;

  const AppColorsExtension({
    required this.foregroundPrimary,
    required this.foregroundSecondary,
    required this.foregroundAuxiliary,
    required this.foregroundBottom,
    required this.foregroundHint,
    required this.foregroundSuccess,
    required this.foregroundError,
    required this.backgroundBase,
    required this.backgroundModal,
    required this.backgroundCard,
    required this.backgroundSecondary,
    required this.backgroundElevated,
    required this.backgroundCollection,
    required this.themePrimary,
    required this.borderDivider,
    required this.borderDividerWeak,
    required this.foregroundCtaText,
    required this.bgSecondary,
  });

  @override
  AppColorsExtension copyWith({
    Color? foregroundPrimary,
    Color? foregroundSecondary,
    Color? foregroundAuxiliary,
    Color? foregroundBottom,
    Color? foregroundHint,
    Color? foregroundSuccess,
    Color? foregroundError,
    Color? backgroundBase,
    Color? backgroundModal,
    Color? backgroundCard,
    Color? backgroundSecondary,
    Color? backgroundElevated,
    Color? backgroundCollection,
    Color? themePrimary,
    Color? borderDivider,
    Color? borderDividerWeak,
    Color? foregroundCtaText,
    Color? bgSecondary,
  }) {
    return AppColorsExtension(
      foregroundPrimary: foregroundPrimary ?? this.foregroundPrimary,
      foregroundSecondary: foregroundSecondary ?? this.foregroundSecondary,
      foregroundAuxiliary: foregroundAuxiliary ?? this.foregroundAuxiliary,
      foregroundBottom: foregroundBottom ?? this.foregroundBottom,
      foregroundHint: foregroundHint ?? this.foregroundHint,
      foregroundSuccess: foregroundSuccess ?? this.foregroundSuccess,
      foregroundError: foregroundError ?? this.foregroundError,
      backgroundBase: backgroundBase ?? this.backgroundBase,
      backgroundModal: backgroundModal ?? this.backgroundModal,
      backgroundCard: backgroundCard ?? this.backgroundCard,
      backgroundSecondary: backgroundSecondary ?? this.backgroundSecondary,
      backgroundElevated: backgroundElevated ?? this.backgroundElevated,
      backgroundCollection: backgroundCollection ?? this.backgroundCollection,
      themePrimary: themePrimary ?? this.themePrimary,
      borderDivider: borderDivider ?? this.borderDivider,
      borderDividerWeak: borderDividerWeak ?? this.borderDividerWeak,
      foregroundCtaText: foregroundCtaText ?? this.foregroundCtaText,
      bgSecondary: bgSecondary ?? this.bgSecondary,
    );
  }

  @override
  AppColorsExtension lerp(ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(
      foregroundPrimary: Color.lerp(foregroundPrimary, other.foregroundPrimary, t)!,
      foregroundSecondary: Color.lerp(foregroundSecondary, other.foregroundSecondary, t)!,
      foregroundAuxiliary: Color.lerp(foregroundAuxiliary, other.foregroundAuxiliary, t)!,
      foregroundBottom: Color.lerp(foregroundBottom, other.foregroundBottom, t)!,
      foregroundHint: Color.lerp(foregroundHint, other.foregroundHint, t)!,
      foregroundSuccess: Color.lerp(foregroundSuccess, other.foregroundSuccess, t)!,
      foregroundError: Color.lerp(foregroundError, other.foregroundError, t)!,
      backgroundBase: Color.lerp(backgroundBase, other.backgroundBase, t)!,
      backgroundModal: Color.lerp(backgroundModal, other.backgroundModal, t)!,
      backgroundCard: Color.lerp(backgroundCard, other.backgroundCard, t)!,
      backgroundSecondary: Color.lerp(backgroundSecondary, other.backgroundSecondary, t)!,
      backgroundElevated: Color.lerp(backgroundElevated, other.backgroundElevated, t)!,
      backgroundCollection: Color.lerp(backgroundCollection, other.backgroundCollection, t)!,
      themePrimary: Color.lerp(themePrimary, other.themePrimary, t)!,
      borderDivider: Color.lerp(borderDivider, other.borderDivider, t)!,
      borderDividerWeak: Color.lerp(borderDividerWeak, other.borderDividerWeak, t)!,
      foregroundCtaText: Color.lerp(foregroundCtaText, other.foregroundCtaText, t)!,
      bgSecondary: Color.lerp(bgSecondary, other.bgSecondary, t)!,
    );
  }

  static AppColorsExtension of(BuildContext context) {
    return Theme.of(context).extension<AppColorsExtension>()!;
  }
}

final lightAppColors = AppColorsExtension(
  foregroundPrimary: const Color(0xFF1A1A1A),
  foregroundSecondary: const Color(0xFFB2B5B9),
  foregroundAuxiliary: const Color(0xFFC4CFFF),
  foregroundBottom: const Color(0xFF8F8E93),
  foregroundHint: const Color(0xFFF1950A),
  foregroundSuccess: const Color(0xFF00C897),
  foregroundError: const Color(0xFFF45C5B),
  backgroundBase: const Color(0xFFFFFFFF),
  backgroundModal: const Color(0xFFEDF0F7),
  backgroundCard: const Color(0xFFF3F4F8),
  backgroundSecondary: const Color(0xFFD8E4FF),
  backgroundElevated: const Color(0xFFF8F9FE),
  backgroundCollection: const Color(0xFFF2F3F5),
  themePrimary: const Color(0xFF0449E4),
  borderDivider: const Color(0xFFE3E3E3),
  borderDividerWeak: const Color(0xFFFAFAFA),
  foregroundCtaText: const Color(0xFFFFFFFF),
  bgSecondary: const Color(0xFFF8F9FF),
);

final darkAppColors = AppColorsExtension(
  foregroundPrimary: const Color(0xFFFFFFFF),
  foregroundSecondary: const Color(0xFF8996A9),
  foregroundAuxiliary: const Color(0xFFA8BFDA),
  foregroundBottom: const Color(0xFF8F8E93),
  foregroundHint: const Color(0xFFF1950A),
  foregroundSuccess: const Color(0xFF00C897),
  foregroundError: const Color(0xFFF45C5B),
  backgroundBase: const Color(0xFF0F0F0F),
  backgroundModal: const Color(0xFF1E1E1E),
  backgroundCard: const Color(0xFF2A2C2E),
  backgroundSecondary: const Color(0xFF131C30),
  backgroundElevated: const Color(0xFF222733),
  backgroundCollection: const Color(0xFF36415A),
  themePrimary: const Color(0xFF0449E4),
  borderDivider: const Color(0xFF393D4B),
  borderDividerWeak: const Color(0xFF171A1F),
  foregroundCtaText: const Color(0xFFFFFFFF),
  bgSecondary: const Color(0xFF1D1E20),
);