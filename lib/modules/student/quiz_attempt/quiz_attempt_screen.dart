// lib/modules/student/quiz_attempt/screens/quiz_attempt_screen.dart

import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:blessing/modules/student/quiz_attempt/controller/quiz_attempt_controller.dart';
import 'package:blessing/modules/student/quiz_attempt/widgets/question_navigation_drawer.dart';
import 'package:blessing/modules/student/quiz_attempt/widgets/quiz_attempt_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class QuizAttemptScreen extends StatelessWidget {
  const QuizAttemptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Diasumsikan controller diinisialisasi melalui GetX Binding
    final controller = Get.find<QuizAttemptController>();
    final scaffoldKey = GlobalKey<ScaffoldState>();

    // 1. Tambahkan WillPopScope di sini untuk mencegah keluar dari halaman
    return WillPopScope(
      onWillPop: controller.onWillPop,
      child: BaseWidgetContainer(
        scaffoldKey: scaffoldKey,
        appBar: AppBar(
          backgroundColor: AppColors.c1,
          automaticallyImplyLeading: false,
          title: GlobalText.bold("Kuis"), // Judul bisa dibuat dinamis
          centerTitle: true,
          flexibleSpace: SafeArea(
            child: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 16),
              child: Obx(() => Text(
                    // Tampilkan timer jika kuis sedang berjalan
                    !controller.isLoading.value &&
                            controller.errorMessage.value.isEmpty
                        ? controller.timerText
                        : "00:00:00",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold),
                  )),
            ),
          ),
          actions: [
            Obx(() => IconButton(
                  icon: const Icon(Icons.menu),
                  // Nonaktifkan tombol menu saat loading atau jika ada error conflict
                  onPressed: controller.isLoading.value ||
                          controller.isQuizAlreadyAttempted.value
                      ? null
                      : () => scaffoldKey.currentState?.openEndDrawer(),
                )),
          ],
        ),
        // Body akan berubah sesuai state dari controller
        body: Obx(() {
          // State: Loading
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          // State: Kuis Sudah Dikerjakan (Conflict Error)
          if (controller.isQuizAlreadyAttempted.value) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      size: 80,
                      color: Colors.green,
                    ),
                    SizedBox(height: 16.h),
                    GlobalText.bold(
                      "Kuis Telah Dikerjakan",
                      fontSize: 20.sp,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),
                    GlobalText.regular(
                      controller.errorMessage.value,
                      textAlign: TextAlign.center,
                      fontSize: 16.sp,
                    ),
                    SizedBox(height: 24.h),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.c2,
                        padding: EdgeInsets.symmetric(
                            horizontal: 32.w, vertical: 12.h),
                      ),
                      onPressed: () =>
                          Get.back(), // Kembali ke halaman sebelumnya
                      child: GlobalText.medium(
                        "Kembali",
                        color: Colors.white,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // State: Error Umum Lainnya
          if (controller.errorMessage.value.isNotEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 60.r),
                    SizedBox(height: 16.h),
                    GlobalText.regular(
                      controller.errorMessage.value,
                      textAlign: TextAlign.center,
                      color: Colors.red,
                      fontSize: 16.sp,
                    ),
                    SizedBox(height: 20.h),
                    ElevatedButton(
                      onPressed: () =>
                          controller.initiateQuiz(), // Tombol coba lagi
                      child: const Text('Coba Lagi'),
                    )
                  ],
                ),
              ),
            );
          }

          // State: Sukses (Kuis Berjalan)
          return Container(
            color: AppColors.c5,
            child: const QuizAttemptBody(),
          );
        }),
        endDrawer: const QuestionNavigationDrawer(),
      ),
    );
  }
}
