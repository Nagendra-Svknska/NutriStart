import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {

  static const String tokenKey =
      'auth_token';

  static const String roleKey =
      'user_role';

  static Future<void> saveToken(
    String token,
  ) async {

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      tokenKey,
      token,
    );
  }

  static Future<String?> getToken()
  async {

    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString(
      tokenKey,
    );
  }

  static Future<void> saveUserRole(
    String role,
  ) async {

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      roleKey,
      role,
    );
  }

  static Future<String?> getUserRole()
  async {

    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString(
      roleKey,
    );
  }

  static Future<void> clearToken()
  async {

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(
      tokenKey,
    );

    await prefs.remove(
      roleKey,
    );
  }
}
