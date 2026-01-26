// lib/data/course/models/response/quiz_nested_response.dart

class QuizNestedResponse {
  final String id;
  final String quizName;
  final String courseId;
  final int timeLimit;
  final int? questionCount; // Dibuat nullable untuk keamanan
  final DateTime createdAt;
  final DateTime updatedAt;

  QuizNestedResponse({
    required this.id,
    required this.quizName,
    required this.courseId,
    required this.timeLimit,
    this.questionCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory QuizNestedResponse.fromJson(Map<String, dynamic> json) {
    return QuizNestedResponse(
      id: json['id'] ?? '',
      quizName: json['quiz_name'] ?? 'Kuis Tanpa Nama',
      courseId: json['course_id'] ?? '',
      timeLimit: json['time_limit'] ?? 0,
      // Asumsi API mungkin tidak selalu mengirim question_count
      questionCount: json['question_count'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }
}
