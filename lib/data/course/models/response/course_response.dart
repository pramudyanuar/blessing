// lib/data/course/models/response/course_response.dart

import '../../../core/models/content_block.dart';
import '../../../subject/models/response/subject_response.dart';

class CourseResponse {
  final String id;
  final String? courseName;
  final List<ContentBlock>? content;
  final int? gradeLevel;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final SubjectResponse? subject;

  CourseResponse({
    required this.id,
    this.courseName,
    this.content,
    this.gradeLevel,
    this.createdAt,
    this.updatedAt,
    this.subject,
  });

  factory CourseResponse.fromJson(Map<String, dynamic> json) => CourseResponse(
        id: json["id"],
        courseName: json["course_name"],
        content: json["content"] == null
            ? []
            : List<ContentBlock>.from(
                json["content"]!.map((x) => ContentBlock.fromJson(x))),
        gradeLevel: json["grade_level"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        subject: json["subject"] == null
            ? null
            : SubjectResponse.fromJson(json["subject"]),
      );
}
