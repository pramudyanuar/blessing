// lib/data/quiz/models/response/question_response.dart

import '../../../core/models/content_block.dart';
import 'quiz_response.dart';

class QuestionResponse {
  final String id;
  final List<ContentBlock> content;
  final String quizId;
  final QuizResponse? quiz;

  QuestionResponse({
    required this.id,
    required this.content,
    required this.quizId,
    this.quiz,
  });

  factory QuestionResponse.fromJson(Map<String, dynamic> json) =>
      QuestionResponse(
        id: json["id"],
        content: List<ContentBlock>.from(
            json["content"].map((x) => ContentBlock.fromJson(x))),
        quizId: json["quiz_id"],
        quiz: json["quiz"] == null ? null : QuizResponse.fromJson(json["quiz"]),
      );
}
