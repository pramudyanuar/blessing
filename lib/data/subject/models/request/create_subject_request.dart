// lib/data/subject/models/request/create_subject_request.dart

class CreateSubjectRequest {
  final String subjectName;
  final int gradeLevel;

  CreateSubjectRequest({
    required this.subjectName,
    this.gradeLevel = 0,
  });

  Map<String, dynamic> toJson() => {
        "subject_name": subjectName,
        "grade_level": gradeLevel,
      };
}
