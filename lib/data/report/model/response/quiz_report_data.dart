import 'package:blessing/data/report/model/response/quiz_report_user.dart';
import 'package:blessing/data/report/model/response/quiz_report_statistics.dart';

class QuizReportData {
  final String quizId;
  final String quizName;
  final List<QuizReportUser> users;
  final QuizReportStatistics statistics;

  QuizReportData({
    required this.quizId,
    required this.quizName,
    required this.users,
    required this.statistics,
  });

  factory QuizReportData.fromJson(Map<String, dynamic> json) {
    return QuizReportData(
      quizId: json['quiz_id'] ?? '',
      quizName: json['quiz_name'] ?? '',
      users: (json['users'] as List<dynamic>? ?? [])
          .map((userJson) => QuizReportUser.fromJson(userJson))
          .toList(),
      statistics: QuizReportStatistics.fromJson(json['statistics'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quiz_id': quizId,
      'quiz_name': quizName,
      'users': users.map((user) => user.toJson()).toList(),
      'statistics': statistics.toJson(),
    };
  }
}
