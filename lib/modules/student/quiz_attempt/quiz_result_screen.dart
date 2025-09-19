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
    final int score = args['result'] ?? 0;

    return BaseWidgetContainer(
      backgroundColor: AppColors.c5,
      appBar: AppBar(
        centerTitle: false,
        title: GlobalText.semiBold("Hasil Kuis", fontSize: 16.sp),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Container Nilai
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  GlobalText.bold(
                    quizName,
                    fontSize: 24.sp,
                    color: const Color(0xFF1976D2),
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    width: 60.w,
                    height: 60.h,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8F5E8),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check, color: Colors.green, size: 30.sp),
                  ),
                  SizedBox(height: 20.h),
                  GlobalText.semiBold("Skor Kamu", fontSize: 16.sp),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      GlobalText.bold(
                        "$score",
                        fontSize: 36.sp,
                        color: const Color(0xFF1976D2),
                      ),
                      GlobalText.medium("/100",
                          fontSize: 18.sp, color: Colors.grey),
                    ],
                  ),
                  SizedBox(height: 30.h),
                  // Tombol Kembali ke Menu Utama
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Get.offAllNamed(AppRoutes.studentMenu),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1976D2),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: GlobalText.semiBold(
                        "Kembali ke Menu Utama",
                        fontSize: 16.sp,
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
    );
  }
}
