// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_lock_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AppLock)
const appLockProvider = AppLockProvider._();

final class AppLockProvider
    extends $AsyncNotifierProvider<AppLock, AppLockState> {
  const AppLockProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLockProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLockHash();

  @$internal
  @override
  AppLock create() => AppLock();
}

String _$appLockHash() => r'e100cc09e908397c927e9aab39551d21f1ae5885';

abstract class _$AppLock extends $AsyncNotifier<AppLockState> {
  FutureOr<AppLockState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<AppLockState>, AppLockState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AppLockState>, AppLockState>,
              AsyncValue<AppLockState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
