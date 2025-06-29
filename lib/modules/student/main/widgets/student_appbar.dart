import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      backgroundColor: AppColors.c1,
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.1),
      toolbarHeight: 65.h,
      title: Row(
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
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(65.h);
}
