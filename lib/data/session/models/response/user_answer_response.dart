// lib/data/session/models/response/user_answer_response.dart

import '../../../quiz/models/response/question_option_response.dart';
import '../../../quiz/models/response/question_response.dart';
import 'user_quiz_session_response.dart';

class UserAnswerResponse {
  final String id;
  final UserQuizSessionResponse session;
  final QuestionResponse question;
  final QuestionOptionResponse questionOption;

  UserAnswerResponse({
    required this.id,
    required this.session,
    required this.question,
    required this.questionOption,
  });

  factory UserAnswerResponse.fromJson(Map<String, dynamic> json) =>
      UserAnswerResponse(
        id: json["id"],
        session: UserQuizSessionResponse.fromJson(json["session"]),
        question: QuestionResponse.fromJson(json["question"]),
        questionOption:
            QuestionOptionResponse.fromJson(json["question_option"]),
      );
}
