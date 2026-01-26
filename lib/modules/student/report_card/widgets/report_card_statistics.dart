import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReportCardStatistics extends StatelessWidget {
  final Map<String, dynamic> statistics;

  const ReportCardStatistics({
    super.key,
    required this.statistics,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.c2, AppColors.c2.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.c2.withOpacity(0.3),
            blurRadius: 10.r,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics_outlined,
                color: Colors.white,
                size: 24.sp,
              ),
              SizedBox(width: 8.w),
              GlobalText.bold(
                'Statistik Report Card',
                fontSize: 16.sp,
                color: Colors.white,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Kuis',
                  statistics['totalQuizzes']?.toString() ?? '0',
                  Icons.quiz_outlined,
                  Colors.white,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildStatCard(
                  'Dikerjakan',
                  statistics['attemptedQuizzes']?.toString() ?? '0',
                  Icons.check_circle_outline,
                  Colors.green.shade300,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Rata-rata Nilai',
                  '${statistics['averageScore']?.toStringAsFixed(1) ?? '0'}%',
                  Icons.grade_outlined,
                  Colors.yellow.shade300,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildStatCard(
                  'Tingkat Selesai',
                  '${statistics['completionRate']?.toStringAsFixed(1) ?? '0'}%',
                  Icons.trending_up_outlined,
                  Colors.orange.shade300,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color iconColor) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 20.sp,
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: GlobalText.medium(
                  title,
                  fontSize: 12.sp,
                  color: Colors.white.withOpacity(0.9),
                  maxLines: 1,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          GlobalText.bold(
            value,
            fontSize: 18.sp,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
