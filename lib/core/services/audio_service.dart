import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../data/models/audio_model.dart';
import '../network/api_client.dart';
import '../services/auth_service.dart';

class AudioService {
  /// GET /api/audio/ — list all audio posts. Response: List<AudioPostObject>
  static Future<List<AudioModel>> listAudio() async {
    final res = await ApiClient.get('/api/audio/');
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final data = jsonDecode(res.body);
      if (data is List) {
        return data
            .map((e) => AudioModel.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      }
      if (data is Map && data['results'] != null) {
        final list = data['results'] as List;
        return list
            .map((e) => AudioModel.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      }
    }
    return [];
  }

  /// POST /api/audio/upload/ — multipart: audio_file (required), transcript (optional)
  static Future<AudioModel?> uploadAudio({
    required List<int> fileBytes,
    String? filename,
    String? transcript,
  }) async {
    final token = await AuthService.getAccessToken();
    final uri = Uri.parse('${ApiClient.baseUrl}/api/audio/upload/');
    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';
    request.files.add(http.MultipartFile.fromBytes(
      'audio_file',
      fileBytes,
      filename: filename ?? 'audio.mp3',
    ));
    if (transcript != null && transcript.isNotEmpty) {
      request.fields['transcript'] = transcript;
    }

    final streamed = await request.send();
    final res = await http.Response.fromStream(streamed);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final data = jsonDecode(res.body) as Map<String, dynamic>?;
      if (data != null) return AudioModel.fromJson(data);
    }
    return null;
  }
}
