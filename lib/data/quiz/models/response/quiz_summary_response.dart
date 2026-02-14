class QuizSummaryResponse {
  final String sessionId;
  final String quizId;
  final String quizName;
  final int score;
  final int totalQuestions;
  final int correctAnswers;
  final DateTime? submittedAt;
  final List<QuizSummaryQuestionResponse> questions;

  QuizSummaryResponse({
    required this.sessionId,
    required this.quizId,
    required this.quizName,
    required this.score,
    required this.totalQuestions,
    required this.correctAnswers,
    this.submittedAt,
    required this.questions,
  });

  factory QuizSummaryResponse.fromJson(Map<String, dynamic> json) {
    return QuizSummaryResponse(
      sessionId: json['session_id'] as String,
      quizId: json['quiz_id'] as String,
      quizName: json['quiz_name'] as String,
      score: json['score'] as int,
      totalQuestions: json['total_questions'] as int,
      correctAnswers: json['correct_answers'] as int,
      submittedAt: json['submitted_at'] != null
          ? DateTime.parse(json['submitted_at'] as String)
          : null,
      questions: (json['questions'] as List<dynamic>)
          .map((e) => QuizSummaryQuestionResponse.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
      'quiz_id': quizId,
      'quiz_name': quizName,
      'score': score,
      'total_questions': totalQuestions,
      'correct_answers': correctAnswers,
      'submitted_at': submittedAt?.toIso8601String(),
      'questions': questions.map((e) => e.toJson()).toList(),
    };
  }
}

class QuizSummaryQuestionResponse {
  final String questionId;
  final String questionText;
  final List<String> questionImages;
  final int questionNumber;
  final String? userAnswerId;
  final String? userAnswer;
  final String correctAnswerId;
  final String correctAnswer;
  final bool isCorrect;

  QuizSummaryQuestionResponse({
    required this.questionId,
    required this.questionText,
    required this.questionImages,
    required this.questionNumber,
    this.userAnswerId,
    this.userAnswer,
    required this.correctAnswerId,
    required this.correctAnswer,
    required this.isCorrect,
  });

  factory QuizSummaryQuestionResponse.fromJson(Map<String, dynamic> json) {
    return QuizSummaryQuestionResponse(
      questionId: json['question_id'] as String,
      questionText: json['question_text'] as String,
      questionImages: List<String>.from(json['question_images'] as List),
      questionNumber: json['question_number'] as int,
      userAnswerId: json['user_answer_id'] as String?,
      userAnswer: json['user_answer'] as String?,
      correctAnswerId: json['correct_answer_id'] as String,
      correctAnswer: json['correct_answer'] as String,
      isCorrect: json['is_correct'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question_id': questionId,
      'question_text': questionText,
      'question_images': questionImages,
      'question_number': questionNumber,
      'user_answer_id': userAnswerId,
      'user_answer': userAnswer,
      'correct_answer_id': correctAnswerId,
      'correct_answer': correctAnswer,
      'is_correct': isCorrect,
    };
  }
}

class QuizSummaryWebResponse {
  final QuizSummaryResponse data;

  QuizSummaryWebResponse({required this.data});

  factory QuizSummaryWebResponse.fromJson(Map<String, dynamic> json) {
    return QuizSummaryWebResponse(
      data: QuizSummaryResponse.fromJson(
          json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.toJson(),
    };
  }
}