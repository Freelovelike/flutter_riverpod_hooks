import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod_hooks/features/wallet/services/wallet_service.dart';

part 'app_lock_provider.g.dart';

enum AppLockState { loading, locked, unlocked }

const _walletKey = 'wallet_encrypted_data';
const _addressKey = 'wallet_address';

@Riverpod(keepAlive: true)
class AppLock extends _$AppLock {
  final _storage = const FlutterSecureStorage();

  @override
  FutureOr<AppLockState> build() async {
    final address = await _storage.read(key: _addressKey);
    if (address == null) {
      return AppLockState.unlocked;
    }
    return AppLockState.locked;
  }

  /// 验证密码解锁
  Future<bool> unlockWithPassword(String password) async {
    final encrypted = await _storage.read(key: _walletKey);
    if (encrypted == null) return false;

    try {
      WalletService.decryptWallet(encrypted, password);
      state = const AsyncData(AppLockState.unlocked);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 生物认证成功后直接解锁
  void unlock() {
    state = const AsyncData(AppLockState.unlocked);
  }

  /// 锁定应用（从后台恢复时调用）
  void lock() {
    // 只在已解锁且有钱包时锁定
    if (state.value == AppLockState.unlocked) {
      state = const AsyncData(AppLockState.locked);
    }
  }
}
