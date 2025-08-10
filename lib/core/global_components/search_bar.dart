import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSearchBar extends StatelessWidget {
  final double width;
  final double height;
  final String hintText;
  final ValueChanged<String>? onChanged; // tambahkan ini

  const CustomSearchBar({
    super.key,
    this.width = 358,
    this.height = 50,
    this.hintText = "Cari Mata Pelajaran/kuis",
    this.onChanged, // tambahkan ini
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.w,
      height: height.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            spreadRadius: 1,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: Colors.grey,
            size: 20.r,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 14.sp,
                ),
                border: InputBorder.none,
              ),
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.sp,
              ),
              onChanged: onChanged, // hubungkan di sini
            ),
          ),
        ],
      ),
    );
  }
}
