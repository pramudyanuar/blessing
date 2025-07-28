import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:blessing/core/global_components/global_text.dart';

class UserCard extends StatelessWidget {
  final String userName;
  final String userClass;
  final String avatarUrl;
  final VoidCallback? onTap;
  final VoidCallback? onOptionsTap;

  const UserCard({
    super.key,
    required this.userName,
    required this.userClass,
    this.avatarUrl = '',
    this.onTap,
    this.onOptionsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
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
                // Avatar Lingkaran
                Container(
                  width: 42.r,
                  height: 42.r,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    shape: BoxShape.circle,
                    image: avatarUrl.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(avatarUrl),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: avatarUrl.isEmpty
                      ? Icon(
                          Icons.person,
                          color: Colors.blue.shade700,
                          size: 24.r,
                        )
                      : null,
                ),

                SizedBox(width: 16.w),

                // Nama dan Kelas
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GlobalText.semiBold(
                        userName,
                        fontSize: 15,
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: 2.h),
                      GlobalText.medium(
                        userClass,
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),

                // Ikon Opsi
                InkWell(
                  onTap: onOptionsTap,
                  borderRadius: BorderRadius.circular(16.r),
                  child: Padding(
                    padding: EdgeInsets.all(4.r),
                    child: Icon(
                      Icons.more_vert,
                      color: Colors.grey.shade500,
                      size: 20.r,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
