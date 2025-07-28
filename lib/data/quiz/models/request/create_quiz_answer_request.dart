// lib/data/quiz/models/request/create_quiz_answer_request.dart

class CreateQuizAnswerRequest {
  final String optionId;
  final String questionId;

  CreateQuizAnswerRequest({
    required this.optionId,
    required this.questionId,
  });

  Map<String, dynamic> toJson() => {
        "option_id": optionId,
        "question_id": questionId,
      };
}
