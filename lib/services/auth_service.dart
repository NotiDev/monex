import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';

class AuthService {
  static const String _usersKey = 'users';
  static const String _currentUserKey = 'current_user';

  /// Хэширует пароль с использованием SHA-256
  static String _hashPassword(String password) {
    return sha256.convert(password.codeUnits).toString();
  }

  /// Регистрирует нового пользователя
  /// Возвращает true если регистрация успешна
  /// Возвращает false если пользователь уже существует
  static Future<bool> register({
    required String username,
    required String password,
  }) async {
    if (username.isEmpty || password.isEmpty) {
      return false;
    }

    final prefs = await SharedPreferences.getInstance();

    // Получаем список существующих пользователей
    final usersJson = prefs.getString(_usersKey) ?? '{}';
    final users = _parseUsers(usersJson);

    // Проверяем, существует ли уже такой пользователь
    if (users.containsKey(username)) {
      return false;
    }

    // Добавляем нового пользователя
    users[username] = _hashPassword(password);
    await prefs.setString(_usersKey, _encodeUsers(users));

    return true;
  }

  /// Аутентифицирует пользователя
  /// Возвращает true если пароль верный
  /// Возвращает false если пользователь не существует или пароль неверный
  static Future<bool> login({
    required String username,
    required String password,
  }) async {
    if (username.isEmpty || password.isEmpty) {
      return false;
    }

    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey) ?? '{}';
    final users = _parseUsers(usersJson);

    if (!users.containsKey(username)) {
      return false;
    }

    // Сравниваем хэши
    final storedHash = users[username];
    final inputHash = _hashPassword(password);

    if (storedHash == inputHash) {
      // Сохраняем текущего пользователя
      await prefs.setString(_currentUserKey, username);
      return true;
    }

    return false;
  }

  /// Проверяет, авторизован ли пользователь
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_currentUserKey);
  }

  /// Получает текущего авторизованного пользователя
  static Future<String?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentUserKey);
  }

  /// Выходит из системы
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }

  /// Парсит строку JSON в Map пользователей
  static Map<String, String> _parseUsers(String json) {
    final Map<String, String> users = {};
    try {
      if (json.isEmpty || json == '{}') {
        return users;
      }
      // Простой парсер для строки вида: "user1:hash1,user2:hash2"
      final parts = json.substring(1, json.length - 1).split(',');
      for (final part in parts) {
        if (part.isNotEmpty) {
          final keyValue = part.split(':');
          if (keyValue.length == 2) {
            users[keyValue[0].replaceAll('"', '').trim()] =
                keyValue[1].replaceAll('"', '').trim();
          }
        }
      }
    } catch (e) {
      // Если парсинг не сработал, возвращаем пустую карту
      return {};
    }
    return users;
  }

  /// Кодирует Map пользователей в строку JSON
  static String _encodeUsers(Map<String, String> users) {
    final entries = users.entries
        .map((e) => '"${e.key}":"${e.value}"')
        .join(',');
    return '{$entries}';
  }
}
