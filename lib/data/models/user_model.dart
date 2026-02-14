class UserModel {
  final String id;
  final String email;
  final String? username;
  final String? firstName;
  final String? lastName;
  final int? organization;
  final String? organizationName;
  final String? role;
  final String? createdAt;

  UserModel({
    required this.id,
    required this.email,
    this.username,
    this.firstName,
    this.lastName,
    this.organization,
    this.organizationName,
    this.role,
    this.createdAt,
  });

  String get displayName {
    final name = (firstName != null && lastName != null)
        ? '$firstName $lastName'.trim()
        : (firstName ?? lastName ?? '');
    if (name.isNotEmpty) return name;
    if (username != null && username!.isNotEmpty) return username!;
    return email.isNotEmpty ? email : 'User';
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final id = json['id']?.toString() ?? json['pk']?.toString() ?? '';
    return UserModel(
      id: id,
      email: json['email'] as String? ?? '',
      username: json['username'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      organization: json['organization'] is int
          ? json['organization'] as int
          : (json['organization'] is num ? (json['organization'] as num).toInt() : null),
      organizationName: json['organization_name'] as String?,
      role: json['role'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }
}
