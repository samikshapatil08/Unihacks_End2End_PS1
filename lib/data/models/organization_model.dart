class OrganizationModel {
  final String id;
  final String name;
  final String? createdAt;

  OrganizationModel({
    required this.id,
    required this.name,
    this.createdAt,
  });

  factory OrganizationModel.fromJson(Map<String, dynamic> json) {
    return OrganizationModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      createdAt: json['created_at'] as String?,
    );
  }
}
