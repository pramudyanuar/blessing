class UserResponse {
  final String id;
  final String? username;
  final String? email;
  final int? gradeLevel;
  final String? role;
  final DateTime? birthDate;
  final String? token;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserResponse({
    required this.id,
    this.username,
    this.email,
    this.gradeLevel,
    this.role,
    this.birthDate,
    this.token,
    this.createdAt,
    this.updatedAt,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return UserResponse(
      id: data["id"],
      username: data["username"],
      email: data["email"],
      gradeLevel: data["grade_level"],
      role: data["role"],
      birthDate: data["birth_date"] == null
          ? null
          : DateTime.parse(data["birth_date"]),
      token: data["token"],
      createdAt: data["created_at"] == null
          ? null
          : DateTime.parse(data["created_at"]),
      updatedAt: data["updated_at"] == null
          ? null
          : DateTime.parse(data["updated_at"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
      "email": email,
      "grade_level": gradeLevel,
      "role": role,
      "birth_date": birthDate?.toIso8601String(),
      "token": token,
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
    };
  }
}
