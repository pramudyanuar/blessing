// lib/data/course/models/response/course_with_quizzes_response.dart

import 'package:blessing/data/course/models/response/quiz_nested_response.dart';
import 'package:blessing/data/subject/models/response/subject_response.dart'; // Sesuaikan path jika perlu

class CourseWithQuizzesResponse {
  final String id;
  final String courseName;
  final int gradeLevel;
  final SubjectResponse subject;
  final List<QuizNestedResponse> quizzes; // Ini perbedaannya!
  final List<Map<String, dynamic>> content;
  final DateTime createdAt;
  final DateTime updatedAt;

  CourseWithQuizzesResponse({
    required this.id,
    required this.courseName,
    required this.gradeLevel,
    required this.subject,
    required this.content,
    required this.quizzes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CourseWithQuizzesResponse.fromJson(Map<String, dynamic> json) {
    // Parsing list of quizzes
    final quizzesList = (json['quizzes'] as List? ?? [])
        .map((quizJson) => QuizNestedResponse.fromJson(quizJson))
        .toList();

    return CourseWithQuizzesResponse(
      id: json['id'] ?? '',
      courseName: json['course_name'] ?? 'Course Tanpa Nama',
      gradeLevel: json['grade_level'] ?? 0,
      subject: SubjectResponse.fromJson(json['subject'] ?? {}),
      quizzes: quizzesList,
      content: List<Map<String, dynamic>>.from(json['content'] ?? []),
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }
}
