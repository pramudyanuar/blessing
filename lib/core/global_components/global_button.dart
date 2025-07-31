import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GlobalButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double width;
  final double height;
  final bool isLoading;
  final Color? color;
  final double borderRadius; // <-- Tambahkan parameter baru

  const GlobalButton({
    super.key,
    required this.text,
    this.onPressed,
    this.width = 300,
    this.height = 60,
    this.isLoading = false,
    this.color,
    this.borderRadius = 10, // <-- Default radius
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width.w,
      height: height.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.c2,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(borderRadius.r), // <-- Gunakan parameter
          ),
          elevation: 0,
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(scale: animation, child: child),
            );
          },
          child: isLoading
              ? SizedBox(
                  key: const ValueKey('loading'),
                  width: 24.w,
                  height: 24.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : GlobalText.medium(
                  text,
                  key: const ValueKey('text'),
                  fontSize: 18,
                  color: Colors.white,
                  fontFamily: 'Inter',
                ),
        ),
      ),
    );
  }
}
