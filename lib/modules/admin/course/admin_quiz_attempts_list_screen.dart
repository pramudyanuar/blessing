import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/global_components/base_widget_container.dart';
import '../../../core/global_components/global_text.dart';
import '../../../core/constants/color.dart';
import '../../../modules/student/quiz_attempt/widgets/attempt_list_item.dart';
import 'admin_quiz_attempts_list_controller.dart';

class AdminQuizAttemptsListScreen extends GetView<AdminQuizAttemptsListController> {
  const AdminQuizAttemptsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseWidgetContainer(
      backgroundColor: AppColors.c5,
      appBar: AppBar(
        centerTitle: false,
        title: GlobalText.semiBold(
          "Daftar Attempt - ${controller.quizName}",
          fontSize: 14.sp,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: Obx(
        () {
          if (controller.isLoading.value && controller.attempts.isEmpty) {
            return Center(
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
                  ElevatedButton(
                    onPressed: () => controller.loadAttempts(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.c2,
                    ),
                    child: GlobalText.semiBold(
                      "Coba Lagi",
                      fontSize: 14.sp,
                      color: Colors.white,
                    ),
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
                    "Belum ada attempt untuk quiz ini",
                    fontSize: 14.sp,
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
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: AppColors.c2.withValues(alpha: 0.3),
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
                          fontSize: 12.sp,
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
                            ElevatedButton.icon(
                              onPressed: controller.hasPreviousPage
                                  ? () => controller.loadPreviousPage()
                                  : null,
                              icon: const Icon(Icons.arrow_back),
                              label: GlobalText.semiBold(
                                "Sebelumnya",
                                fontSize: 12.sp,
                                color: Colors.white,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.c2,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            ElevatedButton.icon(
                              onPressed: controller.hasNextPage
                                  ? () => controller.loadNextPage()
                                  : null,
                              icon: const Icon(Icons.arrow_forward),
                              label: GlobalText.semiBold(
                                "Berikutnya",
                                fontSize: 12.sp,
                                color: Colors.white,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.c2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: 20.h),
              ],
            ),
          );
        },
      ),
    );
  }
}
