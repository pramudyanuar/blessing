// lib/data/course/models/request/create_course_request.dart

import '../../../core/models/content_block.dart';

class CreateCourseRequest {
  final String courseName;
  final List<ContentBlock> content;
  final int gradeLevel;
  final String subjectId;

  CreateCourseRequest({
    required this.courseName,
    required this.content,
    required this.gradeLevel,
    required this.subjectId,
  });

  Map<String, dynamic> toJson() => {
        "course_name": courseName,
        "content": List<dynamic>.from(content.map((x) => x.toJson())),
        "grade_level": gradeLevel,
        "subject_id": subjectId,
      };
}
