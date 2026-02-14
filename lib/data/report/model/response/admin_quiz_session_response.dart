class AdminQuizSessionUserData {
  final String userId;
  final String username;
  final String email;
  final bool isAttempted;
  final String? sessionId;
  final int? score;
  final bool? submitted;
  final bool? autoSubmitted;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final String status;

  AdminQuizSessionUserData({
    required this.userId,
    required this.username,
    required this.email,
    required this.isAttempted,
    this.sessionId,
    this.score,
    this.submitted,
    this.autoSubmitted,
    this.startedAt,
    this.endedAt,
    required this.status,
  });

  factory AdminQuizSessionUserData.fromJson(Map<String, dynamic> json) {
    return AdminQuizSessionUserData(
      userId: json['user_id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      isAttempted: json['is_attempted'] as bool,
      sessionId: json['session_id'] as String?,
      score: json['score'] as int?,
      submitted: json['submitted'] as bool?,
      autoSubmitted: json['auto_submitted'] as bool?,
      startedAt: json['started_at'] != null
          ? DateTime.parse(json['started_at'] as String)
          : null,
      endedAt: json['ended_at'] != null
          ? DateTime.parse(json['ended_at'] as String)
          : null,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'username': username,
      'email': email,
      'is_attempted': isAttempted,
      'session_id': sessionId,
      'score': score,
      'submitted': submitted,
      'auto_submitted': autoSubmitted,
      'started_at': startedAt?.toIso8601String(),
      'ended_at': endedAt?.toIso8601String(),
      'status': status,
    };
  }
}

class QuizStatistics {
  final int totalStudentsWithAccess;
  final int studentsAttempted;
  final int studentsCompleted;
  final int highestScore;
  final double averageScore;
  final double completionRate;

  QuizStatistics({
    required this.totalStudentsWithAccess,
    required this.studentsAttempted,
    required this.studentsCompleted,
    required this.highestScore,
    required this.averageScore,
    required this.completionRate,
  });

  factory QuizStatistics.fromJson(Map<String, dynamic> json) {
    return QuizStatistics(
      totalStudentsWithAccess: json['total_students_with_access'] as int,
      studentsAttempted: json['students_attempted'] as int,
      studentsCompleted: json['students_completed'] as int,
      highestScore: json['highest_score'] as int,
      averageScore: (json['average_score'] as num).toDouble(),
      completionRate: (json['completion_rate'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_students_with_access': totalStudentsWithAccess,
      'students_attempted': studentsAttempted,
      'students_completed': studentsCompleted,
      'highest_score': highestScore,
      'average_score': averageScore,
      'completion_rate': completionRate,
    };
  }
}

class AdminQuizSessionResponse {
  final String? quizId;
  final String? quizName;
  final List<AdminQuizSessionUserData> users;
  final QuizStatistics statistics;

  AdminQuizSessionResponse({
    this.quizId,
    this.quizName,
    required this.users,
    required this.statistics,
  });

  factory AdminQuizSessionResponse.fromJson(Map<String, dynamic> json) {
    return AdminQuizSessionResponse(
      quizId: json['quiz_id'] as String?,
      quizName: json['quiz_name'] as String?,
      users: (json['users'] as List<dynamic>)
          .map((e) => AdminQuizSessionUserData.fromJson(
              e as Map<String, dynamic>))
          .toList(),
      statistics: QuizStatistics.fromJson(
          json['statistics'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quiz_id': quizId,
      'quiz_name': quizName,
      'users': users.map((e) => e.toJson()).toList(),
      'statistics': statistics.toJson(),
    };
  }
}