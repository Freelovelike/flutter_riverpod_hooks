import 'package:flutter/material.dart';
import 'package:flutter_riverpod_hooks/core/router/router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'locale_provider.g.dart';

@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  @override
  Locale? build() => null; // Initial state

  void setLocale(Locale locale) {
    state = locale;
    ref.read(routerProvider).refresh();
  }
}
