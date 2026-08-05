// lib/modules/student/quiz_attempt/quiz_attempts_list_screen.dart

import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:blessing/core/global_components/global_button.dart';
import 'package:blessing/modules/student/quiz_attempt/controller/quiz_attempts_list_controller.dart';
import 'package:blessing/modules/student/quiz_attempt/widgets/attempt_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class QuizAttemptsListScreen extends GetView<QuizAttemptsListController> {
  const QuizAttemptsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseWidgetContainer(
      backgroundColor: AppColors.c5,
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.c2),
          onPressed: () => Get.back(),
        ),
        title: GlobalText.bold(
          "Daftar Attempt - ${controller.quizName}",
          fontSize: 16.sp,
          color: Colors.black,
          fontFamily: 'Inter',
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 3,
        shadowColor: Colors.black.withValues(alpha: 0.4),
        toolbarHeight: 65.h,
      ),
      body: Obx(
        () {
          if (controller.isLoading.value && controller.attempts.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.c2,
              ),
            );
          }

          if (controller.errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48.sp,
                    color: Colors.red,
                  ),
                  SizedBox(height: 16.h),
                  GlobalText.medium(
                    controller.errorMessage.value,
                    fontSize: 14.sp,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.h),
                  GlobalButton(
                    text: "Coba Lagi",
                    width: 140.w,
                    onPressed: () => controller.loadAttempts(),
                  ),
                ],
              ),
            );
          }

          if (controller.attempts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history_outlined,
                    size: 48.sp,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16.h),
                  GlobalText.medium(
                    "Belum ada attempt untuk kuis ini",
                    fontSize: 14.sp,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info section
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppColors.c3.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: AppColors.c3.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.c2,
                        size: 20.sp,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: GlobalText.medium(
                          "Total attempt: ${controller.attempts.length}",
                          fontSize: 13.sp,
                          color: AppColors.c2,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),

                // List of attempts
                ...List.generate(
                  controller.attempts.length,
                  (index) {
                    final attempt = controller.attempts[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: AttemptListItem(
                        attempt: attempt,
                        attemptNumber: index + 1,
                        onTap: () => controller.viewAttemptDetail(attempt),
                      ),
                    );
                  },
                ),

                // Pagination info
                if (controller.paging.totalPage > 1)
                  Padding(
                    padding: EdgeInsets.only(top: 16.h),
                    child: Column(
                      children: [
                        GlobalText.medium(
                          "Halaman ${controller.currentPage.value} dari ${controller.paging.totalPage}",
                          fontSize: 12.sp,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (controller.currentPage.value > 1)
                              ElevatedButton.icon(
                                onPressed: () =>
                                    controller.loadPreviousPage(),
                                icon: const Icon(Icons.chevron_left, color: Colors.white),
                                label: GlobalText.semiBold("Sebelumnya", fontSize: 13.sp, color: Colors.white),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.c2,
                                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                              ),
                            SizedBox(width: 12.w),
                            if (controller.hasNextPage)
                              ElevatedButton.icon(
                                onPressed: () =>
                                    controller.loadNextPage(),
                                icon: const Icon(Icons.chevron_right, color: Colors.white),
                                label: GlobalText.semiBold("Berikutnya", fontSize: 13.sp, color: Colors.white),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.c2,
                                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
