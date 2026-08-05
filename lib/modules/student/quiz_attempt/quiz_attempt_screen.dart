// lib/modules/student/quiz_attempt/screens/quiz_attempt_screen.dart

import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:blessing/core/global_components/global_button.dart';
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
    return PopScope(
      canPop: false, // default jangan langsung pop
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final shouldPop = await controller.onWillPop();
        if (shouldPop) {
          Get.back();
        }
      },
      child: BaseWidgetContainer(
        scaffoldKey: scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 3,
          shadowColor: Colors.black.withValues(alpha: 0.4),
          toolbarHeight: 65.h,
          automaticallyImplyLeading: false,
          leadingWidth: 100.w,
          leading: Center(
            child: Obx(() => Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: GlobalText.bold(
                    !controller.isLoading.value &&
                            controller.errorMessage.value.isEmpty
                        ? controller.timerText
                        : "00:00:00",
                    color: Colors.red,
                    fontSize: 13.sp,
                    fontFamily: 'Inter',
                  ),
                )),
          ),
          title: GlobalText.bold(
            "Kuis",
            fontSize: 16.sp,
            color: Colors.black,
            fontFamily: 'Inter',
          ),
          centerTitle: true,
          actions: [
            Obx(() => IconButton(
                  icon: const Icon(Icons.menu, color: AppColors.c2),
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
            return SafeArea(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Container(
                    padding: EdgeInsets.all(24.w),
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle_outline,
                          size: 70,
                          color: Colors.green,
                        ),
                        SizedBox(height: 16.h),
                        GlobalText.bold(
                          "Kuis Telah Dikerjakan",
                          fontSize: 18.sp,
                          color: Colors.black,
                        ),
                        SizedBox(height: 8.h),
                        GlobalText.regular(
                          controller.errorMessage.value,
                          fontSize: 13.sp,
                          color: Colors.grey.shade600,
                        ),
                        SizedBox(height: 24.h),
                        GlobalButton(
                          text: "Kembali",
                          height: 45.h,
                          onPressed: () => Get.back(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

          // State: Error Umum Lainnya
          if (controller.errorMessage.value.isNotEmpty) {
            return SafeArea(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Container(
                    padding: EdgeInsets.all(24.w),
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.error_outline, color: Colors.red, size: 60.r),
                        SizedBox(height: 16.h),
                        GlobalText.bold(
                          "Terjadi Kesalahan",
                          fontSize: 18.sp,
                          color: Colors.black,
                        ),
                        SizedBox(height: 8.h),
                        GlobalText.regular(
                          controller.errorMessage.value,
                          color: Colors.grey.shade600,
                          fontSize: 13.sp,
                        ),
                        SizedBox(height: 24.h),
                        GlobalButton(
                          text: "Coba Lagi",
                          height: 45.h,
                          onPressed: () => controller.initiateQuiz(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

          // State: Sukses (Kuis Berjalan)
          return SafeArea(
            child: Container(
              color: AppColors.c5,
              child: const QuizAttemptBody(),
            ),
          );
        }),
        endDrawer: const QuestionNavigationDrawer(),
      ),
    );
  }
}
