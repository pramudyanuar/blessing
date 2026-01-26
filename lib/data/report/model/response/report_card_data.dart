import 'package:blessing/data/report/model/response/quiz_report.dart';
import 'package:blessing/data/report/model/response/report_summary.dart';

class ReportCardData {
  final String userId;
  final String userName;
  final List<QuizReport> quizzes;
  final ReportSummary summary;

  ReportCardData({
    required this.userId,
    required this.userName,
    required this.quizzes,
    required this.summary,
  });

  factory ReportCardData.fromJson(Map<String, dynamic> json) {
    return ReportCardData(
      userId: json['user_id'] ?? '',
      userName: json['user_name'] ?? '',
      quizzes: (json['quizzes'] as List<dynamic>?)
              ?.map((quiz) => QuizReport.fromJson(quiz))
              .toList() ??
          [],
      summary: ReportSummary.fromJson(json['summary'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_name': userName,
      'quizzes': quizzes.map((quiz) => quiz.toJson()).toList(),
      'summary': summary.toJson(),
    };
  }
}
