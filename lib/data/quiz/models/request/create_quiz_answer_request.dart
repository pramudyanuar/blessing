import 'package:blessing/data/core/models/content_block.dart';

class CreateQuizAnswerRequest {
  final String optionId;
  final String? questionId;
  final List<ContentBlock>? explanation;

  CreateQuizAnswerRequest({
    required this.optionId,
    this.questionId,
    this.explanation,
  });

  Map<String, dynamic> toJson() => {
        "option_id": optionId,
        if (questionId != null) "question_id": questionId,
        if (explanation != null)
          "explanation": explanation!.map((e) => e.toJson()).toList(),
      };
}
