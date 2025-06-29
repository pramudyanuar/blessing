import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'global_text.dart';

class SubjectAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final String classLevel;
  final String imagePath;
  final VoidCallback? onBack;

  const SubjectAppbar({
    super.key,
    required this.title,
    required this.subtitle,
    required this.classLevel,
    required this.imagePath,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(180.h),
      child: SafeArea(
        child: Stack(
          children: [
            Container(
              height: 165.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF005BD4),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 20.h,
              left: 16.w,
              child: GestureDetector(
                onTap: onBack ?? () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              ),
            ),
            Positioned(
              top: 60.h,
              left: 16.w,
              right: 16.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlobalText.bold(
                    title,
                    fontSize: 20,
                    color: Colors.white,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 4.h),
                  GlobalText.regular(
                    subtitle,
                    fontSize: 14,
                    color: Colors.white,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: GlobalText.medium(
                      classLevel,
                      fontSize: 12,
                      color: Colors.white,
                      textAlign: TextAlign.left,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(180.h);
}
