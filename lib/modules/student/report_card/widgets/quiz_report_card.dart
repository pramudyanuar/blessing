import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:blessing/data/report/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuizReportCard extends StatelessWidget {
  final QuizReport quiz;
  final Color Function(int?) getScoreColor;
  final Color Function(String) getStatusColor;
  final String Function(QuizReport) getStatusText;
  final String Function(DateTime?) formatDate;
  final String Function(int) formatTime;

  const QuizReportCard({
    super.key,
    required this.quiz,
    required this.getScoreColor,
    required this.getStatusColor,
    required this.getStatusText,
    required this.formatDate,
    required this.formatTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10.r,
            offset: Offset(0, 2.h),
          ),
        ],
        border: Border.all(
          color: getStatusColor(quiz.status).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GlobalText.bold(
                        quiz.quizName,
                        fontSize: 16.sp,
                        color: AppColors.c2,
                        maxLines: 2,
                      ),
                      SizedBox(height: 4.h),
                      GlobalText.medium(
                        quiz.courseName,
                        fontSize: 13.sp,
                        color: Colors.black87,
                        maxLines: 1,
                      ),
                      SizedBox(height: 2.h),
                      GlobalText.regular(
                        quiz.subjectName,
                        fontSize: 12.sp,
                        color: Colors.grey.shade600,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                // Status Badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: getStatusColor(quiz.status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(
                      color: getStatusColor(quiz.status).withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: GlobalText.medium(
                    getStatusText(quiz),
                    fontSize: 10.sp,
                    color: getStatusColor(quiz.status),
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            // Quiz Info
            Row(
              children: [
                Icon(
                  Icons.timer_outlined,
                  size: 16.sp,
                  color: Colors.grey.shade600,
                ),
                SizedBox(width: 4.w),
                GlobalText.regular(
                  'Durasi: ${formatTime(quiz.timeLimit)}',
                  fontSize: 12.sp,
                  color: Colors.grey.shade600,
                ),
                SizedBox(width: 16.w),
                if (quiz.isAttempted) ...[
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 16.sp,
                    color: Colors.grey.shade600,
                  ),
                  SizedBox(width: 4.w),
                  GlobalText.regular(
                    'Selesai: ${formatDate(quiz.completedAt)}',
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                  ),
                ],
              ],
            ),

            if (quiz.isAttempted && quiz.score != null) ...[
              SizedBox(height: 12.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: getScoreColor(quiz.score).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: getScoreColor(quiz.score).withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.grade_outlined,
                          size: 20.sp,
                          color: getScoreColor(quiz.score),
                        ),
                        SizedBox(width: 8.w),
                        GlobalText.medium(
                          'Nilai',
                          fontSize: 14.sp,
                          color: getScoreColor(quiz.score),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        GlobalText.bold(
                          '${quiz.score}',
                          fontSize: 18.sp,
                          color: getScoreColor(quiz.score),
                        ),
                        GlobalText.medium(
                          '/100',
                          fontSize: 14.sp,
                          color: getScoreColor(quiz.score).withValues(alpha: 0.7),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],

            if (!quiz.isAttempted) ...[
              SizedBox(height: 12.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16.sp,
                      color: Colors.grey.shade600,
                    ),
                    SizedBox(width: 8.w),
                    GlobalText.regular(
                      'Kuis belum dikerjakan',
                      fontSize: 12.sp,
                      color: Colors.grey.shade600,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
