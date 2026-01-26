// data/quiz/models/request/create_full_quiz_request.dart

import 'dart:io';

// Merepresentasikan satu pertanyaan lengkap dari sisi UI
class QuestionDataRequest {
  final String description;
  final File? imageFile;
  final List<String> options;
  final int correctAnswerIndex;

  QuestionDataRequest({
    required this.description,
    this.imageFile,
    required this.options,
    required this.correctAnswerIndex,
  });
}

// Merepresentasikan seluruh data yang dibutuhkan untuk membuat kuis
class CreateFullQuizRequest {
  final String quizName;
  final String courseId;
  final int? timeLimit;
  final List<QuestionDataRequest> questions;

  CreateFullQuizRequest({
    required this.quizName,
    required this.courseId,
    this.timeLimit,
    required this.questions,
  });
}
