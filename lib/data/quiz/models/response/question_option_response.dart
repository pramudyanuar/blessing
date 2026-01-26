// lib/data/quiz/models/response/question_option_response.dart

import 'question_response.dart';

class QuestionOptionResponse {
  final String id;
  final String option;
  final QuestionResponse? question;

  QuestionOptionResponse({
    required this.id,
    required this.option,
    this.question,
  });

  factory QuestionOptionResponse.fromJson(Map<String, dynamic> json) =>
      QuestionOptionResponse(
        id: json["id"],
        option: json["option"],
        question: json["question"] == null
            ? null
            : QuestionResponse.fromJson(json["question"]),
      );
}
