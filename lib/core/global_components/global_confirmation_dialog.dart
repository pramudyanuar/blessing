import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/constants/images.dart';
import 'package:blessing/core/global_components/global_button.dart';
import 'package:blessing/core/global_components/global_text.dart';

class GlobalConfirmationDialog extends StatelessWidget {
  final String message;
  final VoidCallback onYes;
  final VoidCallback onNo;
  final String yesText;
  final String noText;
  final Color yesColor;
  final Color noColor;

  const GlobalConfirmationDialog({
    super.key,
    required this.message,
    required this.onYes,
    required this.onNo,
    this.yesText = 'Iya',
    this.noText = 'Tidak',
    this.yesColor = AppColors.c7,
    this.noColor = AppColors.c2,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Images.confirmationDialog),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GlobalText.bold(
              message,
              fontSize: 18,
              textAlign: TextAlign.center,
              maxLines: null,
              overflow: TextOverflow.visible,
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: GlobalButton(
                    text: noText,
                    color: noColor,
                    onPressed: onNo,
                    height: 30.h,
                    borderRadius: 20.r,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: GlobalButton(
                    text: yesText,
                    color: yesColor,
                    onPressed: onYes,
                    height: 30.h,
                    borderRadius: 20.r,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
