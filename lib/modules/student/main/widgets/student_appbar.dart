import 'package:blessing/core/global_components/global_text.dart';
import 'package:blessing/core/utils/app_routes.dart'; // <-- 1. IMPORT RUTE
import 'package:blessing/modules/student/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart'; // <-- 2. IMPORT GET

class StudentAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final String classInfo;
  final String profileImageUrl;

  const StudentAppBar({
    super.key,
    required this.name,
    required this.classInfo,
    required this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.4),
      toolbarHeight: 65.h,
      // 3. Bungkus Row dengan GestureDetector
      title: GestureDetector(
        onTap: () {
          // 4. Aksi saat di-tap: navigasi ke halaman profil
          Get.toNamed(AppRoutes.profile, arguments: {
              'mode': ProfileMode.edit,
            },
          );
        },
        // Tambahkan ini agar area tap lebih responsif
        behavior: HitTestBehavior.opaque,
        child: Row(
          children: [
            CircleAvatar(
              radius: 20.r,
              backgroundImage: NetworkImage(profileImageUrl),
            ),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GlobalText.bold(
                  'Hi, $name!',
                  fontSize: 14,
                  color: Colors.black,
                  fontFamily: 'Inter',
                ),
                GlobalText.regular(
                  classInfo,
                  fontSize: 12,
                  color: Colors.grey,
                  fontFamily: 'Inter',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(65.h);
}
