import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/user_model.dart';
import '../network/api_client.dart';

class AuthService {
  static const _keyAccess = 'auth_access_token';
  static const _keyRefresh = 'auth_refresh_token';
  static const _keyUser = 'auth_user_json';

  static Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  static Future<void> saveTokens(String access, String refresh) async {
    final prefs = await _prefs;
    await prefs.setString(_keyAccess, access);
    await prefs.setString(_keyRefresh, refresh);
  }

  static Future<String?> getAccessToken() async {
    final prefs = await _prefs;
    return prefs.getString(_keyAccess);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await _prefs;
    return prefs.getString(_keyRefresh);
  }

  static Future<void> saveUser(UserModel user) async {
    final prefs = await _prefs;
    await prefs.setString(_keyUser, jsonEncode({
      'id': user.id,
      'email': user.email,
      'username': user.username,
      'first_name': user.firstName,
      'last_name': user.lastName,
      'organization': user.organization,
      'organization_name': user.organizationName,
      'role': user.role,
      'created_at': user.createdAt,
    }));
  }

  static Future<UserModel?> getSavedUser() async {
    final prefs = await _prefs;
    final s = prefs.getString(_keyUser);
    if (s == null) return null;
    try {
      return UserModel.fromJson(Map<String, dynamic>.from(jsonDecode(s) as Map));
    } catch (_) {
      return null;
    }
  }

  static Future<void> logout() async {
    final prefs = await _prefs;
    await prefs.remove(_keyAccess);
    await prefs.remove(_keyRefresh);
    await prefs.remove(_keyUser);
  }

  static Future<bool> get isLoggedIn async =>
      (await getAccessToken())?.isNotEmpty == true;

  /// POST /api/auth/token/refresh/
  static Future<String?> refreshAccessToken() async {
    final refresh = await getRefreshToken();
    if (refresh == null || refresh.isEmpty) return null;
    final res = await ApiClient.post(
      '/api/auth/token/refresh/',
      body: {'refresh': refresh},
      useAuth: false,
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final data = jsonDecode(res.body) as Map<String, dynamic>?;
      final access = data?['access'] as String?;
      if (access != null) {
        final prefs = await _prefs;
        await prefs.setString(_keyAccess, access);
        return access;
      }
    }
    return null;
  }

  /// POST /api/auth/register/
  /// Request: username (required), password (required), email (optional), first_name, last_name, organization_id (optional)
  /// Response: user object only (no tokens) — user must login after register
  static Future<AuthResult> register({
    required String username,
    required String password,
    String? email,
    String? firstName,
    String? lastName,
    int? organizationId,
  }) async {
    final body = <String, dynamic>{
      'username': username,
      'password': password,
      if (email != null) 'email': email,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (organizationId != null) 'organization_id': organizationId,
    };
    final res = await ApiClient.post('/api/auth/register/', body: body, useAuth: false);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final data = jsonDecode(res.body) as Map<String, dynamic>?;
      final access = data?['access'] as String?;
      final refresh = data?['refresh'] as String?;
      if (access != null && refresh != null) {
        await saveTokens(access, refresh);
        final user = await fetchMe();
        if (user != null) await saveUser(user);
        return AuthResult.success();
      }
      // Register response may not include tokens; try login to get them
      final loginResult = await login(username, password);
      return loginResult;
    }
    return AuthResult.failure(_errorMessage(res));
  }

  /// POST /api/auth/login/
  /// Request: username (required), password (required). Response: access, refresh.
  static Future<AuthResult> login(String username, String password) async {
    final res = await ApiClient.post(
      '/api/auth/login/',
      body: {'username': username, 'password': password},
      useAuth: false,
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final data = jsonDecode(res.body) as Map<String, dynamic>?;
      final access = data?['access'] as String?;
      final refresh = data?['refresh'] as String?;
      if (access != null && refresh != null) {
        await saveTokens(access, refresh);
        final user = await fetchMe();
        if (user != null) await saveUser(user);
        return AuthResult.success();
      }
    }
    return AuthResult.failure(_errorMessage(res));
  }

  /// GET /api/auth/me/
  /// Response: id, username, email, first_name, last_name, organization, organization_name, role, created_at
  static Future<UserModel?> fetchMe() async {
    final res = await ApiClient.get('/api/auth/me/');
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final data = jsonDecode(res.body) as Map<String, dynamic>?;
      if (data != null) return UserModel.fromJson(data);
    }
    return null;
  }

  static String _errorMessage(dynamic res) {
    try {
      final body = jsonDecode(res.body);
      if (body is Map && body['detail'] != null) return body['detail'].toString();
      if (body is Map && body['message'] != null) return body['message'].toString();
      if (body is Map && body['error'] != null) return body['error'].toString();
    } catch (_) {}
    return 'Something went wrong. Please try again.';
  }
}

class AuthResult {
  final bool isSuccess;
  final String? errorMessage;

  AuthResult.success() : isSuccess = true, errorMessage = null;
  AuthResult.failure(this.errorMessage) : isSuccess = false;
}
