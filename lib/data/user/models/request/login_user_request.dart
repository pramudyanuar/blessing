// lib/data/user/models/request/login_user_request.dart

class LoginUserRequest {
  final String email;
  final String password;

  LoginUserRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };
}
