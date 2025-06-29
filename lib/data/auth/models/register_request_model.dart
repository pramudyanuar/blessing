class RegisterRequestModel {
  RegisterRequestModel({
    required this.email,
    required this.password,
    required this.username,
    required this.gradeLevel,
  });

  final String email;
  final String password;
  final String username;
  final String gradeLevel;

  RegisterRequestModel copyWith({
    String? email,
    String? password,
    String? username,
    String? gradeLevel,
  }) {
    return RegisterRequestModel(
      email: email ?? this.email,
      password: password ?? this.password,
      username: username ?? this.username,
      gradeLevel: gradeLevel ?? this.gradeLevel,
    );
  }

  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) {
    return RegisterRequestModel(
      email: json["email"] ?? "",
      password: json["password"] ?? "",
      username: json["username"] ?? "",
      gradeLevel: json["grade_level"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "username": username,
        "grade_level": gradeLevel,
      };

  @override
  String toString() {
    return "$email, $password, $username, $gradeLevel, ";
  }
}
