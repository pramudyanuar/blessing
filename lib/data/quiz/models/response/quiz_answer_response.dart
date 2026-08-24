// lib/data/quiz/models/response/quiz_answer_response.dart

import 'package:blessing/data/core/models/content_block.dart';

import 'question_option_response.dart';
import 'question_response.dart';

class QuizAnswerResponse {
  final String id;
  final String optionId;
  final QuestionOptionResponse? option;
  final String questionId;
  final QuestionResponse? question;
  final List<ContentBlock> explanation;

  QuizAnswerResponse({
    required this.id,
    required this.optionId,
    this.option,
    required this.questionId,
    this.question,
    this.explanation = const [],
  });

  factory QuizAnswerResponse.fromJson(Map<String, dynamic> json) =>
      QuizAnswerResponse(
        id: json["id"],
        optionId: json["option_id"],
        option: json["option"] == null
            ? null
            : QuestionOptionResponse.fromJson(json["option"]),
        questionId: json["question_id"],
        question: json["question"] == null
            ? null
            : QuestionResponse.fromJson(json["question"]),
        explanation: json["explanation"] == null
            ? const []
            : (json["explanation"] as List)
                .map((e) => ContentBlock.fromJson(e))
                .toList(),
      );
}
