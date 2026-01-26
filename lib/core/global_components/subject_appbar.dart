// lib/core/global_components/subject_appbar.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'global_text.dart';

class SubjectAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String classLevel;
  final String imagePath;
  final VoidCallback? onBack;
  // --- PERUBAHAN DI SINI: Tambahkan property actions ---
  final List<Widget>? actions;
  // --- AKHIR PERUBAHAN ---

  const SubjectAppbar({
    super.key,
    required this.title,
    required this.classLevel,
    required this.imagePath,
    this.onBack,
    // --- PERUBAHAN DI SINI: Tambahkan actions ke constructor ---
    this.actions,
    // --- AKHIR PERUBAHAN ---
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(180.h),
      child: SafeArea(
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            // Background Image
            Container(
              height: 120.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF005BD4),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Back Button
            Positioned(
              top: 16.h,
              left: 8.w,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: onBack ?? () => Navigator.pop(context),
              ),
            ),
            // --- PERUBAHAN DI SINI: Tambahkan actions di pojok kanan atas ---
            if (actions != null && actions!.isNotEmpty)
              Positioned(
                top: 16.h,
                right: 8.w,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: actions!,
                ),
              ),
            // --- AKHIR PERUBAHAN ---
            // Title and Class Level
            Positioned(
              top: 50.h,
              left: 16.w,
              // Beri ruang di kanan agar tidak tumpang tindih dengan actions
              right: (actions != null && actions!.isNotEmpty) ? 60.w : 16.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlobalText.bold(
                    title,
                    fontSize: 20.sp,
                    color: Colors.white,
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
                      fontSize: 14.sp,
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
