import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  static const String _usersKey = 'auth_users_v1';

  static Future<List<Map<String, dynamic>>> _loadRawUsers() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? raw = preferences.getString(_usersKey);

    if (raw == null || raw.isEmpty) {
      return <Map<String, dynamic>>[];
    }

    try {
      final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
      return decoded.whereType<Map<String, dynamic>>().toList();
    } catch (_) {
      return <Map<String, dynamic>>[];
    }
  }

  static Future<void> _saveRawUsers(List<Map<String, dynamic>> users) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final String raw = jsonEncode(users);
    await preferences.setString(_usersKey, raw);
  }

  static Future<bool> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    final List<Map<String, dynamic>> users = await _loadRawUsers();
    final String normalizedEmail = email.trim().toLowerCase();

    final bool alreadyExists = users.any(
      (Map<String, dynamic> user) =>
          (user['email'] as String?)?.toLowerCase() == normalizedEmail,
    );

    if (alreadyExists) {
      return false;
    }

    users.add(<String, dynamic>{
      'name': name.trim(),
      'email': normalizedEmail,
      'password': password,
      'createdAt': DateTime.now().toIso8601String(),
    });

    await _saveRawUsers(users);
    return true;
  }

  static Future<bool> validateLogin({
    required String email,
    required String password,
  }) async {
    final List<Map<String, dynamic>> users = await _loadRawUsers();
    final String normalizedEmail = email.trim().toLowerCase();

    return users.any((Map<String, dynamic> user) {
      final String storedEmail =
          (user['email'] as String?)?.toLowerCase() ?? '';
      final String storedPassword = user['password'] as String? ?? '';
      return storedEmail == normalizedEmail && storedPassword == password;
    });
  }
}
