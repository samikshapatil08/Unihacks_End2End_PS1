import 'dart:convert';

import '../models/post_model.dart';
import '../../core/network/api_client.dart';

class PostRepository {
  /// GET /api/posts/ — query_params: search (optional), ordering (optional)
  Future<List<PostModel>> fetchPosts({String? search, String? ordering}) async {
    final queryParams = <String, String>{};
    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    if (ordering != null && ordering.isNotEmpty) queryParams['ordering'] = ordering;
    final res = queryParams.isEmpty
        ? await ApiClient.get('/api/posts/')
        : await ApiClient.get('/api/posts/', queryParams: queryParams);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final data = jsonDecode(res.body);
      if (data is List) {
        return data
            .map((e) => PostModel.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      }
      if (data is Map && data['results'] != null) {
        final list = data['results'] as List;
        return list
            .map((e) => PostModel.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      }
    }
    return [];
  }

  /// GET /api/posts/?search=query
  Future<List<PostModel>> searchPosts(String query) async {
    return fetchPosts(search: query);
  }

  /// GET /api/posts/{id}/
  Future<PostModel?> fetchPostById(String id) async {
    final res = await ApiClient.get('/api/posts/$id/');
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final data = jsonDecode(res.body) as Map<String, dynamic>?;
      if (data != null) return PostModel.fromJson(data);
    }
    return null;
  }

  /// POST /api/posts/ — title, content, tag (required; choice: reflection, idea, decision)
  Future<PostModel?> createPost({
    required String title,
    required String content,
    required String tag,
  }) async {
    if (!kPostTagChoices.contains(tag)) return null;
    final body = <String, dynamic>{
      'title': title,
      'content': content,
      'tag': tag,
    };
    final res = await ApiClient.post('/api/posts/', body: body);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final data = jsonDecode(res.body) as Map<String, dynamic>?;
      if (data != null) return PostModel.fromJson(data);
    }
    return null;
  }

  /// PATCH /api/posts/{id}/
  Future<PostModel?> updatePost(String id, {String? title, String? content, String? tag}) async {
    final body = <String, dynamic>{
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (tag != null && kPostTagChoices.contains(tag)) 'tag': tag,
    };
    final res = await ApiClient.patch('/api/posts/$id/', body: body);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final data = jsonDecode(res.body) as Map<String, dynamic>?;
      if (data != null) return PostModel.fromJson(data);
    }
    return null;
  }

  /// DELETE /api/posts/{id}/
  Future<bool> deletePost(String id) async {
    final res = await ApiClient.delete('/api/posts/$id/');
    return res.statusCode >= 200 && res.statusCode < 300;
  }

  /// GET /api/posts/<post_pk>/comments/
  Future<List<CommentDto>> getComments(String postId) async {
    final res = await ApiClient.get('/api/posts/$postId/comments/');
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final data = jsonDecode(res.body);
      if (data is List) {
        return data
            .map((e) => CommentDto.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      }
    }
    return [];
  }

  /// POST /api/posts/<post_pk>/comments/create/ — content (required), post (int, ID)
  Future<CommentDto?> createComment(String postId, String content) async {
    final postIdInt = int.tryParse(postId);
    if (postIdInt == null) return null;
    final res = await ApiClient.post(
      '/api/posts/$postId/comments/create/',
      body: {'content': content, 'post': postIdInt},
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final data = jsonDecode(res.body) as Map<String, dynamic>?;
      if (data != null) return CommentDto.fromJson(data);
    }
    return null;
  }
}

class CommentDto {
  final String id;
  final String postId;
  final String userName;
  final String content;
  final String createdAt;

  CommentDto({
    required this.id,
    required this.postId,
    required this.userName,
    required this.content,
    required this.createdAt,
  });

  factory CommentDto.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;
    final userName = user?['username'] as String? ??
        '${user?['first_name'] ?? ''} ${user?['last_name'] ?? ''}'.trim() ??
        'Unknown';
    return CommentDto(
      id: json['id']?.toString() ?? '',
      postId: json['post']?.toString() ?? '',
      userName: userName,
      content: json['content'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
    );
  }
}
