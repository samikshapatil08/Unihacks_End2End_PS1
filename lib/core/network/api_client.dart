import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../services/auth_service.dart';

/// Central HTTP client that adds base URL and JWT to requests.
class ApiClient {
  static String get _base => ApiConfig.baseUrl;

  static Future<String?> _accessToken() => AuthService.getAccessToken();

  static Future<Map<String, String>> _headers({bool auth = true}) async {
    final map = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (auth) {
      final token = await _accessToken();
      if (token != null && token.isNotEmpty) {
        map['Authorization'] = 'Bearer $token';
      }
    }
    return map;
  }

  static Future<http.Response> get(
    String path, {
    Map<String, String>? queryParams,
    bool useAuth = true,
  }) async {
    var uri = Uri.parse('$_base$path');
    if (queryParams != null && queryParams.isNotEmpty) {
      uri = uri.replace(queryParameters: queryParams);
    }
    return http.get(uri, headers: await _headers(auth: useAuth));
  }

  static Future<http.Response> post(
    String path, {
    Map<String, dynamic>? body,
    bool useAuth = true,
  }) async {
    final uri = Uri.parse('$_base$path');
    return http.post(
      uri,
      headers: await _headers(auth: useAuth),
      body: body != null ? jsonEncode(body) : null,
    );
  }

  static Future<http.Response> patch(
    String path, {
    Map<String, dynamic>? body,
    bool useAuth = true,
  }) async {
    final uri = Uri.parse('$_base$path');
    return http.patch(
      uri,
      headers: await _headers(auth: useAuth),
      body: body != null ? jsonEncode(body) : null,
    );
  }

  static Future<http.Response> delete(String path, {bool useAuth = true}) async {
    final uri = Uri.parse('$_base$path');
    return http.delete(uri, headers: await _headers(auth: useAuth));
  }

  /// For multipart (e.g. audio upload). Caller adds Authorization if needed.
  static String get baseUrl => _base;
}
