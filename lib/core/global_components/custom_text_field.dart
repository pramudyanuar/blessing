import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? icon;
  final TextInputType keyboardType;
  final bool enabled;
  final String? title;
  final Color? fillColor;
  final Color? textColor;
  final Color? hintColor;
  final Color? iconColor;
  final Color? borderColor;
  final IconButton? suffixButton;
  final bool readOnly;
  final VoidCallback? onTap;

  // --- TAMBAHAN: VALIDATOR ---
  final String? Function(String?)? validator;
  // ---------------------------

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.icon,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.title,
    this.fillColor,
    this.textColor,
    this.hintColor,
    this.iconColor,
    this.borderColor,
    this.suffixButton,
    this.readOnly = false,
    this.onTap,
    // --- TAMBAHAN DI KONSTRUKTOR ---
    this.validator,
    // --------------------------------
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
        GestureDetector(
          onTap: onTap,
          child: Stack(
            children: [
              // --- PERUBAHAN: DARI TEXTFIELD KE TEXTFORMFIELD ---
              TextFormField(
                controller: controller,
                enabled: enabled,
                keyboardType: keyboardType,
                readOnly: readOnly,
                onTap: onTap,
                // --- MENGGUNAKAN VALIDATOR ---
                validator: validator,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                // ---------------------------------
                maxLines: hintText.toLowerCase().contains("deskripsi") ? 4 : 1,
                decoration: InputDecoration(
                  prefixIcon: icon != null
                      ? Icon(icon, color: iconColor ?? Colors.grey)
                      : null,
                  hintText: hintText,
                  hintStyle:
                      TextStyle(color: hintColor ?? Colors.grey.shade500),
                  filled: true,
                  fillColor: enabled && !readOnly
                      ? (fillColor ?? const Color(0xFFF5F6FA))
                      : Colors.grey.shade200,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: borderColor ?? Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                      width: 1.5,
                    ),
                  ),
                  // Menambahkan border untuk error dan focus error
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 1,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 1.5,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                ),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: textColor ?? Colors.black,
                ),
              ),
              if (suffixButton != null)
                Positioned(
                  bottom: 8.h,
                  right: 8.w,
                  child: suffixButton!,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
