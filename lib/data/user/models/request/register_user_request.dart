// lib/data/user/models/request/register_user_request.dart

class RegisterUserRequest {
  final String email;
  final String password;
  final String username;
  final String gradeLevel;

  RegisterUserRequest({
    required this.email,
    required this.password,
    required this.username,
    required this.gradeLevel,
  });

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "username": username,
        "grade_level": gradeLevel,
      };
}
