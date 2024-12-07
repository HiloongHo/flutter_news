/// 日志工具类，用于统一管理应用日志输出
final class Log {
  // 私有构造函数，防止实例化
  Log._();

  // 是否启用日志（可以在发布时关闭）
  static bool _enabled = true;

  // 日志级别
  static const int _verbose = 1;
  static const int _debug = 2;
  static const int _info = 3;
  static const int _warn = 4;
  static const int _error = 5;

  // 当前日志级别
  static int _level = _verbose;

  /// 初始化日志工具
  /// 
  /// [enabled] 是否启用日志
  /// [level] 日志级别，默认为 verbose
  static void init({bool enabled = true, int level = _verbose}) {
    _enabled = enabled;
    _level = level;
  }

  /// 输出 verbose 级别日志
  static void v(String tag, String message) {
    if (_enabled && _level <= _verbose) {
      print('🟣 V/$tag: $message');
    }
  }

  /// 输出 debug 级别日志
  static void d(String tag, String message) {
    if (_enabled && _level <= _debug) {
      print('🔵 D/$tag: $message');
    }
  }

  /// 输出 info 级别日志
  static void i(String tag, String message) {
    if (_enabled && _level <= _info) {
      print('🟢 I/$tag: $message');
    }
  }

  /// 输出 warning 级别日志
  static void w(String tag, String message) {
    if (_enabled && _level <= _warn) {
      print('🟡 W/$tag: $message');
    }
  }

  /// 输出 error 级别日志
  /// 
  /// [error] 可选的错误详情
  static void e(String tag, String message, [dynamic error]) {
    if (_enabled && _level <= _error) {
      print('🔴 E/$tag: $message');
      if (error != null) {
        print('Error details: $error');
      }
    }
  }
} 