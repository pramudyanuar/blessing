import 'package:blessing/core/constants/color.dart';
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
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Navigasi Soal",
                  style:
                      TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
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
                      final isAnswered =
                          controller.userAnswers.containsKey(index);
                      // TAMBAHKAN LOGIKA INI
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
                          // Tambahkan style untuk menandai soal yang aktif
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            side: isActive
                                ? BorderSide(
                                    color: Colors.orange.shade700,
                                    width:
                                        2.5) // Garis pinggir untuk soal aktif
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
              ElevatedButton(
                onPressed: () {
                  // TODO: Logika untuk submit kuis
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48.h),
                  backgroundColor: Colors.green,
                ),
                child: const Text("Selesai"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
