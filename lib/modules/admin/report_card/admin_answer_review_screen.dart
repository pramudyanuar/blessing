import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AdminAnswerReviewScreen extends StatefulWidget {
  const AdminAnswerReviewScreen({super.key});

  @override
  State<AdminAnswerReviewScreen> createState() =>
      _AdminAnswerReviewScreenState();
}

class _AdminAnswerReviewScreenState extends State<AdminAnswerReviewScreen> {
  int currentQuestionIndex = 0;
  late final String quizId;
  late final String userId;
  late final String quizName;
  late final String userName;

  // Mock data structure - replace with actual API call
  late final List<QuestionReview> questions;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;
    quizId = args?['quizId'] ?? '';
    userId = args?['userId'] ?? '';
    quizName = args?['quizName'] ?? 'Quiz';
    userName = args?['userName'] ?? 'Siswa';

    // Initialize mock data
    _initializeMockData();
  }

  void _initializeMockData() {
    questions = [
      QuestionReview(
        questionNumber: 1,
        questionText: 'Berapa hasil dari 2 + 2?',
        userAnswer: 'A',
        correctAnswer: 'A',
        isCorrect: true,
        options: [
          {'label': 'A', 'text': '4'},
          {'label': 'B', 'text': '5'},
          {'label': 'C', 'text': '3'},
          {'label': 'D', 'text': '6'},
        ],
        explanation:
            '2 + 2 = 4 adalah penjumlahan dasar yang menghasilkan angka 4.',
      ),
      QuestionReview(
        questionNumber: 2,
        questionText: 'Ibu kota Indonesia adalah?',
        userAnswer: 'B',
        correctAnswer: 'A',
        isCorrect: false,
        options: [
          {'label': 'A', 'text': 'Jakarta'},
          {'label': 'B', 'text': 'Bandung'},
          {'label': 'C', 'text': 'Surabaya'},
          {'label': 'D', 'text': 'Medan'},
        ],
        explanation:
            'Jakarta adalah ibu kota Indonesia yang berlokasi di Pulau Jawa.',
      ),
      QuestionReview(
        questionNumber: 3,
        questionText: 'Siapa penemu lampu pijar?',
        userAnswer: null,
        correctAnswer: 'A',
        isCorrect: false,
        options: [
          {'label': 'A', 'text': 'Thomas Edison'},
          {'label': 'B', 'text': 'Nikola Tesla'},
          {'label': 'C', 'text': 'Alexander Graham Bell'},
          {'label': 'D', 'text': 'Guglielmo Marconi'},
        ],
        explanation:
            'Thomas Edison menemukan lampu pijar yang praktis untuk digunakan.',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[currentQuestionIndex];
    final correctCount =
        questions.where((q) => q.isCorrect).length;
    final accuracy =
        ((correctCount / questions.length) * 100).toStringAsFixed(1);

    return BaseWidgetContainer(
      backgroundColor: AppColors.c5,
      appBar: AppBar(
        title: GlobalText.semiBold(
          'Review Jawaban',
          fontSize: 18.sp,
          color: AppColors.c2,
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          // Progress Header
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GlobalText.semiBold(
                  quizName,
                  fontSize: 16.sp,
                  color: Colors.black87,
                ),
                SizedBox(height: 8.h),
                GlobalText.regular(
                  userName,
                  fontSize: 13.sp,
                  color: Colors.grey.shade600,
                ),
                SizedBox(height: 12.h),
                // Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: LinearProgressIndicator(
                    value: (currentQuestionIndex + 1) / questions.length,
                    minHeight: 8.h,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: const AlwaysStoppedAnimation(AppColors.c2),
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GlobalText.medium(
                      'Soal ${currentQuestionIndex + 1} dari ${questions.length}',
                      fontSize: 12.sp,
                      color: Colors.grey.shade600,
                    ),
                    GlobalText.semiBold(
                      'Akurasi: $accuracy%',
                      fontSize: 12.sp,
                      color: AppColors.c2,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Question Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question Card
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Status Badge
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: currentQuestion.isCorrect
                                ? Colors.green.withValues(alpha: 0.1)
                                : Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: GlobalText.semiBold(
                            currentQuestion.isCorrect ? 'BENAR' : 'SALAH',
                            fontSize: 11.sp,
                            color: currentQuestion.isCorrect
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        // Question Text
                        GlobalText.semiBold(
                          currentQuestion.questionText,
                          fontSize: 16.sp,
                          color: Colors.black87,
                        ),
                        SizedBox(height: 16.h),
                        // Options
                        ...currentQuestion.options.map((option) {
                          final isUserAnswer =
                              option['label'] == currentQuestion.userAnswer;
                          final isCorrect =
                              option['label'] == currentQuestion.correctAnswer;
                          final isWrongAnswer =
                              isUserAnswer && !isCorrect;

                          Color backgroundColor;
                          Color borderColor;
                          Color textColor;

                          if (isCorrect) {
                            backgroundColor = Colors.green.withValues(alpha: 0.1);
                            borderColor = Colors.green;
                            textColor = Colors.green;
                          } else if (isWrongAnswer) {
                            backgroundColor = Colors.red.withValues(alpha: 0.1);
                            borderColor = Colors.red;
                            textColor = Colors.red;
                          } else {
                            backgroundColor = Colors.grey.withValues(alpha: 0.05);
                            borderColor = Colors.grey.shade300;
                            textColor = Colors.grey.shade700;
                          }

                          return Padding(
                            padding: EdgeInsets.only(bottom: 8.h),
                            child: Container(
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                border: Border.all(color: borderColor),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 32.w,
                                    height: 32.h,
                                    decoration: BoxDecoration(
                                      color: borderColor,
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                    child: Center(
                                      child: GlobalText.semiBold(
                                        option['label'],
                                        fontSize: 12.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: GlobalText.regular(
                                      option['text'],
                                      fontSize: 14.sp,
                                      color: textColor,
                                    ),
                                  ),
                                  if (isCorrect)
                                    Icon(Icons.check_circle,
                                        color: Colors.green, size: 20.sp)
                                  else if (isWrongAnswer)
                                    Icon(Icons.close,
                                        color: Colors.red, size: 20.sp),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Explanation Card
                  if (currentQuestion.explanation != null)
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: AppColors.c2.withValues(alpha: 0.05),
                        border: Border(
                          left: BorderSide(
                            color: AppColors.c2,
                            width: 4.w,
                          ),
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GlobalText.semiBold(
                            'Penjelasan',
                            fontSize: 13.sp,
                            color: AppColors.c2,
                          ),
                          SizedBox(height: 8.h),
                          GlobalText.regular(
                            currentQuestion.explanation!,
                            fontSize: 13.sp,
                            color: Colors.grey.shade700,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Navigation Buttons
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                if (currentQuestionIndex > 0)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        setState(() => currentQuestionIndex--);
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Sebelumnya'),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.c2),
                      ),
                    ),
                  ),
                if (currentQuestionIndex > 0) SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: currentQuestionIndex < questions.length - 1
                        ? () {
                            setState(() => currentQuestionIndex++);
                          }
                        : () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.c2,
                    ),
                    icon: Icon(
                      currentQuestionIndex < questions.length - 1
                          ? Icons.arrow_forward
                          : Icons.check,
                    ),
                    label: Text(
                      currentQuestionIndex < questions.length - 1
                          ? 'Selanjutnya'
                          : 'Selesai',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class QuestionReview {
  final int questionNumber;
  final String questionText;
  final String? userAnswer;
  final String correctAnswer;
  final bool isCorrect;
  final List<dynamic> options;
  final String? explanation;

  QuestionReview({
    required this.questionNumber,
    required this.questionText,
    required this.userAnswer,
    required this.correctAnswer,
    required this.isCorrect,
    required this.options,
    this.explanation,
  });
}
