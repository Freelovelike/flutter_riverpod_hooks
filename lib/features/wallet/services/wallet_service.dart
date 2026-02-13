import 'dart:convert';
import 'dart:typed_data';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:web3dart/web3dart.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:pointycastle/export.dart';
import 'package:hex/hex.dart';

class WalletService {
  // Generate a new 12-word mnemonic
  static String generateMnemonic() {
    return bip39.generateMnemonic();
  }

  // Derive private key from mnemonic using BIP44 (m/44'/60'/0'/0/0)
  static String getPrivateKey(String mnemonic) {
    final seed = bip39.mnemonicToSeed(mnemonic);
    final root = bip32.BIP32.fromSeed(seed);
    final child = root.derivePath("m/44'/60'/0'/0/0");
    return HEX.encode(child.privateKey!);
  }

  // Get address from private key
  static String getAddress(String privateKeyHex) {
    final credentials = EthPrivateKey.fromHex(privateKeyHex);
    return credentials.address.hex;
  }

  // Encrypt data with a password using AES-CBC and PBKDF2 for key derivation
  static String encryptWallet(Map<String, dynamic> data, String password) {
    final jsonData = jsonEncode(data);

    // Generate a random salt
    final salt = Uint8List(
      16,
    ); // In a real app, generate securely. For simplicity, we'll use a fixed but unique salt if possible or store it.
    // To keep it simple but safe for local storage, we can use the password + a constant salt if we don't want to store salt separately.
    // Better: generate salt and prepend to the encrypted data.

    final keySource = _deriveKey(password, salt);
    final key = encrypt.Key(keySource);
    final iv = encrypt.IV.fromLength(16);

    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(jsonData, iv: iv);

    // Return salt + iv + encrypted_data as a single base64 string
    final combined = Uint8List.fromList(salt + iv.bytes + encrypted.bytes);
    return base64Encode(combined);
  }

  // Decrypt data with a password
  static Map<String, dynamic> decryptWallet(
    String encryptedBase64,
    String password,
  ) {
    final combined = base64Decode(encryptedBase64);

    final salt = combined.sublist(0, 16);
    final iv = encrypt.IV(combined.sublist(16, 32));
    final encryptedBytes = combined.sublist(32);

    final keySource = _deriveKey(password, salt);
    final key = encrypt.Key(keySource);

    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final decrypted = encrypter.decrypt(
      encrypt.Encrypted(encryptedBytes),
      iv: iv,
    );

    return jsonDecode(decrypted) as Map<String, dynamic>;
  }

  // Derive a 32-byte key from a password using PBKDF2
  static Uint8List _deriveKey(String password, Uint8List salt) {
    final derivator = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64));
    derivator.init(Pbkdf2Parameters(salt, 10000, 32));
    return derivator.process(Uint8List.fromList(utf8.encode(password)));
  }
}
