// lib/modules/student/quiz_attempt/widgets/attempt_list_item.dart

import 'package:blessing/data/session/models/response/quiz_attempt_summary.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class AttemptListItem extends StatelessWidget {
  final QuizAttemptSummary attempt;
  final int attemptNumber;
  final VoidCallback onTap;

  const AttemptListItem({
    super.key,
    required this.attempt,
    required this.attemptNumber,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Handle case where totalQuestions is 0 (from admin endpoint)
    final scorePercentage = attempt.totalQuestions > 0
        ? ((attempt.correctAnswers / attempt.totalQuestions) * 100).toInt()
        : 0;
    final isSuccess = scorePercentage >= 70;
    final formattedDate =
        DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(attempt.submittedAt);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: Colors.grey.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Attempt number and date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GlobalText.semiBold(
                  "Attempt #$attemptNumber",
                  fontSize: 14.sp,
                  color: const Color(0xFF1976D2),
                ),
                GlobalText.medium(
                  formattedDate,
                  fontSize: 12.sp,
                  color: Colors.grey,
                ),
              ],
            ),
            SizedBox(height: 8.h),

            // Score and questions info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GlobalText.medium("Skor", fontSize: 11.sp, color: Colors.grey),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        GlobalText.bold(
                          "${attempt.score}",
                          fontSize: 18.sp,
                          color: const Color(0xFF1976D2),
                        ),
                        GlobalText.medium(
                          "/100",
                          fontSize: 12.sp,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ],
                ),
                // Show detailed breakdown only if totalQuestions > 0
                if (attempt.totalQuestions > 0) ...[
                  // Vertical divider
                  Container(
                    width: 1,
                    height: 40.h,
                    color: Colors.grey.withValues(alpha: 0.2),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GlobalText.medium("Benar", fontSize: 11.sp, color: Colors.grey),
                      SizedBox(height: 4.h),
                      GlobalText.bold(
                        "${attempt.correctAnswers}/${attempt.totalQuestions}",
                        fontSize: 14.sp,
                        color: isSuccess ? Colors.green : Colors.orange,
                      ),
                    ],
                  ),
                  // Vertical divider
                  Container(
                    width: 1,
                    height: 40.h,
                    color: Colors.grey.withValues(alpha: 0.2),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GlobalText.medium("Persentase", fontSize: 11.sp, color: Colors.grey),
                      SizedBox(height: 4.h),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: isSuccess
                              ? Colors.green.withValues(alpha: 0.1)
                              : Colors.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: GlobalText.bold(
                          "$scorePercentage%",
                          fontSize: 12.sp,
                          color: isSuccess ? Colors.green : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ] else
                  // Simple status when details not available
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: GlobalText.medium(
                      "Klik untuk detail",
                      fontSize: 11.sp,
                      color: Colors.blue,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 8.h),

            // View detail button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onTap,
                icon: Icon(Icons.arrow_forward, size: 16.sp),
                label: GlobalText.medium(
                  "Lihat Detail",
                  fontSize: 12.sp,
                  color: const Color(0xFF1976D2),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
