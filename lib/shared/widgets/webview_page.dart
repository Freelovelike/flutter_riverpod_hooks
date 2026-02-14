import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_riverpod_hooks/core/theme/app_theme.dart';
import 'package:flutter_riverpod_hooks/shared/services/webview_bridge.dart';
import 'package:flutter_riverpod_hooks/core/theme/theme_provider.dart';
import 'package:flutter_riverpod_hooks/core/localization/locale_provider.dart';

class WebViewPage extends ConsumerStatefulWidget {
  final String url;
  final String title;

  const WebViewPage({
    super.key,
    required this.url,
    required this.title,
  });

  @override
  ConsumerState<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends ConsumerState<WebViewPage> {
  double _progress = 0;
  late final WebViewBridge _bridge;

  @override
  void initState() {
    super.initState();
    _bridge = WebViewBridge();

    // 1. 暴露方法供 web 子项目调用
    _bridge.expose({
      'getWalletAddress': () => '0x9b...E652',
      'getChainId': () => 1,
      'getThemeMode': () =>
          Theme.of(context).brightness == Brightness.dark ? 'dark' : 'light',
      'closePage': () => context.pop(),
      'navigateTo': (String route) => context.push(route),
    });

    // 2. 监听子项目 Ready 信号，同步状态
    _bridge.on('iframeReady', (payload) {
      debugPrint('[WebView] 收到 iframeReady，同步状态...');
      _syncState();
    });

    // 3. 监听业务事件
    _bridge.on('txSuccess', (payload) {
      debugPrint('[WebView] Transaction success: $payload');
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

  /// 同步当前主题和语言到 Web 端
  void _syncState() {
    // 稍微延迟一下，确保 JS 侧的监听器已经挂载好
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!mounted) return;
      final theme = Theme.of(context).brightness == Brightness.dark ? 'dark' : 'light';
      final lang = context.locale.languageCode;
      
      debugPrint('[WebView] Sending themeChange: $theme, langChange: $lang');
      _bridge.notify('themeChange', theme);
      _bridge.notify('langChange', lang);
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

    // 监听主题变化，动态通知 Web 端
    ref.listen(themeModeProvider, (previous, next) {
      final theme = next == ThemeMode.dark ? 'dark' : 'light';
      debugPrint('[WebView] Theme changed, notifying: $theme');
      _bridge.notify('themeChange', theme);
    });

    // 监听语言变化，动态通知 Web 端
    ref.listen(localeProvider, (previous, next) {
      if (next != null) {
        final lang = next.languageCode;
        debugPrint('[WebView] Locale changed, notifying: $lang');
        _bridge.notify('langChange', lang);
      }
    });

    return Scaffold(
      backgroundColor: colors.backgroundBase,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context, colors),
            if (_progress < 1.0)
              LinearProgressIndicator(
                value: _progress,
                backgroundColor: colors.backgroundSecondary,
                valueColor: AlwaysStoppedAnimation<Color>(colors.themePrimary),
                minHeight: 2,
              ),
            Expanded(
              child: InAppWebView(
                initialUrlRequest: URLRequest(
                  url: WebUri(_buildInitialUrl()),
                ),
                initialUserScripts: UnmodifiableListView<UserScript>([
                  _bridge.bridgeUserScript,
                ]),
                initialSettings: InAppWebViewSettings(
                  transparentBackground: true,
                  javaScriptEnabled: true,
                  domStorageEnabled: true,
                  allowFileAccess: true,
                  mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
                  useHybridComposition: true,
                ),
                onWebViewCreated: (controller) {
                  _bridge.attach(controller);
                },
                onLoadStop: (controller, url) async {
                  // 页面加载完毕后手动同步一次状态
                  _syncState();
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

  /// 构建初始 URL，带上语言和主题参数
  String _buildInitialUrl() {
    final uri = Uri.parse(widget.url);
    final theme = Theme.of(context).brightness == Brightness.dark ? 'dark' : 'light';
    final lang = context.locale.languageCode;
    
    // 模拟 TSLab 中的参数构建
    final params = Map<String, String>.from(uri.queryParameters);
    params['lang'] = lang;
    params['theme'] = theme;
    // 如果有其他参数如 authCode, ilink 也可以在这里添加
    params['authCode'] = ''; 
    params['ilink'] = '';

    return uri.replace(queryParameters: params).toString();
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
