import 'package:shared_preferences/shared_preferences.dart';

abstract final class SessionStore {
  static const String _keyMode = 'session_mode';
  static const String _keyExpression = 'session_expression';

  static Future<void> saveSession({
    required int modeIndex,
    required String expression,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyMode, modeIndex);
    await prefs.setString(_keyExpression, expression);
  }

  static Future<({int modeIndex, String expression})> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    return (
      modeIndex: prefs.getInt(_keyMode) ?? 0,
      expression: prefs.getString(_keyExpression) ?? '',
    );
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyMode);
    await prefs.remove(_keyExpression);
  }
}
