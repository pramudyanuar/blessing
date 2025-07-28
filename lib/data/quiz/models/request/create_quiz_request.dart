// lib/data/quiz/models/request/create_quiz_request.dart

class CreateQuizRequest {
  final String quizName;
  final String courseId;
  final int? timeLimit;

  CreateQuizRequest({
    required this.quizName,
    required this.courseId,
    this.timeLimit,
  });

  Map<String, dynamic> toJson() => {
        "quiz_name": quizName,
        "course_id": courseId,
        "time_limit": timeLimit,
      };
}
