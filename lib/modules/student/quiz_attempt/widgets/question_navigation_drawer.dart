// lib/modules/student/quiz_attempt/widgets/question_navigation_drawer.dart

import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/global_button.dart';
// Pastikan import ini ada
import 'package:blessing/core/global_components/global_text.dart';
import 'package:blessing/modules/student/quiz_attempt/controller/quiz_attempt_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class QuestionNavigationDrawer extends StatelessWidget {
  const QuestionNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<QuizAttemptController>();

    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GlobalText.semiBold("Navigasi Soal", fontSize: 14.sp),
              SizedBox(height: 16.h),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: controller.questions.length,
                  itemBuilder: (context, index) {
                    return Obx(() {
                      // ---- PERBAIKAN LOGIKA isAnswered ----
                      // Cek jawaban berdasarkan ID pertanyaan, bukan index
                      final questionId = controller.questions[index].id;
                      final isAnswered =
                          controller.userAnswers.containsKey(questionId);
                      final isActive =
                          controller.currentQuestionIndex.value == index;

                      return ElevatedButton(
                        onPressed: () => controller.jumpToQuestion(index),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isAnswered ? AppColors.c2 : Colors.grey.shade200,
                          foregroundColor:
                              isAnswered ? Colors.white : Colors.black,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            side: isActive
                                ? BorderSide(
                                    color: Colors.orange.shade700,
                                    width: 2.5,
                                  )
                                : BorderSide.none,
                          ),
                        ),
                        child: Text((index + 1).toString()),
                      );
                    });
                  },
                ),
              ),
              SizedBox(height: 16.h),
              GlobalButton(
                text: "Kirim Jawaban",
                onPressed: () {
                  // ---- IMPLEMENTASI SUBMIT ----
                  // 1. Tutup drawer terlebih dahulu
                  Navigator.of(context).pop();
                  // 2. Panggil method konfirmasi dari controller
                  controller.confirmAndSubmitQuiz();
                },
                width: double.infinity,
                height: 48,
                color: const Color.fromARGB(255, 46, 141, 49),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
