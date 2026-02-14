import 'dart:convert';

import '../network/api_client.dart';

/// One item from GET /api/posts/<pk>/ai-analysis/ — id, post, persona_name, analysis_text, created_at
class PersonaInsight {
  final String name;
  final String insight;

  PersonaInsight({required this.name, required this.insight});

  factory PersonaInsight.fromJson(Map<String, dynamic> json) {
    return PersonaInsight(
      name: json['persona_name'] as String? ?? json['name'] as String? ?? 'Perspective',
      insight: json['analysis_text'] as String? ?? json['insight'] as String? ?? '',
    );
  }
}

/// One message from GET /api/persona-chat/<post_pk>/ — id, post, persona_name, sender_type, message_text, timestamp
class PersonaChatMessageDto {
  final String id;
  final String personaName;
  final String senderType;
  final String messageText;
  final String timestamp;

  PersonaChatMessageDto({
    required this.id,
    required this.personaName,
    required this.senderType,
    required this.messageText,
    required this.timestamp,
  });

  factory PersonaChatMessageDto.fromJson(Map<String, dynamic> json) {
    return PersonaChatMessageDto(
      id: json['id']?.toString() ?? '',
      personaName: json['persona_name'] as String? ?? '',
      senderType: json['sender_type'] as String? ?? 'user',
      messageText: json['message_text'] as String? ?? '',
      timestamp: json['timestamp'] as String? ?? '',
    );
  }
}

class AiService {
  /// POST /api/posts/<post_pk>/ai-analysis/ — post (int), persona_name (required), analysis_text (required)
  static Future<PersonaInsight?> createAnalysis(String postId, String personaName, {String analysisText = ''}) async {
    final postIdInt = int.tryParse(postId);
    if (postIdInt == null) return null;
    final res = await ApiClient.post(
      '/api/posts/$postId/ai-analysis/',
      body: {
        'post': postIdInt,
        'persona_name': personaName,
        'analysis_text': analysisText,
      },
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final data = jsonDecode(res.body) as Map<String, dynamic>?;
      if (data != null) return PersonaInsight.fromJson(data);
    }
    return null;
  }

  /// GET /api/posts/<post_pk>/ai-analysis/ — returns List<AIPersonaAnalysisObject>
  static Future<List<PersonaInsight>> listAnalysis(String postId) async {
    final res = await ApiClient.get('/api/posts/$postId/ai-analysis/');
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final data = jsonDecode(res.body);
      if (data is List) {
        return data
            .map((e) => PersonaInsight.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      }
      if (data is Map && data['results'] != null) {
        final list = data['results'] as List;
        return list
            .map((e) => PersonaInsight.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      }
    }
    return [];
  }

  /// POST /api/persona-chat/ — post (int, required), persona_name (required), sender_type ('user'|'ai'), message_text (required)
  static Future<PersonaChatMessageDto?> sendPersonaMessage({
    required String postId,
    required String personaName,
    required String messageText,
    String senderType = 'user',
  }) async {
    final postIdInt = int.tryParse(postId);
    if (postIdInt == null) return null;
    final res = await ApiClient.post(
      '/api/persona-chat/',
      body: {
        'post': postIdInt,
        'persona_name': personaName,
        'sender_type': senderType,
        'message_text': messageText,
      },
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final data = jsonDecode(res.body) as Map<String, dynamic>?;
      if (data != null) return PersonaChatMessageDto.fromJson(data);
    }
    return null;
  }

  /// GET /api/persona-chat/<post_pk>/ — list messages for post
  static Future<List<PersonaChatMessageDto>> listPersonaChat(String postId, {String? personaName}) async {
    final res = await ApiClient.get('/api/persona-chat/$postId/');
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final data = jsonDecode(res.body);
      List<dynamic> list = [];
      if (data is List) list = data;
      if (data is Map && data['results'] != null) list = data['results'] as List;
      final messages = list
          .map((e) => PersonaChatMessageDto.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
      if (personaName != null && personaName.isNotEmpty) {
        return messages.where((m) => m.personaName == personaName).toList();
      }
      return messages;
    }
    return [];
  }
}
