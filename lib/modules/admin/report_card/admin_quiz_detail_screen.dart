import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:blessing/data/report/model/response/quiz_report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AdminQuizDetailScreen extends StatelessWidget {
  const AdminQuizDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quiz = Get.arguments as QuizReport?;

    if (quiz == null) {
      return BaseWidgetContainer(
        appBar: AppBar(
          title: GlobalText.semiBold('Detail Quiz', fontSize: 18.sp),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Get.back(),
          ),
        ),
        body: const Center(
          child: Text('Data quiz tidak ditemukan'),
        ),
      );
    }

    return BaseWidgetContainer(
      backgroundColor: AppColors.c5,
      appBar: AppBar(
        title: GlobalText.semiBold(
          'Detail Quiz',
          fontSize: 18.sp,
          color: AppColors.c2,
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.c2.withOpacity(0.8),
                    AppColors.c2.withOpacity(0.4),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlobalText.semiBold(
                    quiz.quizName,
                    fontSize: 20.sp,
                    color: Colors.white,
                  ),
                  SizedBox(height: 8.h),
                  GlobalText.regular(
                    quiz.subjectName,
                    fontSize: 14.sp,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  SizedBox(height: 16.h),
                  // Score Display
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GlobalText.regular(
                              'Nilai',
                              fontSize: 12.sp,
                              color: Colors.white.withOpacity(0.8),
                            ),
                            GlobalText.semiBold(
                              '${quiz.score ?? 0}',
                              fontSize: 24.sp,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GlobalText.regular(
                              'Nilai',
                              fontSize: 12.sp,
                              color: Colors.white.withOpacity(0.8),
                            ),
                            GlobalText.semiBold(
                              '${quiz.score ?? 0}',
                              fontSize: 18.sp,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // Information Section
            GlobalText.semiBold(
              'Informasi',
              fontSize: 16.sp,
              color: Colors.black87,
            ),
            SizedBox(height: 16.h),

            _buildInfoCard(
              icon: Icons.calendar_today,
              label: 'Tanggal Selesai',
              value: quiz.completedAt != null
                  ? DateFormat('dd MMM yyyy HH:mm').format(quiz.completedAt!)
                  : 'Belum selesai',
            ),

            SizedBox(height: 12.h),

            _buildInfoCard(
              icon: Icons.book,
              label: 'Nama Kuis',
              value: quiz.quizName,
            ),

            SizedBox(height: 12.h),

            _buildInfoCard(
              icon: Icons.assessment,
              label: 'Status',
              value: (quiz.score ?? 0) >= 75 ? 'Lulus' : 'Belum Lulus',
              valueColor:
                  (quiz.score ?? 0) >= 75 ? Colors.green : Colors.orange,
            ),

            SizedBox(height: 24.h),

            // Statistics
            GlobalText.semiBold(
              'Statistik',
              fontSize: 16.sp,
              color: Colors.black87,
            ),
            SizedBox(height: 16.h),

            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.check_circle,
                    label: 'Nilai Akhir',
                    value: '${quiz.score ?? 0}',
                    color: Colors.green,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.access_time,
                    label: 'Durasi Kuis',
                    value: '${quiz.timeLimit} menit',
                    color: Colors.blue,
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.subject,
                    label: 'Mata Pelajaran',
                    value: quiz.subjectName,
                    color: AppColors.c2,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.school,
                    label: 'Kursus',
                    value: quiz.courseName,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),

            SizedBox(height: 24.h),

            // Action Button
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.c2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                onPressed: () {
                  // TODO: Navigate to answer review screen
                  Get.snackbar(
                    'Review Jawaban',
                    'Fitur review jawaban segera hadir',
                    duration: const Duration(seconds: 2),
                  );
                },
                icon: Icon(Icons.preview, size: 20.sp),
                label: GlobalText.semiBold(
                  'LIHAT REVIEW JAWABAN',
                  fontSize: 14.sp,
                  color: Colors.white,
                ),
              ),
            ),

            SizedBox(height: 16.h),

            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.c2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                onPressed: () {
                  // TODO: Export functionality
                  Get.snackbar(
                    'Export',
                    'Fitur export segera hadir',
                    duration: const Duration(seconds: 2),
                  );
                },
                icon: Icon(Icons.download, color: AppColors.c2, size: 20.sp),
                label: GlobalText.semiBold(
                  'EXPORT PDF',
                  fontSize: 14.sp,
                  color: AppColors.c2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.c2.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            padding: EdgeInsets.all(8.w),
            child: Icon(icon, color: AppColors.c2, size: 20.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GlobalText.medium(
                  label,
                  fontSize: 12.sp,
                  color: Colors.grey.shade600,
                ),
                SizedBox(height: 4.h),
                GlobalText.semiBold(
                  value,
                  fontSize: 14.sp,
                  color: valueColor ?? Colors.black87,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24.sp),
          SizedBox(height: 8.h),
          GlobalText.semiBold(
            value,
            fontSize: 18.sp,
            color: color,
          ),
          SizedBox(height: 4.h),
          GlobalText.regular(
            label,
            fontSize: 11.sp,
            color: Colors.grey.shade600,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
