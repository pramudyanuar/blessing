// lib/data/user/models/response/user_response.dart

class UserResponse {
  final String id;
  final String? username;
  final String? email;
  final int? gradeLevel;
  final String? role;
  final DateTime? birthDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserResponse({
    required this.id,
    this.username,
    this.email,
    this.gradeLevel,
    this.role,
    this.birthDate,
    this.createdAt,
    this.updatedAt,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        gradeLevel: json["grade_level"],
        role: json["role"],
        birthDate: json["birth_date"] == null
            ? null
            : DateTime.parse(json["birth_date"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );
}
