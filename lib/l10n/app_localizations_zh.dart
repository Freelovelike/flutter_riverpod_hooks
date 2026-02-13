// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'BeingDex';

  @override
  String get home => '首页';

  @override
  String get assets => '资产';

  @override
  String get walletManagement => '钱包管理';

  @override
  String get mine => '我的';

  @override
  String get login => '登录';

  @override
  String get register => '注册';

  @override
  String get username => '用户名';

  @override
  String get password => '密码';

  @override
  String get confirmPassword => '确认密码';

  @override
  String get loginSuccess => '登录成功';

  @override
  String get loginFailed => '登录失败';

  @override
  String get registerSuccess => '注册成功';

  @override
  String get registerFailed => '注册失败';

  @override
  String get logout => '注销';

  @override
  String get settings => '设置';

  @override
  String get welcomeBack => '欢迎回来';

  @override
  String get startJourney => '开启交易之旅';

  @override
  String get loginSubtitle => '输入你的账号密码以登录';

  @override
  String get registerSubtitle => '创建一个新账号以开始';

  @override
  String get fillFields => '请填写完整信息';

  @override
  String get operationFailed => '操作失败';

  @override
  String get noAccountRegister => '没有账号？去注册';

  @override
  String get haveAccountLogin => '已有账号？去登录';
}
