import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod_hooks/core/theme/app_theme.dart';
import 'package:flutter_riverpod_hooks/shared/services/webview_bridge.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  final String title;

  const WebViewPage({
    super.key,
    required this.url,
    required this.title,
  });

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  double _progress = 0;
  late final WebViewBridge _bridge;

  @override
  void initState() {
    super.initState();
    _bridge = WebViewBridge();

    // 暴露方法供 web 子项目调用
    _bridge.expose({
      // 获取钱包地址
      'getWalletAddress': () => '0x9b...E652',
      // 获取当前链 ID
      'getChainId': () => 1,
      // 获取当前主题模式
      'getThemeMode': () =>
          Theme.of(context).brightness == Brightness.dark ? 'dark' : 'light',
      // 关闭 WebView 页面
      'closePage': () => context.pop(),
      // 导航到指定路由
      'navigateTo': (String route) => context.push(route),
    });

    // 监听 web 子项目发来的事件
    _bridge.on('txSuccess', (payload) {
      debugPrint('[WebView] Transaction success: $payload');
      // 可以在这里弹出 snackbar 或执行其他操作
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('交易成功: ${payload ?? ''}')),
        );
      }
    });

    _bridge.on('txError', (payload) {
      debugPrint('[WebView] Transaction error: $payload');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('交易失败: ${payload ?? ''}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _bridge.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);

    return Scaffold(
      backgroundColor: colors.backgroundBase,
      body: SafeArea(
        child: Column(
          children: [
            // 顶部导航栏
            _buildAppBar(context, colors),
            // 加载进度条
            if (_progress < 1.0)
              LinearProgressIndicator(
                value: _progress,
                backgroundColor: colors.backgroundSecondary,
                valueColor: AlwaysStoppedAnimation<Color>(colors.themePrimary),
                minHeight: 2,
              ),
            // WebView 内容
            Expanded(
              child: InAppWebView(
                initialUrlRequest: URLRequest(
                  url: WebUri(widget.url),
                ),
                initialSettings: InAppWebViewSettings(
                  transparentBackground: true,
                  javaScriptEnabled: true,
                  domStorageEnabled: true,
                  allowFileAccess: true,
                  mixedContentMode:
                      MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
                  useHybridComposition: true,
                ),
                onWebViewCreated: (controller) {
                  // 绑定桥接
                  _bridge.attach(controller);
                },
                onLoadStop: (controller, url) async {
                  // 页面加载完毕后注入桥接脚本
                  await _bridge.inject();
                },
                onProgressChanged: (controller, progress) {
                  setState(() {
                    _progress = progress / 100;
                  });
                },
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
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: colors.foregroundPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: () => context.pop(),
            child: Icon(
              Icons.close,
              size: 18,
              color: colors.foregroundSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
