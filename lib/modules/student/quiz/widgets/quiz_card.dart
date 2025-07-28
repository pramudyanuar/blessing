import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:blessing/modules/student/quiz/controllers/quiz_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuizCard extends StatelessWidget {
  // Menerima Map sebagai data utama
  final Map<String, dynamic> quizData;
  final VoidCallback? onStartPressed;

  const QuizCard({super.key, required this.quizData, this.onStartPressed});

  @override
  Widget build(BuildContext context) {
    // Ekstrak status dari Map
    final QuizStatus status = quizData['status'];

    return Container(
      height: 60.h,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: _getBackgroundColor(status),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GlobalText.bold(quizData['title'], fontSize: 16.sp),
              SizedBox(height: 4.h),
              _buildSubtitle(status),
            ],
          ),
          _buildTrailingWidget(status),
        ],
      ),
    );
  }

  Color _getBackgroundColor(QuizStatus status) {
    switch (status) {
      case QuizStatus.available:
        return AppColors.c4.withOpacity(0.5);
      case QuizStatus.missed:
        return Colors.red.shade50;
      case QuizStatus.completed:
        return Colors.white;
    }
  }

  Widget _buildSubtitle(QuizStatus status) {
    if (status == QuizStatus.available) {
      return Row(
        children: [
          Icon(Icons.timer_outlined, size: 14.sp, color: Colors.grey.shade700),
          SizedBox(width: 4.w),
          GlobalText.regular(quizData['dueDate'] ?? '',
              fontSize: 12.sp, color: Colors.grey.shade700),
        ],
      );
    } else if (status == QuizStatus.completed) {
      return GlobalText.regular('Completed',
          fontSize: 12.sp, color: Colors.green.shade600);
    } else if (status == QuizStatus.missed) {
      return GlobalText.regular('Uncompleted',
          fontSize: 12.sp, color: Colors.red.shade600);
    }
    return const SizedBox.shrink();
  }

  Widget _buildTrailingWidget(QuizStatus status) {
    if (status == QuizStatus.available) {
      return ElevatedButton(
        onPressed: onStartPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.c2,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
          padding: EdgeInsets.symmetric(horizontal: 18.w),
        ),
        child: GlobalText.medium('Mulai', color: Colors.white),
      );
    } else if (status == QuizStatus.missed) {
      return GlobalText.medium('Tidak Mengerjakan',
          fontSize: 13.sp, color: Colors.red.shade700);
    } else {
      // Completed
      return RichText(
        text: TextSpan(
          style: TextStyle(
              fontFamily: 'Poppins', color: Colors.black, fontSize: 14.sp),
          children: [
            TextSpan(
              text: (quizData['score'] ?? 0).toString(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
            ),
            const TextSpan(text: ' /100'),
          ],
        ),
      );
    }
  }
}
