import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/// Flutter 与 InAppWebView 子项目的跨窗口通信桥接
///
/// 完整兼容 web 端的 crossWindow 通信协议:
/// - RPC 调用 (call / reply)
/// - 事件广播 (event / on / notify)
/// - 方法暴露 (expose / listen)
///
/// 使用方式:
/// ```dart
/// final bridge = WebViewBridge();
///
/// // 暴露方法供 web 调用
/// bridge.expose({
///   'getWalletAddress': () => '0x9b...E652',
///   'getChainId': () => 1,
/// });
///
/// // 监听 web 事件
/// bridge.on('txSigned', (payload) => print('Transaction: $payload'));
///
/// // 在 InAppWebView 的 onWebViewCreated 中绑定
/// InAppWebView(
///   onWebViewCreated: (controller) => bridge.attach(controller),
///   onLoadStop: (controller, url) => bridge.inject(),
/// );
///
/// // 调用 web 端方法
/// final result = await bridge.call('getBalance', ['0x...']);
///
/// // 发送事件到 web
/// bridge.notify('themeChanged', {'mode': 'dark'});
/// ```
class WebViewBridge {
  InAppWebViewController? _controller;

  /// 待响应的 RPC 请求池
  final _pendingRequests = <String, Completer<dynamic>>{};

  /// 暴露给 web 端调用的方法
  final _exposedMethods = <String, Function>{};

  /// 事件监听器
  final _eventListeners = <String, List<void Function(dynamic)>>{};

  /// RPC 超时时间
  final Duration timeout;

  WebViewBridge({this.timeout = const Duration(seconds: 30)});

  // ==================== 生命周期 ====================

  /// 获取用于初始化注入的 UserScript
  UserScript get bridgeUserScript => UserScript(
        source: _bridgeScript,
        injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
      );

  /// 绑定 InAppWebViewController，注册 JS Handler
  ///
  /// 必须在 [onWebViewCreated] 回调中调用
  void attach(InAppWebViewController controller) {
    _controller = controller;

    // 注册 JS→Dart 消息通道
    controller.addJavaScriptHandler(
      handlerName: '_flutterBridge',
      callback: (args) {
        if (args.isNotEmpty) {
          _handleMessage(args[0]);
        }
        return null;
      },
    );
  }

  /// 注入桥接脚本到 web 页面
  ///
  /// 必须在 [onLoadStop] 回调中调用，确保页面 DOM 已就绪
  Future<void> inject() async {
    if (_controller == null) return;
    await _controller!.evaluateJavascript(source: _bridgeScript);
    debugPrint('[WebViewBridge] Bridge script injected');
  }

  /// 释放资源
  void dispose() {
    for (final completer in _pendingRequests.values) {
      if (!completer.isCompleted) {
        completer.completeError(Exception('Bridge disposed'));
      }
    }
    _pendingRequests.clear();
    _exposedMethods.clear();
    _eventListeners.clear();
    _controller = null;
  }

  // ==================== RPC 调用 (Flutter → Web) ====================

  /// 调用 web 端暴露的方法
  ///
  /// [method] 方法名（web 端通过 listen() 暴露的方法）
  /// [args] 参数列表
  /// 返回 web 端方法的返回值
  Future<T> call<T>(String method, [List<dynamic>? args]) async {
    if (_controller == null) {
      throw Exception('[WebViewBridge] Controller not attached');
    }

    final id = '${DateTime.now().microsecondsSinceEpoch}_${method.hashCode}';
    final completer = Completer<T>();
    _pendingRequests[id] = completer;

    // 超时处理
    final timer = Timer(timeout, () {
      if (_pendingRequests.containsKey(id)) {
        _pendingRequests.remove(id);
        if (!completer.isCompleted) {
          completer.completeError(
            TimeoutException('RPC call "$method" timed out', timeout),
          );
        }
      }
    });

    // 通过 dispatchEvent 发送 MessageEvent，触发 web 端的 message 监听器
    final msg = jsonEncode({
      'type': 'call',
      'id': id,
      'method': method,
      'args': args ?? [],
    });

    await _controller!.evaluateJavascript(source: 'window.__flutterTransmit($msg);');

    try {
      return await completer.future;
    } finally {
      timer.cancel();
    }
  }

  // ==================== 方法暴露 (Web → Flutter) ====================

  /// 暴露方法供 web 端调用
  ///
  /// web 端通过 `call(window.parent, '*', 'methodName', ...args)` 调用
  void expose(Map<String, Function> methods) {
    _exposedMethods.addAll(methods);
  }

  // ==================== 事件系统 ====================

  /// 监听 web 端发来的事件
  ///
  /// 返回取消监听的函数
  VoidCallback on(String eventName, void Function(dynamic payload) callback) {
    _eventListeners.putIfAbsent(eventName, () => []);
    _eventListeners[eventName]!.add(callback);

    return () {
      _eventListeners[eventName]?.remove(callback);
      if (_eventListeners[eventName]?.isEmpty ?? false) {
        _eventListeners.remove(eventName);
      }
    };
  }

  /// 向 web 端发送事件
  Future<void> notify(String eventName, [dynamic payload]) async {
    if (_controller == null) return;

    final msg = jsonEncode({
      'type': 'event',
      'eventName': eventName,
      'payload': payload,
    });

    await _controller!.evaluateJavascript(source: 'window.__flutterTransmit($msg);');
  }

  // ==================== 内部消息处理 ====================

  /// 处理从 web 端收到的消息
  Future<void> _handleMessage(dynamic data) async {
    if (data == null) return;

    // 如果是字符串，尝试解析 JSON
    Map<String, dynamic> msg;
    if (data is String) {
      try {
        msg = jsonDecode(data) as Map<String, dynamic>;
      } catch (_) {
        return;
      }
    } else if (data is Map) {
      msg = Map<String, dynamic>.from(data);
    } else {
      return;
    }

    final type = msg['type'] as String?;
    if (type == null) return;

    switch (type) {
      // ---- RPC 响应 (web 回复 flutter 的调用) ----
      case 'reply':
        _handleReply(msg);
        break;

      // ---- RPC 请求 (web 调用 flutter 暴露的方法) ----
      case 'call':
        await _handleCall(msg);
        break;

      // ---- 事件 (web 发来的广播事件) ----
      case 'event':
        _handleEvent(msg);
        break;
    }
  }

  void _handleReply(Map<String, dynamic> msg) {
    final id = msg['id'] as String?;
    if (id == null) return;

    final completer = _pendingRequests.remove(id);
    if (completer == null) return;

    if (msg['error'] != null) {
      completer.completeError(Exception(msg['error'].toString()));
    } else {
      completer.complete(msg['result']);
    }
  }

  Future<void> _handleCall(Map<String, dynamic> msg) async {
    final method = msg['method'] as String?;
    final id = msg['id'] as String?;
    if (method == null || id == null) return;

    final fn = _exposedMethods[method];

    if (fn == null) {
      await _sendReply(id, error: 'Method "$method" is not exposed on Flutter side.');
      return;
    }

    try {
      final args = (msg['args'] as List<dynamic>?) ?? [];
      dynamic result;
      // 支持 0~5 个参数的 Function 调用
      switch (args.length) {
        case 0:
          result = await fn();
          break;
        case 1:
          result = await fn(args[0]);
          break;
        case 2:
          result = await fn(args[0], args[1]);
          break;
        case 3:
          result = await fn(args[0], args[1], args[2]);
          break;
        default:
          result = await Function.apply(fn, args);
      }
      await _sendReply(id, result: result);
    } catch (e) {
      await _sendReply(id, error: e.toString());
    }
  }

  void _handleEvent(Map<String, dynamic> msg) {
    final eventName = msg['eventName'] as String?;
    if (eventName == null) return;

    final listeners = _eventListeners[eventName];
    if (listeners == null || listeners.isEmpty) return;

    final payload = msg['payload'];
    for (final listener in List.of(listeners)) {
      try {
        listener(payload);
      } catch (e) {
        debugPrint('[WebViewBridge] Error in event listener "$eventName": $e');
      }
    }
  }

  /// 向 web 端发送 RPC 回复
  Future<void> _sendReply(String id, {dynamic result, String? error}) async {
    if (_controller == null) return;

    final reply = <String, dynamic>{
      'type': 'reply',
      'id': id,
    };
    if (error != null) {
      reply['error'] = error;
    } else {
      reply['result'] = result;
    }

    final msg = jsonEncode(reply);
    await _controller!.evaluateJavascript(source: 'window.__flutterTransmit($msg);');
  }

  // ==================== 注入的 JS 桥接脚本 ====================

  /// 注入到 web 页面的桥接脚本
  static const _bridgeScript = '''
(function() {
  if (window.__flutterBridgeInjected) return;
  window.__flutterBridgeInjected = true;
  // --- 1. 核心伪装：让子应用确信自己跑在 iframe 里 ---
  var _virtualParent = {
    postMessage: function(msg, origin) {
      // 子应用调用 parent.postMessage 时，转发给 Flutter
      window.__flutterInternalPost(msg);
    },
    closed: false, frames: window.frames, length: window.length,
    name: 'flutter_host', opener: null, self: null, top: null, window: null
  };
  _virtualParent.self = _virtualParent.parent = _virtualParent.top = _virtualParent.window = _virtualParent;
  try {
    Object.defineProperty(window, 'parent', {
      get: function() { return _virtualParent; },
      set: function() {}
    });
    window.__virtualParent = _virtualParent;
    console.log('[FlutterBridge] window.parent mocked.');
  } catch(e) { console.warn('[FlutterBridge] Mock parent failed:', e); }
  // --- 2. 消息流转逻辑 ---
  var msgQueue = [];
  
  // Flutter 调用这个函数来发消息给 Web
  window.__flutterTransmit = function(msg) {
    if (typeof msg === 'string') msg = JSON.parse(msg);
    msg.__fromFlutter = true; // 增加标识，防止回传给 Flutter
    
    // 触发一个真实的 message 事件，确保跨窗口通信库能收到
    window.postMessage(msg, '*');
  };
  // 转发给 Flutter 的核心函数
  window.__flutterInternalPost = function(msg) {
    if (window.flutter_inappwebview && window.flutter_inappwebview.callHandler) {
      window.flutter_inappwebview.callHandler('_flutterBridge', msg);
      return true;
    }
    return false;
  };
  // 轮询检查原生对象是否就绪并排空队列
  var checkTimer = setInterval(function() {
    if (window.flutter_inappwebview && window.flutter_inappwebview.callHandler) {
      while (msgQueue.length > 0) window.__flutterInternalPost(msgQueue.shift());
      clearInterval(checkTimer);
    }
  }, 50);
  // 监听所有 message，过滤掉 Flutter 发过来的，剩下的全部转发给 Flutter
  window.addEventListener('message', function(event) {
    var msg = event.data;
    if (!msg || typeof msg !== 'object' || !msg.type || msg.__fromFlutter) return;
    console.log('[FlutterBridge] Captured Web message:', msg.type);
    if (!window.__flutterInternalPost(msg)) {
      msgQueue.push(msg);
    }
  });
  console.log('[FlutterBridge] Bridge ready.');
})();
''';
}
