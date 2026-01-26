class QuizReportUser {
  final String userId;
  final String username;
  final String email;
  final bool isAttempted;
  final String status;
  final int? score;
  final DateTime? attemptedAt;
  final DateTime? completedAt;

  QuizReportUser({
    required this.userId,
    required this.username,
    required this.email,
    required this.isAttempted,
    required this.status,
    this.score,
    this.attemptedAt,
    this.completedAt,
  });

  factory QuizReportUser.fromJson(Map<String, dynamic> json) {
    return QuizReportUser(
      userId: json['user_id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      isAttempted: json['is_attempted'] ?? false,
      status: json['status'] ?? '',
      score: json['score'],
      attemptedAt: json['attempted_at'] != null
          ? DateTime.parse(json['attempted_at'])
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'username': username,
      'email': email,
      'is_attempted': isAttempted,
      'status': status,
      'score': score,
      'attempted_at': attemptedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }
}
