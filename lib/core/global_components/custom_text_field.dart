import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? icon; // <- ubah jadi nullable
  final TextInputType keyboardType;
  final bool enabled;

  final String? title;
  final Color? fillColor;
  final Color? textColor;
  final Color? hintColor;
  final Color? iconColor;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.icon, // <- nullable
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.title,
    this.fillColor,
    this.textColor,
    this.hintColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8.h),
        ],
        TextField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: icon != null
                ? Icon(icon, color: iconColor ?? Colors.grey)
                : null,
            hintText: hintText,
            hintStyle: TextStyle(color: hintColor ?? Colors.grey.shade500),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: fillColor ?? const Color(0xFFF5F6FA),
          ),
          style: TextStyle(
            fontSize: 14.sp,
            color: textColor ?? Colors.black,
          ),
        ),
      ],
    );
  }
}
