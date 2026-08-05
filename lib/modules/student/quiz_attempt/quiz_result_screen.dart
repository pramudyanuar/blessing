import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:get/get.dart';

class QuizResultScreen extends StatelessWidget {
  const QuizResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? {};
    final String quizName = args['quizname'] ?? 'Kuis';
    final String quizId = args['quizId'] ?? '';
    final String sessionId = args['sessionId'] ?? '';
    final int score = args['result'] ?? 0;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        // Kalau perlu logic ketika pop terjadi
      },
      child: BaseWidgetContainer(
        backgroundColor: AppColors.c5,
      appBar: AppBar(
        centerTitle: false,
        title: GlobalText.bold(
          "Hasil Kuis",
          fontSize: 16.sp,
          color: Colors.black,
          fontFamily: 'Inter',
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 3,
        shadowColor: Colors.black.withValues(alpha: 0.4),
        toolbarHeight: 65.h,
        automaticallyImplyLeading: false, // Hapus back button di appbar
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Container Nilai
            Container(
              padding: EdgeInsets.all(20.w),
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
                children: [
                  GlobalText.bold(
                    quizName,
                    fontSize: 22.sp,
                    color: AppColors.c2,
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    width: 70.w,
                    height: 70.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8F5E8),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check, color: Colors.green, size: 36.sp),
                  ),
                  SizedBox(height: 20.h),
                  GlobalText.semiBold("Skor Kamu", fontSize: 16.sp, color: Colors.black87),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      GlobalText.bold(
                        "$score",
                        fontSize: 40.sp,
                        color: AppColors.c2,
                      ),
                      GlobalText.medium("/100",
                          fontSize: 18.sp, color: Colors.grey),
                    ],
                  ),
                  SizedBox(height: 30.h),
                  // Tombol View Details & View All Attempts
                  if (sessionId.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => Get.toNamed(
                          AppRoutes.quizReview,
                          arguments: {
                            'sessionId': sessionId,
                            'quizId': quizId,
                            'quizName': quizName,
                            'score': score,
                            'fetchFromServer': true,
                          },
                        ),
                        icon: const Icon(Icons.description, color: AppColors.c2),
                        label: GlobalText.semiBold(
                          "Lihat Pembahasan",
                          fontSize: 14.sp,
                          color: AppColors.c2,
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.c2,
                          side: const BorderSide(
                            color: AppColors.c2,
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                    ),
                  SizedBox(height: 12.h),
                  // Tombol View All Attempts
                  if (quizId.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => Get.toNamed(
                          AppRoutes.quizAttemptsList,
                          arguments: {
                            'quizId': quizId,
                            'quizName': quizName,
                          },
                        ),
                        icon: const Icon(Icons.history, color: AppColors.c2),
                        label: GlobalText.semiBold(
                          "Lihat Semua Attempt",
                          fontSize: 14.sp,
                          color: AppColors.c2,
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.c2,
                          side: const BorderSide(
                            color: AppColors.c2,
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                    ),
                  SizedBox(height: 12.h),
                  // Tombol Kembali ke Halaman Depan
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Get.offNamedUntil(
                        AppRoutes.studentMenu,
                        (route) => route.isFirst,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.c2,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: GlobalText.semiBold(
                        "Kembali ke Halaman Depan",
                        fontSize: 15.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
