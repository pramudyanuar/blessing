class QuizDetailResponse {
  final String id;
  final String? quizName;
  final String? courseId;
  final int? timeLimit;
  final int? numberOfQuestions;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  QuizDetailResponse({
    required this.id,
    this.quizName,
    this.courseId,
    this.timeLimit,
    this.numberOfQuestions,
    this.createdAt,
    this.updatedAt,
  });

  factory QuizDetailResponse.fromJson(Map<String, dynamic> json) => QuizDetailResponse(
        id: json["id"],
        quizName: json["quiz_name"],
        courseId: json["course_id"],
        timeLimit: json["time_limit"],
        numberOfQuestions: json["number_of_questions"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "quiz_name": quizName,
      "course_id": courseId,
      "time_limit": timeLimit,
      "number_of_questions": numberOfQuestions,
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
    };
  }
}