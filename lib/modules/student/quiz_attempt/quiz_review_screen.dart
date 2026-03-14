import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/core/global_components/global_button.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:blessing/core/utils/app_routes.dart';
import 'package:blessing/data/core/models/content_block.dart';
import 'package:blessing/modules/student/quiz_attempt/controller/quiz_review_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class QuizReviewScreen extends StatelessWidget {
  const QuizReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(QuizReviewController());
    
    // Cek apakah diakses dari list (bisa back) atau dari quiz attempt (tidak bisa back)
    final arguments = Get.arguments as Map<String, dynamic>? ?? {};
    final fetchFromServer = arguments['fetchFromServer'] as bool? ?? false;
    final canPop = fetchFromServer; // Jika dari list, bisa back

    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, result) {
        // Kalau perlu logic ketika pop terjadi
      },
      child: BaseWidgetContainer(
        backgroundColor: AppColors.c5,
        appBar: AppBar(
          centerTitle: false,
          title: GlobalText.semiBold("Pembahasan Kuis", fontSize: 16.sp),
          backgroundColor: Colors.white,
          elevation: 0.5,
          automaticallyImplyLeading: canPop, // Sembunyikan back button jika tidak bisa back
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Score Card
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GlobalText.bold(
                      controller.quizName.value,
                      fontSize: 20.sp,
                      color: AppColors.c2,
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GlobalText.medium(
                              'Skor Anda',
                              fontSize: 12.sp,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                GlobalText.bold(
                                  '${controller.score.value}',
                                  fontSize: 32.sp,
                                  color: AppColors.c2,
                                ),
                                SizedBox(width: 4.w),
                                GlobalText.medium(
                                  '/100',
                                  fontSize: 16.sp,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          width: 80.w,
                          height: 80.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _getScoreColor(controller.score.value)
                                .withValues(alpha: 0.1),
                          ),
                          child: Center(
                            child: GlobalText.bold(
                              _getScoreGrade(controller.score.value),
                              fontSize: 24.sp,
                              color: _getScoreColor(controller.score.value),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              // Detail Per Soal
              GlobalText.semiBold(
                'Detail Jawaban',
                fontSize: 14.sp,
                color: AppColors.c2,
              ),
              SizedBox(height: 12.h),

              if (controller.reviewItems.isEmpty)
                Center(
                  child: GlobalText.regular(
                    'Tidak ada data pembahasan',
                    fontSize: 14.sp,
                    color: Colors.grey,
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.reviewItems.length,
                  itemBuilder: (context, index) {
                    final item = controller.reviewItems[index];
                    final question = item['question'];
                    final userAnswer = item['userAnswer'];
                    final correctAnswer = item['correctAnswer'];
                    final isCorrect = item['isCorrect'] as bool;

                    return _buildQuestionCard(
                      questionNumber: index + 1,
                      question: question,
                      userAnswer: userAnswer,
                      correctAnswer: correctAnswer,
                      isCorrect: isCorrect,
                    );
                  },
                ),
                // Tombol Reattempt (Coba Lagi)
                GlobalButton(
                  text: "Coba Lagi (Reattempt)",
                  width: double.infinity,
                  height: 50,
                  fontSize: 15.sp,
                  color: Colors.orange.shade700,
                  onPressed: () {
                    Get.offNamed(
                      AppRoutes.quizAttempt,
                      arguments: {
                        'quizId': controller.quizId,
                        'quizName': controller.quizName,
                      },
                    );
                  },
                ),

                SizedBox(height: 12.h),

                // Tombol Kembali ke Menu Utama
                GlobalButton(
                  text: "Kembali ke Menu Utama",
                  width: double.infinity,
                  height: 50,
                  fontSize: 15.sp,
                  onPressed: () {
                    // Baik dari list maupun dari quiz attempt -> kembali ke menu utama
                    Get.offAllNamed(AppRoutes.studentMenu);
                  },
                ),
                
                SizedBox(height: 32.h),
            ],
          ),
        );
      }),
      ),
    );
  }

  Widget _buildQuestionCard({
    required int questionNumber,
    required dynamic question,
    required dynamic userAnswer,
    required dynamic correctAnswer,
    required bool isCorrect,
  }) {
    final statusColor = isCorrect ? Colors.green : Colors.red;
    final statusIcon = isCorrect ? Icons.check_circle : Icons.cancel;
    final statusText = isCorrect ? 'Benar' : 'Salah';

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header dengan status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GlobalText.semiBold(
                'Soal $questionNumber',
                fontSize: 13.sp,
                color: Colors.black,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, size: 14.sp, color: statusColor),
                    SizedBox(width: 4.w),
                    GlobalText.semiBold(
                      statusText,
                      fontSize: 11.sp,
                      color: statusColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),

          // Pertanyaan Text
          if (_extractQuestionText(question).isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GlobalText.medium(
                  'Pertanyaan:',
                  fontSize: 11.sp,
                  color: Colors.grey.shade600,
                ),
                SizedBox(height: 4.h),
                GlobalText.regular(
                  _extractQuestionText(question),
                  fontSize: 12.sp,
                  color: Colors.black87,
                ),
                SizedBox(height: 8.h),
              ],
            ),

          // Question Images (jika ada)
          if (_hasQuestionImages(question))
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ..._buildQuestionImages(question),
                SizedBox(height: 8.h),
              ],
            ),

          // Jawaban User
          _buildAnswerRow(
            label: 'Jawaban Kamu:',
            answer: _extractAnswerValue(userAnswer),
            isCorrect: isCorrect,
          ),
          SizedBox(height: 8.h),

          // Jawaban Benar (hanya tampil jika salah)
          if (!isCorrect)
            _buildAnswerRow(
              label: 'Jawaban Benar:',
              answer: _extractAnswerValue(correctAnswer),
              isCorrect: true,
            ),
        ],
      ),
    );
  }

  Widget _buildAnswerRow({
    required String label,
    required String answer,
    required bool isCorrect,
  }) {
    final color = isCorrect ? Colors.green : Colors.red;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlobalText.medium(
          label,
          fontSize: 11.sp,
          color: Colors.grey.shade600,
        ),
        SizedBox(height: 4.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: GlobalText.regular(
            answer,
            fontSize: 12.sp,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  /// Extract question text dari berbagai format
  /// Format baru: Map dengan 'questionText' key (dari SessionSummaryResponse)
  /// Format lama: QuestionResponse model dengan 'content' property
  String _extractQuestionText(dynamic question) {
    if (question == null) return '';

    // Format baru: Map dari SessionSummaryResponse
    if (question is Map<String, dynamic>) {
      final text = question['questionText'];
      // Return text jika ada dan tidak kosong, otherwise return empty (images only)
      if (text != null && text is String && text.trim().isNotEmpty) {
        return text.trim();
      }
      // Jika questionText kosong, return empty (soal pure image)
      return '';
    }

    // Format lama: QuestionResponse model dengan content (list of ContentBlock)
    try {
      if (question.content != null && question.content is List) {
        final contents = question.content as List<dynamic>;
        if (contents.isNotEmpty) {
          final firstContent = contents.first;
          if (firstContent is ContentBlock && firstContent.data.isNotEmpty) {
            return firstContent.data;
          }
        }
      }
    } catch (e) {
      debugPrint('Error extracting question text: $e');
    }

    return '';
  }

  /// Check apakah question memiliki images
  bool _hasQuestionImages(dynamic question) {
    if (question is Map<String, dynamic>) {
      final images = question['questionImages'] as List?;
      return images != null && images.isNotEmpty;
    }
    return false;
  }

  /// Build widgets untuk menampilkan question images
  List<Widget> _buildQuestionImages(dynamic question) {
    final widgets = <Widget>[];
    if (question is Map<String, dynamic>) {
      final images = question['questionImages'] as List?;
      if (images != null && images.isNotEmpty) {
        for (int i = 0; i < images.length; i++) {
          final imageUrl = images[i] as String?;
          if (imageUrl != null && imageUrl.isNotEmpty) {
            widgets.add(
              Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6.r),
                  child: Image.network(
                    imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: double.infinity,
                      height: 150.h,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Center(
                        child: Icon(Icons.broken_image,
                            color: Colors.grey.shade400),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        }
      }
    }
    return widgets;
  }

  /// Extract answer value dari berbagai format
  /// Bisa dari Map {'option': 'value'} atau dari object dengan .option property
  String _extractAnswerValue(dynamic answer) {
    if (answer == null) return 'Tidak menjawab';
    
    // Format Map (dari SessionSummaryResponse)
    if (answer is Map<String, dynamic>) {
      final value = answer['option'];
      if (value != null && value is String && value.isNotEmpty) {
        return value;
      }
      return 'Tidak menjawab';
    }
    
    // Format object dengan .option property (backward compat)
    try {
      final value = answer.option;
      if (value != null && value is String && value.isNotEmpty) {
        return value;
      }
      return 'Tidak menjawab';
    } catch (e) {
      debugPrint('Error extracting answer value: $e');
      return 'Tidak tersedia';
    }
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  String _getScoreGrade(int score) {
    if (score >= 80) return 'A';
    if (score >= 70) return 'B';
    if (score >= 60) return 'C';
    if (score >= 50) return 'D';
    return 'F';
  }
}
