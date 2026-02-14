import 'dart:convert';

import '../../data/models/organization_model.dart';
import '../network/api_client.dart';

class OrganizationService {
  /// POST /api/organizations/create/ — request: name (required). Response: id, name, created_at
  static Future<OrganizationModel?> createOrganization({required String name}) async {
    final res = await ApiClient.post('/api/organizations/create/', body: {'name': name});
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final data = jsonDecode(res.body) as Map<String, dynamic>?;
      if (data != null) return OrganizationModel.fromJson(data);
    }
    return null;
  }

  /// GET /api/organizations/details/ — response: id, name, created_at
  static Future<OrganizationModel?> getMyOrganization() async {
    final res = await ApiClient.get('/api/organizations/details/');
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final data = jsonDecode(res.body) as Map<String, dynamic>?;
      if (data != null) return OrganizationModel.fromJson(data);
    }
    return null;
  }
}
