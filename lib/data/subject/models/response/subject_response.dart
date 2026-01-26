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

  // -> TAMBAHKAN METHOD INI
  // Method untuk mengubah objek menjadi Map<String, dynamic> (untuk proses encoding ke JSON)
  Map<String, dynamic> toJson() => {
        "id": id,
        "subject_name": subjectName,
        // Konversi DateTime menjadi string format ISO 8601 agar kompatibel dengan JSON
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
