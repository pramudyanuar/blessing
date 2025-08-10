class UpdateUserRequest {
  final String? username;
  final String? email;
  final String? password;
  final String? phoneNumber;
  final String? gradeLevel;
  final String? birthDate; // Ubah jadi String
  final String? avatarUrl;

  UpdateUserRequest({
    this.username,
    this.email,
    this.password,
    this.phoneNumber,
    this.gradeLevel,
    this.birthDate, // kirim string format tanggal di sini
    this.avatarUrl,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (username != null) data['username'] = username;
    if (email != null) data['email'] = email;
    if (password != null) data['password'] = password;
    if (phoneNumber != null) data['phone_number'] = phoneNumber;
    if (gradeLevel != null) data['grade_level'] = gradeLevel;
    if (birthDate != null) data['birth_date'] = birthDate; // string langsung
    if (avatarUrl != null) data['avatar_url'] = avatarUrl;
    return data;
  }
}
