// lib/data/subject/models/response/subject_response.dart

class SubjectResponse {
  final String id;
  final String? subjectName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SubjectResponse({
    required this.id,
    this.subjectName,
    this.createdAt,
    this.updatedAt,
  });

  factory SubjectResponse.fromJson(Map<String, dynamic> json) =>
      SubjectResponse(
        id: json["id"],
        subjectName: json["subject_name"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );
}
