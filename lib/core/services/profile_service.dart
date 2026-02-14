import 'dart:convert';

import '../../data/models/profile_model.dart';
import '../network/api_client.dart';

class ProfileService {
  /// GET /api/profile/
  static Future<ProfileModel?> getProfile() async {
    final res = await ApiClient.get('/api/profile/');
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final data = jsonDecode(res.body) as Map<String, dynamic>?;
      if (data != null) return ProfileModel.fromJson(data);
    }
    return null;
  }

  /// PATCH /api/profile/update/
  static Future<ProfileModel?> updateProfile(ProfileModel profile) async {
    final res = await ApiClient.patch(
      '/api/profile/update/',
      body: profile.toJson(),
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final data = jsonDecode(res.body) as Map<String, dynamic>?;
      if (data != null) return ProfileModel.fromJson(data);
    }
    return null;
  }
}
