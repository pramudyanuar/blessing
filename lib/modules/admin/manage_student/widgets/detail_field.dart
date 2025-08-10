import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:blessing/core/global_components/global_text.dart';

class DetailField extends StatelessWidget {
  final IconData icon;
  final String title;
  final TextEditingController controller;
  final bool isEdit;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;

  const DetailField({
    super.key,
    required this.icon,
    required this.title,
    required this.controller,
    required this.isEdit,
    this.readOnly = false,
    this.onTap,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.grey.shade600, size: 20.sp),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GlobalText.regular(title,
                    fontSize: 12.sp, color: Colors.grey.shade600),
                isEdit
                    ? TextFormField(
                        controller: controller,
                        readOnly: readOnly,
                        onTap: onTap,
                        keyboardType: keyboardType,
                        style: TextStyle(fontSize: 14.sp),
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 6),
                          border: UnderlineInputBorder(),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: GlobalText.medium(
                            controller.text.isEmpty ? '-' : controller.text,
                            fontSize: 14.sp),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
