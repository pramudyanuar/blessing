// lib/data/subject/models/request/create_subject_request.dart

class CreateSubjectRequest {
  final String subjectName;

  CreateSubjectRequest({
    required this.subjectName,
  });

  Map<String, dynamic> toJson() => {
        "subject_name": subjectName,
      };
}
