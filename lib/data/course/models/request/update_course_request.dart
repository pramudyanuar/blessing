// lib/data/course/models/request/update_course_request.dart

import '../../../core/models/content_block.dart';

class UpdateCourseRequest {
  final String? courseName;
  final List<ContentBlock>? content;
  final int? gradeLevel;
  final String? subjectId;

  UpdateCourseRequest({
    this.courseName,
    this.content,
    this.gradeLevel,
    this.subjectId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (courseName != null) data['course_name'] = courseName;
    if (content != null)
      data['content'] = List<dynamic>.from(content!.map((x) => x.toJson()));
    if (gradeLevel != null) data['grade_level'] = gradeLevel;
    if (subjectId != null) data['subject_id'] = subjectId;
    return data;
  }
}
