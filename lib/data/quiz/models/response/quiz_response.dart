// lib/data/quiz/models/response/quiz_response.dart

class QuizResponse {
  final String id;
  final String? quizName;
  final String? courseId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  QuizResponse({
    required this.id,
    this.quizName,
    this.courseId,
    this.createdAt,
    this.updatedAt,
  });

  factory QuizResponse.fromJson(Map<String, dynamic> json) => QuizResponse(
        id: json["id"],
        quizName: json["quiz_name"],
        courseId: json["course_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );
}
