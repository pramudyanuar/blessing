import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:blessing/modules/admin/report_card/controller/admin_report_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AdminAnalyticsSummary extends StatelessWidget {
  const AdminAnalyticsSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminReportCardController>();

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlobalText.semiBold(
            "Ringkasan Analytics",
            fontSize: 16.sp,
          ),
          SizedBox(height: 16.h),
          Obx(() => Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.quiz,
                      title: "Total Quiz",
                      value: "${controller.totalQuizzes}",
                      color: AppColors.c2,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.check_circle,
                      title: "Selesai",
                      value: "${controller.completedQuizzes}",
                      color: Colors.green,
                    ),
                  ),
                ],
              )),
          SizedBox(height: 12.h),
          Obx(() => Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.trending_up,
                      title: "Rata-rata",
                      value: controller.averageScore.toStringAsFixed(1),
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.subject,
                      title: "Mata Pelajaran",
                      value: "${controller.subjectBreakdown.length}",
                      color: Colors.purple,
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24.w,
          ),
          SizedBox(height: 8.h),
          GlobalText.semiBold(
            value,
            fontSize: 18.sp,
            color: color,
          ),
          SizedBox(height: 4.h),
          GlobalText.regular(
            title,
            fontSize: 12.sp,
            color: Colors.grey[600]!,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
