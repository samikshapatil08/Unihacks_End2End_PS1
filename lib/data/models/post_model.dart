class PostModel {
  final String id;
  final String authorName;
  final String authorRole;
  final String title;
  final String content;
  final String timeAgo;
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
}