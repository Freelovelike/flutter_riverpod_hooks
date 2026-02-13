import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:oktoast/oktoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod_hooks/features/todo/providers/todo_models.dart';
import 'package:flutter_riverpod_hooks/core/network/network_client.dart';

part 'auth_provider.g.dart';

const _tokenKey = 'auth_token';

class AuthCache {
  static String? token;
}

@riverpod
class Auth extends _$Auth {
  final _storage = const FlutterSecureStorage();

  @override
  FutureOr<bool> build() async {
    // 无论现在的 state 是什么，build 的任务就是根据“物理事实”（磁盘文件）给出一个初值
    final token = await _storage.read(key: _tokenKey);

    AuthCache.token = token;

    print('Auth Build 运行，发现 Token: ${token != null}');
    return token != null;
  }

  Future<void> login(String username, String password) async {
    final dto = LoginAndRegisterDto(username: username, password: password);

    try {
      final response = await ref
          .read(baseDioProvider)
          .post('/auth/login', data: dto.toJson());

      if (response.statusCode == 200) {
        final data = response.data;
        // 根据 Swagger，结构是 { "code": 200, "data": { "token": "..." }, "msg": "..." }
        if (data != null && data is Map && data['code'] == 200) {
          final innerData = data['data'];
          final dynamic tokenData = innerData['token'] ?? innerData['Token'];
          if (tokenData != null) {
            final token = tokenData.toString();
            await _storage.write(key: _tokenKey, value: token);
            AuthCache.token = token;
            state = AsyncData(true);
            return;
          }
        }
        print('Unexpected response structure: $data');
        throw Exception('Token not found or invalid response code');
      }
    } catch (e) {
      print('Login Error: $e');
      rethrow;
    }
  }

  Future<void> register(String username, String password) async {
    final dto = LoginAndRegisterDto(username: username, password: password);

    try {
      final response = await ref
          .read(baseDioProvider)
          .post('/auth/register', data: dto.toJson());

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.data);
        if (response.data['code'] == 200) {
          await login(username, password);
        } else {
          showToast(response.data['msg'] ?? '注册失败');
        }
      }
    } catch (e) {
      print('Register Error: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
    AuthCache.token = null;
    state = const AsyncData(false);
  }
}
