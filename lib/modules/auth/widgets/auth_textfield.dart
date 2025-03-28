import 'package:blessing/core/global_components/global_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final bool isPassword;

  const AuthTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlobalText.bold(
          label,
          fontSize: 16,
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(25.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            obscureText: isPassword,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey,
              ),
              filled: true,
              fillColor: Colors.transparent,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.r),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(Icons.visibility_off, color: Colors.grey),
                      onPressed: () {},
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
