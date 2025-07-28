// lib/data/quiz/models/request/create_question_option_request.dart

class CreateQuestionOptionRequest {
  final String option;

  CreateQuestionOptionRequest({
    required this.option,
  });

  Map<String, dynamic> toJson() => {
        "option": option,
      };
}
