import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:blessing/modules/admin/report_card/controller/admin_answer_review_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AdminAnswerReviewScreen extends StatelessWidget {
  const AdminAnswerReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminAnswerReviewController>(
      init: AdminAnswerReviewController(),
      builder: (controller) {
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
            actions: [
              Tooltip(
                message: 'Lihat semua attempt',
                child: IconButton(
                  icon: const Icon(Icons.list, color: Colors.black),
                  onPressed: () => controller.goToAttemptsList(),
                ),
              ),
            ],
          ),
          body: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.questions.isEmpty) {
              return const Center(
                child: Text('Data tidak tersedia'),
              );
            }

            return _buildContent(controller);
          }),
        );
      },
    );
  }

  Widget _buildContent(AdminAnswerReviewController controller) {
    return Column(
      children: [
        // Header dengan Quiz info dan Akurasi
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade200),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GlobalText.semiBold(
                controller.quizName.value,
                fontSize: 16.sp,
                color: Colors.black87,
              ),
              SizedBox(height: 8.h),
              GlobalText.regular(
                controller.userName.value,
                fontSize: 13.sp,
                color: Colors.grey.shade600,
              ),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GlobalText.medium(
                    'Total: ${controller.questions.length} soal',
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                  ),
                  GlobalText.semiBold(
                    'Akurasi: ${controller.accuracy}%',
                    fontSize: 12.sp,
                    color: AppColors.c2,
                  ),
                ],
              ),
            ],
          ),
        ),

        // List of Questions
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: controller.questions.length,
            itemBuilder: (context, index) {
              final question = controller.questions[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: Column(
                  children: [
                    // Question number badge
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: question.isCorrect
                                ? Colors.green.withValues(alpha: 0.1)
                                : Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: question.isCorrect
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                          child: GlobalText.semiBold(
                            'Soal ${index + 1}',
                            fontSize: 12.sp,
                            color: question.isCorrect
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: question.isCorrect
                                ? Colors.green.withValues(alpha: 0.1)
                                : Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: GlobalText.semiBold(
                            question.isCorrect ? 'BENAR' : 'SALAH',
                            fontSize: 11.sp,
                            color: question.isCorrect
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    // Question Card
                    _buildQuestionCard(question),
                    SizedBox(height: 12.h),
                    // Explanation if available
                    if (question.explanation != null)
                      _buildExplanationCard(question),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionCard(QuestionReviewData currentQuestion) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question Text
          GlobalText.semiBold(
            currentQuestion.questionText,
            fontSize: 15.sp,
            color: Colors.black87,
          ),
          SizedBox(height: 16.h),
          // Question Images
          if (currentQuestion.questionImages.isNotEmpty) ...[
            _buildQuestionImages(currentQuestion.questionImages),
            SizedBox(height: 16.h),
          ],
          // User Answer
          if (currentQuestion.userAnswer != null) ...[
            _buildAnswerDisplay(
              'Jawaban Siswa',
              currentQuestion.userAnswer!,
              Colors.orange,
            ),
            SizedBox(height: 12.h),
          ],
          // Correct Answer (only show if different from user answer)
          if (currentQuestion.userAnswer != currentQuestion.correctAnswer) ...[
            _buildAnswerDisplay(
              'Jawaban Benar',
              currentQuestion.correctAnswer,
              Colors.green,
            ),
          ] else if (currentQuestion.userAnswer == null) ...[
            _buildAnswerDisplay(
              'Jawaban Benar',
              currentQuestion.correctAnswer,
              Colors.green,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuestionImages(List<String> images) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlobalText.medium(
          'Gambar Soal',
          fontSize: 13.sp,
          color: Colors.grey.shade600,
        ),
        SizedBox(height: 12.h),
        Column(
          children: images.map((image) {
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: GestureDetector(
                onTap: () => _showImageDetail(image),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: Stack(
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: 220.h),
                          child: CachedNetworkImage(
                            imageUrl: image,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              height: 220.h,
                              color: Colors.grey.shade200,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              height: 220.h,
                              color: Colors.grey.shade200,
                              child: const Center(
                                child: Icon(Icons.image_not_supported),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 10.h,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.55),
                                ],
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GlobalText.medium(
                                  'Tap untuk zoom',
                                  fontSize: 11.sp,
                                  color: Colors.white,
                                  textAlign: TextAlign.start,
                                ),
                                Icon(
                                  Icons.zoom_in,
                                  color: Colors.white,
                                  size: 16.sp,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _showImageDetail(String imageUrl) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            // Backdrop
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  color: Colors.black.withValues(alpha: 0.7),
                ),
              ),
            ),
            // Image
            Center(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: Container(
                        color: Colors.white,
                        child: InteractiveViewer(
                          minScale: 1.0,
                          maxScale: 4.0,
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.contain,
                            placeholder: (context, url) => Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(32.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(32.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: const Icon(Icons.image_not_supported),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // Close button
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close, color: Colors.black),
                      label: GlobalText.medium(
                        'Tutup',
                        fontSize: 12.sp,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerDisplay(
    String label,
    String answer,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GlobalText.medium(
                  label,
                  fontSize: 12.sp,
                  color: color,
                ),
                SizedBox(height: 4.h),
                GlobalText.regular(
                  answer,
                  fontSize: 14.sp,
                  color: Colors.black87,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExplanationCard(QuestionReviewData currentQuestion) {
    return Container(
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
            currentQuestion.explanation ?? '',
            fontSize: 13.sp,
            color: Colors.grey.shade700,
          ),
        ],
      ),
    );
  }
}


