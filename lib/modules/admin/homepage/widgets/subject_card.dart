import 'package:blessing/core/global_components/global_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubjectCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const SubjectCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              children: [
                // Lingkaran Ikon
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: Colors.blue.shade700,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 16.w),

                // Judul Mata Pelajaran (Menggunakan GlobalText)
                Expanded(
                  child: GlobalText.semiBold(
                    title,
                    fontSize: 15, // .sp sudah dihandle di dalam GlobalText
                    textAlign: TextAlign.start,
                  ),
                ),

                // Ikon Panah Kanan
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey.shade400,
                  size: 24.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
