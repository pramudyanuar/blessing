import 'package:equatable/equatable.dart';

class UserReportCardResponse extends Equatable {
  final String userId;
  final String userName;
  final List<QuizReportCardItem> quizzes;
  final ReportCardSummary summary;

  const UserReportCardResponse({
    required this.userId,
    required this.userName,
    required this.quizzes,
    required this.summary,
  });

  factory UserReportCardResponse.fromJson(Map<String, dynamic> json) {
    return UserReportCardResponse(
      userId: json['user_id'] ?? '',
      userName: json['user_name'] ?? '',
      quizzes: (json['quizzes'] as List<dynamic>? ?? [])
          .map((e) => QuizReportCardItem.fromJson(e))
          .toList(),
      summary: ReportCardSummary.fromJson(json['summary'] ?? {}),
    );
  }

  @override
  List<Object?> get props => [userId, userName, quizzes, summary];
}

class QuizReportCardItem extends Equatable {
  final String quizId;
  final String quizName;
  final int timeLimit;
  final String courseName;
  final String subjectName;
  final bool isAttempted;
  final String status;

  const QuizReportCardItem({
    required this.quizId,
    required this.quizName,
    required this.timeLimit,
    required this.courseName,
    required this.subjectName,
    required this.isAttempted,
    required this.status,
  });

  factory QuizReportCardItem.fromJson(Map<String, dynamic> json) {
    return QuizReportCardItem(
      quizId: json['quiz_id'] ?? '',
      quizName: json['quiz_name'] ?? '',
      timeLimit: json['time_limit'] ?? 0,
      courseName: json['course_name'] ?? '',
      subjectName: json['subject_name'] ?? '',
      isAttempted: json['is_attempted'] ?? false,
      status: json['status'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
        quizId,
        quizName,
        timeLimit,
        courseName,
        subjectName,
        isAttempted,
        status
      ];
}

class ReportCardSummary extends Equatable {
  final int totalQuizzes;
  final int attemptedQuizzes;
  final int completedQuizzes;
  final num averageScore;
  final num completionRate;

  const ReportCardSummary({
    required this.totalQuizzes,
    required this.attemptedQuizzes,
    required this.completedQuizzes,
    required this.averageScore,
    required this.completionRate,
  });

  factory ReportCardSummary.fromJson(Map<String, dynamic> json) {
    return ReportCardSummary(
      totalQuizzes: json['total_quizzes'] ?? 0,
      attemptedQuizzes: json['attempted_quizzes'] ?? 0,
      completedQuizzes: json['completed_quizzes'] ?? 0,
      averageScore: json['average_score'] ?? 0,
      completionRate: json['completion_rate'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        totalQuizzes,
        attemptedQuizzes,
        completedQuizzes,
        averageScore,
        completionRate
      ];
}