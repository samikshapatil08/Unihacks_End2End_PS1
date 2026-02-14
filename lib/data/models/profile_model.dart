class ProfileModel {
  final String? id;
  final String? displayName;
  final String? role;
  final String? email;
  final String? bio;
  final int? reflectionsCount;
  final int? commentsCount;
  final int? savedCount;

  ProfileModel({
    this.id,
    this.displayName,
    this.role,
    this.email,
    this.bio,
    this.reflectionsCount,
    this.commentsCount,
    this.savedCount,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;
    final email = user?['email'] as String? ?? json['email'] as String?;
    final name = json['display_name'] as String? ??
        (user != null ? '${user['first_name'] ?? ''} ${user['last_name'] ?? ''}'.trim() : null) ??
        user?['username'] as String?;
    return ProfileModel(
      id: json['id']?.toString(),
      displayName: name,
      role: json['role'] as String?,
      email: email,
      bio: json['bio'] as String?,
      reflectionsCount: _toInt(json['reflections_count']),
      commentsCount: _toInt(json['comments_count']),
      savedCount: _toInt(json['saved_count']),
    );
  }

  Map<String, dynamic> toJson() => {
        if (displayName != null) 'display_name': displayName,
        if (role != null) 'role': role,
        if (bio != null) 'bio': bio,
      };

  static int? _toInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return null;
  }
}
