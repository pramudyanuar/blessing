// lib/data/quiz/models/request/create_question_request.dart

import '../../../core/models/content_block.dart';

class CreateQuestionRequest {
  final List<ContentBlock> content;
  final String quizId;

  CreateQuestionRequest({
    required this.content,
    required this.quizId,
  });

  Map<String, dynamic> toJson() => {
        "content": List<dynamic>.from(content.map((x) => x.toJson())),
        "quiz_id": quizId,
      };
}
