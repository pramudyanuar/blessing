import 'package:blessing/core/global_components/global_text.dart';
import 'package:blessing/data/report/model/response/quiz_report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class AdminQuizCard extends StatelessWidget {
  final QuizReport quiz;

  const AdminQuizCard({
    super.key,
    required this.quiz,
  });

  @override
  Widget build(BuildContext context) {
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
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GlobalText.semiBold(
                  quiz.quizName,
                  fontSize: 16.sp,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 4.h,
                ),
                decoration: BoxDecoration(
                  color: _getScoreColor(quiz.score ?? 0).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: GlobalText.semiBold(
                  "${quiz.score ?? 0}",
                  fontSize: 14.sp,
                  color: _getScoreColor(quiz.score ?? 0),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),

          // Subject and Date
          Row(
            children: [
              Icon(
                Icons.book,
                size: 16.w,
                color: Colors.grey[600],
              ),
              SizedBox(width: 6.w),
              GlobalText.regular(
                quiz.subjectName,
                fontSize: 14.sp,
                color: Colors.grey[700]!,
              ),
              SizedBox(width: 16.w),
              Icon(
                Icons.calendar_today,
                size: 16.w,
                color: Colors.grey[600],
              ),
              SizedBox(width: 6.w),
              GlobalText.regular(
                _formatDate(quiz.completedAt),
                fontSize: 14.sp,
                color: Colors.grey[700]!,
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Progress bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GlobalText.medium(
                    "Skor",
                    fontSize: 12.sp,
                    color: Colors.grey[600]!,
                  ),
                  GlobalText.medium(
                    "${quiz.score ?? 0}/100",
                    fontSize: 12.sp,
                    color: Colors.grey[700]!,
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              LinearProgressIndicator(
                value: (quiz.score ?? 0) / 100,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getScoreColor(quiz.score ?? 0),
                ),
              ),
            ],
          ),

          // Status and course info
          if (quiz.courseName.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16.w,
                  color: Colors.grey[600],
                ),
                SizedBox(width: 6.w),
                GlobalText.regular(
                  quiz.courseName,
                  fontSize: 13.sp,
                  color: Colors.grey[600]!,
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: _getStatusColor(quiz.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: GlobalText.regular(
                    quiz.status.toUpperCase(),
                    fontSize: 11.sp,
                    color: _getStatusColor(quiz.status),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 85) return Colors.green;
    if (score >= 70) return Colors.orange;
    return Colors.red;
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'in_progress':
        return Colors.orange;
      case 'not_started':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Belum selesai';
    return DateFormat('dd MMM yyyy').format(date);
  }
}
