class QuizReport {
  final String quizId;
  final String quizName;
  final int timeLimit;
  final String courseId;
  final String courseName;
  final String subjectId;
  final String subjectName;
  final bool isAttempted;
  final String status;
  final String? sessionId;
  final int? score;
  final bool? submitted;
  final bool? autoSubmitted;
  final DateTime? attemptedAt;
  final DateTime? completedAt;

  QuizReport({
    required this.quizId,
    required this.quizName,
    required this.timeLimit,
    required this.courseId,
    required this.courseName,
    required this.subjectId,
    required this.subjectName,
    required this.isAttempted,
    required this.status,
    this.sessionId,
    this.score,
    this.submitted,
    this.autoSubmitted,
    this.attemptedAt,
    this.completedAt,
  });

  factory QuizReport.fromJson(Map<String, dynamic> json) {
    return QuizReport(
      quizId: json['quiz_id'] ?? '',
      quizName: json['quiz_name'] ?? '',
      timeLimit: json['time_limit'] ?? 0,
      courseId: json['course_id'] ?? '',
      courseName: json['course_name'] ?? '',
      subjectId: json['subject_id'] ?? '',
      subjectName: json['subject_name'] ?? '',
      isAttempted: json['is_attempted'] ?? false,
      status: json['status'] ?? '',
      sessionId: json['session_id'],
      score: json['score'],
      submitted: json['submitted'],
      autoSubmitted: json['auto_submitted'],
      attemptedAt: json['attempted_at'] != null
          ? DateTime.parse(json['attempted_at'])
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quiz_id': quizId,
      'quiz_name': quizName,
      'time_limit': timeLimit,
      'course_id': courseId,
      'course_name': courseName,
      'subject_id': subjectId,
      'subject_name': subjectName,
      'is_attempted': isAttempted,
      'status': status,
      'session_id': sessionId,
      'score': score,
      'submitted': submitted,
      'auto_submitted': autoSubmitted,
      'attempted_at': attemptedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }
}
