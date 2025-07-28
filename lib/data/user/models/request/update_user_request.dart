// lib/data/user/models/request/update_user_request.dart

class UpdateUserRequest {
  final String? username;
  final String? email;
  final String? password;
  final String? phoneNumber;
  final String? gradeLevel;
  final DateTime? birthDate;
  final String? avatarUrl;

  UpdateUserRequest({
    this.username,
    this.email,
    this.password,
    this.phoneNumber,
    this.gradeLevel,
    this.birthDate,
    this.avatarUrl,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (username != null) data['username'] = username;
    if (email != null) data['email'] = email;
    if (password != null) data['password'] = password;
    if (phoneNumber != null) data['phone_number'] = phoneNumber;
    if (gradeLevel != null) data['grade_level'] = gradeLevel;
    if (birthDate != null) data['birth_date'] = birthDate!.toIso8601String();
    if (avatarUrl != null) data['avatar_url'] = avatarUrl;
    return data;
  }
}
