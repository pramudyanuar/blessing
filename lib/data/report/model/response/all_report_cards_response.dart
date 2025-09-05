import 'package:equatable/equatable.dart';

class AllReportCardsResponse extends Equatable {
  final List<UserQuizAttempt> users;
  final QuizStatistics statistics;

  const AllReportCardsResponse({
    required this.users,
    required this.statistics,
  });

  factory AllReportCardsResponse.fromJson(Map<String, dynamic> json) {
    return AllReportCardsResponse(
      users: (json['users'] as List<dynamic>? ?? [])
          .map((e) => UserQuizAttempt.fromJson(e))
          .toList(),
      statistics: QuizStatistics.fromJson(json['statistics'] ?? {}),
    );
  }

  @override
  List<Object?> get props => [users, statistics];
}

class UserQuizAttempt extends Equatable {
  final String userId;
  final String username;
  final String email;
  final bool isAttempted;
  final String sessionId;
  final num score;
  final String status;
  final DateTime startedAt;
  final DateTime endedAt;

  const UserQuizAttempt({
    required this.userId,
    required this.username,
    required this.email,
    required this.isAttempted,
    required this.sessionId,
    required this.score,
    required this.status,
    required this.startedAt,
    required this.endedAt,
  });

  factory UserQuizAttempt.fromJson(Map<String, dynamic> json) {
    return UserQuizAttempt(
      userId: json['user_id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      isAttempted: json['is_attempted'] ?? false,
      sessionId: json['session_id'] ?? '',
      score: json['score'] ?? 0,
      status: json['status'] ?? '',
      startedAt: DateTime.tryParse(json['started_at'] ?? '') ?? DateTime(0),
      endedAt: DateTime.tryParse(json['ended_at'] ?? '') ?? DateTime(0),
    );
  }

  @override
  List<Object?> get props =>
      [userId, username, email, isAttempted, sessionId, score, status];
}

class QuizStatistics extends Equatable {
  final int totalStudentsWithAccess;
  final int studentsAttempted;
  final int studentsCompleted;
  final num highestScore;
  final num averageScore;
  final num completionRate;

  const QuizStatistics({
    required this.totalStudentsWithAccess,
    required this.studentsAttempted,
    required this.studentsCompleted,
    required this.highestScore,
    required this.averageScore,
    required this.completionRate,
  });

  factory QuizStatistics.fromJson(Map<String, dynamic> json) {
    return QuizStatistics(
      totalStudentsWithAccess: json['total_students_with_access'] ?? 0,
      studentsAttempted: json['students_attempted'] ?? 0,
      studentsCompleted: json['students_completed'] ?? 0,
      highestScore: json['highest_score'] ?? 0,
      averageScore: json['average_score'] ?? 0,
      completionRate: json['completion_rate'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        totalStudentsWithAccess,
        studentsAttempted,
        studentsCompleted,
        highestScore,
        averageScore,
        completionRate
      ];
}