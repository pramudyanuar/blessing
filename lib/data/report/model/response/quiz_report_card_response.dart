import 'package:blessing/data/report/model/response/quiz_report_data.dart';
import 'package:blessing/data/report/model/response/paging.dart';

class QuizReportCardResponse {
  final QuizReportData data;
  final Paging paging;

  QuizReportCardResponse({
    required this.data,
    required this.paging,
  });

  factory QuizReportCardResponse.fromJson(Map<String, dynamic> json) {
    return QuizReportCardResponse(
      data: QuizReportData.fromJson(json['data'] ?? {}),
      paging: Paging.fromJson(json['paging'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.toJson(),
      'paging': paging.toJson(),
    };
  }
}
