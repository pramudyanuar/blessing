import 'package:blessing/data/core/models/content_block.dart';

/// Detail soal dari session summary response
class SessionQuestionDetailResponse {
  final String questionId;
  final String questionText;
  final List<String> questionImages;
  final int questionNumber;
  final String? userAnswerId;
  final String? userAnswer;
  final String correctAnswerId;
  final String correctAnswer;
  final bool isCorrect;
  final List<ContentBlock> explanation;

  SessionQuestionDetailResponse({
    required this.questionId,
    required this.questionText,
    required this.questionImages,
    required this.questionNumber,
    this.userAnswerId,
    this.userAnswer,
    required this.correctAnswerId,
    required this.correctAnswer,
    required this.isCorrect,
    required this.explanation,
  });

  factory SessionQuestionDetailResponse.fromJson(Map<String, dynamic> json) =>
      SessionQuestionDetailResponse(
        questionId: json["question_id"] ?? "",
        questionText: json["question_text"] ?? "",
        questionImages: List<String>.from(
          json["question_images"]?.map((x) => x as String) ?? [],
        ),
        questionNumber: json["question_number"] ?? 0,
        userAnswerId: json["user_answer_id"],
        userAnswer: json["user_answer"],
        correctAnswerId: json["correct_answer_id"] ?? "",
        correctAnswer: json["correct_answer"] ?? "",
        isCorrect: json["is_correct"] ?? false,
        explanation: json['explanation'] != null
            ? (json['explanation'] as List)
                .map((e) => ContentBlock.fromJson(e as Map<String, dynamic>))
                .toList()
            : [],
      );
}
