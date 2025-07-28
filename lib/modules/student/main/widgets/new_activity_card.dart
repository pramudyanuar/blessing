import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String contentTitle;
  final IconData icon;
  final bool isRead;

  const NotificationCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.contentTitle,
    required this.icon,
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: 170.w,
        maxHeight: 120.h,
      ),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isRead ? Colors.grey[300] : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: isRead ? Colors.white70 : AppColors.c2,
                    size: 20.sp,
                  ),
                  SizedBox(width: 4.w),
                  GlobalText.bold(
                    title,
                    fontSize: 12.sp,
                    color: isRead ? Colors.white70 : AppColors.c2,
                    fontFamily: 'Inter',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              const Spacer(),
              GlobalText.medium(
                subtitle,
                fontSize: 10.sp,
                color: isRead ? Colors.white70 : AppColors.c2,
                fontFamily: 'Inter',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          SizedBox(height: 15.h),
          GlobalText.bold(
            contentTitle,
            fontSize: 20.sp, // Diperbesar
            color: isRead ? Colors.white : AppColors.c2,
            fontFamily: 'Inter',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
