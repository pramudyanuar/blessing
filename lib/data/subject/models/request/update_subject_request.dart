// lib/data/subject/models/request/update_subject_request.dart

class UpdateSubjectRequest {
  final String? subjectName;

  UpdateSubjectRequest({
    this.subjectName,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (subjectName != null) data['subject_name'] = subjectName;
    return data;
  }
}
