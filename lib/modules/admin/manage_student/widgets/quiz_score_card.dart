import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuizScoreCard extends StatelessWidget {
  final String title;
  final int score;

  const QuizScoreCard({
    super.key,
    required this.title,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.c5,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.emoji_events, size: 16.sp, color: Colors.grey),
              SizedBox(width: 8.w),
              GlobalText.medium(title, fontSize: 14.sp),
            ],
          ),
          GlobalText.semiBold(score.toString(), fontSize: 14.sp),
        ],
      ),
    );
  }
}
