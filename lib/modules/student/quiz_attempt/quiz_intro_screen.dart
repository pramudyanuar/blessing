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
      appBar: AppBar(
        centerTitle: false,
        title: GlobalText.semiBold(
          "Detail Kuis",
          fontSize: 16.sp,
          color: AppColors.c2,
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.grey.withValues(alpha: 0.2),
        elevation: 0.5,
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
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Card(
                color: Colors.white,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  side: BorderSide(color: AppColors.c2, width: 0.5.w),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
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
                                      width: 120.r,
                                      height: 120.r,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            AppColors.c2.withValues(alpha: 0.8),
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
                                                fontSize: 48.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              'dari 100',
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                    Text(
                                      'Kuis Selesai',
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.c2,
                                      ),
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
                      Text(
                        details['title'] ?? 'Judul Kuis',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.c2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        icon: Icons.timer_outlined,
                        label: 'Durasi',
                        value: '${details['duration']} Menit',
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        icon: Icons.help_outline,
                        label: 'Jumlah Soal',
                        value: '${details['totalQuestions'] ?? 0} soal',
                      ),
                      // Status indicator
                      SizedBox(height: 12.h),
                      Obx(() {
                        String statusText = '';
                        Color statusColor = Colors.blue;

                        switch (controller.quizStatus.value) {
                          case QuizAttemptStatus.notStarted:
                            statusText = 'Belum dimulai';
                            statusColor = Colors.grey;
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
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6.r),
                            border: Border.all(color: statusColor),
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
                                        : Icons.pending,
                                color: statusColor,
                                size: 14.sp,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                statusText,
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
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
                        OutlinedButton(
                          onPressed: controller.startNewQuiz,
                          child: const Text(
                            'Mulai Ulang',
                            style: TextStyle(color: AppColors.c2),
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
                        if (controller.canRetake.value) ...[
                          SizedBox(height: 8.h),
                          OutlinedButton(
                            onPressed: controller.retakeQuiz,
                            child: const Text(
                              'Coba Lagi',
                              style: TextStyle(color: AppColors.c2),
                            ),
                          ),
                        ],
                      ],
                    );
                }
              }),
              const SizedBox(height: 16),
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
        Icon(icon, color: AppColors.c2, size: 22),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
