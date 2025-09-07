class QuizReportStatistics {
  final int totalStudentsWithAccess;
  final int studentsAttempted;
  final int studentsCompleted;
  final int? highestScore;
  final double averageScore;
  final double completionRate;

  QuizReportStatistics({
    required this.totalStudentsWithAccess,
    required this.studentsAttempted,
    required this.studentsCompleted,
    this.highestScore,
    required this.averageScore,
    required this.completionRate,
  });

  factory QuizReportStatistics.fromJson(Map<String, dynamic> json) {
    return QuizReportStatistics(
      totalStudentsWithAccess: json['total_students_with_access'] ?? 0,
      studentsAttempted: json['students_attempted'] ?? 0,
      studentsCompleted: json['students_completed'] ?? 0,
      highestScore: json['highest_score'],
      averageScore: (json['average_score'] ?? 0).toDouble(),
      completionRate: (json['completion_rate'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_students_with_access': totalStudentsWithAccess,
      'students_attempted': studentsAttempted,
      'students_completed': studentsCompleted,
      'highest_score': highestScore,
      'average_score': averageScore,
      'completion_rate': completionRate,
    };
  }
}
