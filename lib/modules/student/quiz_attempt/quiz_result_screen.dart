import 'package:blessing/core/constants/color.dart';
import 'package:blessing/modules/student/quiz_attempt/widgets/youtube_player_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:get/get.dart';

class QuizResultScreen extends StatelessWidget {
  const QuizResultScreen({super.key});

  static const String videoId = 'dQw4w9WgXcQ';

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
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
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // Container Pembahasan Kuis
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlobalText.semiBold("Pembahasan Kuis", fontSize: 16.sp),
                  SizedBox(height: 12.h),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const YoutubePlayerScreen(),
                        ),
                      );
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.network(
                            'https://img.youtube.com/vi/$videoId/hqdefault.jpg',
                            width: double.infinity,
                            height: 200.h,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                width: double.infinity,
                                height: 200.h,
                                color: Colors.grey.shade200,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: double.infinity,
                                height: 200.h,
                                color: Colors.grey.shade200,
                                child:
                                    const Icon(Icons.error, color: Colors.red),
                              );
                            },
                          ),
                        ),
                        Container(
                          width: 60.w,
                          height: 60.h,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.play_arrow,
                              color: Colors.white, size: 30.sp),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  GlobalText.regular(
                    "Tonton pembahasan lengkap untuk memahami jawaban yang benar dan meningkatkan pemahamanmu.",
                    maxLines: 5,
                    textAlign: TextAlign.justify,
                    fontSize: 14.sp,
                    color: Colors.grey.shade600,
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
