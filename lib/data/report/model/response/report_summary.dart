class ReportSummary {
  final int totalQuizzes;
  final int attemptedQuizzes;
  final int completedQuizzes;
  final int inProgressQuizzes;
  final double averageScore;
  final double completionRate;

  ReportSummary({
    required this.totalQuizzes,
    required this.attemptedQuizzes,
    required this.completedQuizzes,
    required this.inProgressQuizzes,
    required this.averageScore,
    required this.completionRate,
  });

  factory ReportSummary.fromJson(Map<String, dynamic> json) {
    return ReportSummary(
      totalQuizzes: json['total_quizzes'] ?? 0,
      attemptedQuizzes: json['attempted_quizzes'] ?? 0,
      completedQuizzes: json['completed_quizzes'] ?? 0,
      inProgressQuizzes: json['in_progress_quizzes'] ?? 0,
      averageScore: (json['average_score'] ?? 0).toDouble(),
      completionRate: (json['completion_rate'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_quizzes': totalQuizzes,
      'attempted_quizzes': attemptedQuizzes,
      'completed_quizzes': completedQuizzes,
      'in_progress_quizzes': inProgressQuizzes,
      'average_score': averageScore,
      'completion_rate': completionRate,
    };
  }
}
