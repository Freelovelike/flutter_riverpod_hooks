import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod_hooks/features/wallet/services/wallet_service.dart';

part 'wallet_provider.g.dart';

const _walletKey = 'wallet_encrypted_data';
const _addressKey = 'wallet_address';

@riverpod
class Wallet extends _$Wallet {
  final _storage = const FlutterSecureStorage();

  @override
  FutureOr<String?> build() async {
    // We only expose the address to the UI by default
    return await _storage.read(key: _addressKey);
  }

  Future<void> createWallet(String password) async {
    final mnemonic = WalletService.generateMnemonic();
    final privateKey = WalletService.getPrivateKey(mnemonic);
    final address = WalletService.getAddress(privateKey);

    final walletData = {
      'mnemonic': mnemonic,
      'privateKey': privateKey,
      'address': address,
    };

    final encrypted = WalletService.encryptWallet(walletData, password);

    await _storage.write(key: _walletKey, value: encrypted);
    await _storage.write(key: _addressKey, value: address);

    state = AsyncData(address);
  }

  Future<void> importWallet(String mnemonic, String password) async {
    final privateKey = WalletService.getPrivateKey(mnemonic);
    final address = WalletService.getAddress(privateKey);

    final walletData = {
      'mnemonic': mnemonic,
      'privateKey': privateKey,
      'address': address,
    };

    final encrypted = WalletService.encryptWallet(walletData, password);

    await _storage.write(key: _walletKey, value: encrypted);
    await _storage.write(key: _addressKey, value: address);

    state = AsyncData(address);
  }

  Future<Map<String, dynamic>> getWalletDetails(String password) async {
    final encrypted = await _storage.read(key: _walletKey);
    if (encrypted == null) throw Exception('No wallet found');

    return WalletService.decryptWallet(encrypted, password);
  }

  Future<void> deleteWallet() async {
    await _storage.delete(key: _walletKey);
    await _storage.delete(key: _addressKey);
    state = const AsyncData(null);
  }
}
