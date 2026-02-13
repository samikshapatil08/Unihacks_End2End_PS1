class CommentModel {
  final String id;
  final String userName;
  final String userRole;
  final String content;
  final String timeAgo;

  CommentModel({
    required this.id,
    required this.userName,
    required this.userRole,
    required this.content,
    required this.timeAgo,
  });
}