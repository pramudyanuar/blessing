import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/core/global_components/global_button.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:blessing/modules/student/quiz_attempt/controller/quiz_intro_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class QuizIntroScreen extends StatelessWidget {
  const QuizIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<QuizIntroController>();

    return BaseWidgetContainer(
      backgroundColor: AppColors.c5,
      appBar: AppBar(
        centerTitle: false,
        title: GlobalText.bold(
          "Detail Kuis",
          fontSize: 16.sp,
          color: Colors.black,
          fontFamily: 'Inter',
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 3,
        shadowColor: Colors.black.withValues(alpha: 0.4),
        toolbarHeight: 65.h,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.c2),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                controller.errorMessage.value,
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final details = controller.quizDetails.value;
        return Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Show score prominently if submitted
                    Obx(() {
                      if (controller.quizStatus.value ==
                          QuizAttemptStatus.submitted) {
                        return Column(
                          children: [
                            Center(
                              child: Column(
                                children: [
                                  Container(
                                    width: 110.r,
                                    height: 110.r,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          AppColors.c3,
                                          AppColors.c2,
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.c2
                                              .withValues(alpha: 0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            controller
                                                .previousScore.value
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 40.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontFamily: 'Inter',
                                            ),
                                          ),
                                          Text(
                                            'dari 100',
                                            style: TextStyle(
                                              fontSize: 11.sp,
                                              color: Colors.white70,
                                              fontFamily: 'Inter',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  GlobalText.bold(
                                    'Kuis Selesai',
                                    fontSize: 16.sp,
                                    color: AppColors.c2,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16.h),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                    GlobalText.bold(
                      details['title'] ?? 'Judul Kuis',
                      fontSize: 18.sp,
                      color: AppColors.c2,
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 16.h),
                    _buildInfoRow(
                      icon: Icons.timer_outlined,
                      label: 'Durasi',
                      value: '${details['duration']} Menit',
                    ),
                    SizedBox(height: 10.h),
                    _buildInfoRow(
                      icon: Icons.help_outline,
                      label: 'Jumlah Soal',
                      value: '${details['totalQuestions'] ?? 0} soal',
                    ),
                    // Status indicator
                    SizedBox(height: 16.h),
                    Obx(() {
                      String statusText = '';
                      Color statusColor = Colors.blue;

                      switch (controller.quizStatus.value) {
                        case QuizAttemptStatus.notStarted:
                          statusText = 'Belum dimulai';
                          statusColor = Colors.grey.shade600;
                          break;
                        case QuizAttemptStatus.inProgress:
                          statusText = 'Sedang dikerjakan';
                          statusColor = Colors.orange;
                          break;
                        case QuizAttemptStatus.submitted:
                          statusText = 'Sudah diselesaikan';
                          statusColor = Colors.green;
                          break;
                      }

                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6.r),
                          border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              controller.quizStatus.value ==
                                      QuizAttemptStatus.inProgress
                                  ? Icons.schedule
                                  : controller.quizStatus.value ==
                                          QuizAttemptStatus.submitted
                                      ? Icons.check_circle
                                      : Icons.pending_actions,
                              color: statusColor,
                              size: 14.sp,
                            ),
                            SizedBox(width: 6.w),
                            GlobalText.semiBold(
                              statusText,
                              color: statusColor,
                              fontSize: 11.sp,
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const Spacer(),
              // Dynamic button based on quiz status
              Obx(() {
                switch (controller.quizStatus.value) {
                  case QuizAttemptStatus.notStarted:
                    return GlobalButton(
                      text: "Mulai Kuis",
                      onPressed: controller.startNewQuiz,
                    );

                  case QuizAttemptStatus.inProgress:
                    return Column(
                      children: [
                        GlobalButton(
                          text: "Lanjutkan Kuis",
                          onPressed: controller.resumeQuiz,
                        ),
                        SizedBox(height: 8.h),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: controller.startNewQuiz,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.c2),
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            child: GlobalText.semiBold(
                              'Mulai Ulang',
                              color: AppColors.c2,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ],
                    );

                  case QuizAttemptStatus.submitted:
                    return Column(
                      children: [
                        GlobalButton(
                          text: "Lihat Detail Jawaban",
                          onPressed: controller.viewResult,
                        ),
                        SizedBox(height: 8.h),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: controller.viewAttemptsList,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.c2),
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            child: GlobalText.semiBold(
                              'Lihat Semua Attempt',
                              color: AppColors.c2,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                        if (controller.canRetake.value) ...[
                          SizedBox(height: 8.h),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: controller.retakeQuiz,
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppColors.c2),
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              child: GlobalText.semiBold(
                                'Coba Lagi',
                                color: AppColors.c2,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ],
                      ],
                    );
                }
              }),
              SizedBox(height: 16.h),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppColors.c2, size: 20.sp),
        SizedBox(width: 12.w),
        GlobalText.semiBold(
          label,
          fontSize: 14.sp,
          color: Colors.black87,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: GlobalText.regular(
            value,
            fontSize: 14.sp,
            color: Colors.black54,
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
