/// Tag choice for posts per API: 'reflection' | 'idea' | 'decision'
const List<String> kPostTagChoices = ['reflection', 'idea', 'decision'];

class PostModel {
  final String id;
  final String authorName;
  final String authorRole;
  final String title;
  final String content;
  final String timeAgo;
  /// Single tag per API; kept as list for UI (tags.map -> chips).
  final List<String> tags;
  final int reactionCount;
  final int commentCount;

  PostModel({
    required this.id,
    required this.authorName,
    required this.authorRole,
    required this.title,
    required this.content,
    required this.timeAgo,
    required this.tags,
    required this.reactionCount,
    required this.commentCount,
  });

  String get tag => tags.isNotEmpty ? tags.first : 'reflection';

  factory PostModel.fromJson(Map<String, dynamic> json) {
    final author = json['author'] as Map<String, dynamic>?;
    final authorName = author?['username'] as String? ??
        '${author?['first_name'] ?? ''} ${author?['last_name'] ?? ''}'.trim() ??
        'Unknown';
    final authorRole = author?['role'] as String? ?? '';
    final tagStr = json['tag'] as String?;
    final tags = tagStr != null && tagStr.isNotEmpty ? [tagStr] : <String>[];
    final createdAt = json['created_at'] as String?;
    final timeAgo = _formatTimeAgo(createdAt);
    final commentsList = json['comments'];
    final commentCount = commentsList is List ? commentsList.length : 0;
    return PostModel(
      id: json['id']?.toString() ?? '',
      authorName: authorName,
      authorRole: authorRole,
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? json['body'] as String? ?? '',
      timeAgo: timeAgo,
      tags: tags,
      reactionCount: _toInt(json['reaction_count'] ?? json['reactions_count']) ?? 0,
      commentCount: _toInt(json['comment_count'] ?? json['comments_count']) ?? commentCount,
    );
  }

  static String _formatTimeAgo(String? iso) {
    if (iso == null || iso.isEmpty) return '';
    try {
      final dt = DateTime.parse(iso);
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      return '${diff.inDays ~/ 7}w ago';
    } catch (_) {
      return iso;
    }
  }

  static int? _toInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return null;
  }
}
