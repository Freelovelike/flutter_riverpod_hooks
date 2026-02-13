import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod_hooks/features/auth/providers/auth_provider.dart';

part 'network_client.g.dart';

@riverpod
Dio baseDio(Ref ref) {
  return Dio(
      BaseOptions(
        baseUrl: 'http://127.0.0.1:1323/api',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
        contentType: Headers.jsonContentType,
      ),
    )
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('HTTP Request: [${options.method}] ${options.path}');
          print('Data: ${options.data}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('HTTP Response: [${response.statusCode}] ${response.data}');
          return handler.next(response);
        },
        onError: (e, handler) {
          print('HTTP Error: [${e.response?.statusCode}] ${e.message}');
          return handler.next(e);
        },
      ),
    );
}

@riverpod
Dio authenticatedDio(Ref ref) {
  final dio = ref.watch(baseDioProvider);
  // final auth = ref.watch(authProvider);
  final token = AuthCache.token;
  print('Token: $token');
  if (token != null) {
    dio.options.headers['Authorization'] = 'Bearer $token';
  } else {
    dio.options.headers.remove('Authorization');
  }

  return dio;
}
