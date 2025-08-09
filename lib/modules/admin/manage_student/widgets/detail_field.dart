import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailField extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String value;
  final bool isEdit;
  final Function(String) onChanged;

  const DetailField({
    super.key,
    this.icon,
    required this.title,
    required this.value,
    required this.isEdit,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController(text: value);

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16.sp, color: Colors.grey),
                SizedBox(width: 6.w),
              ],
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          CustomTextField(
            controller: textController,
            hintText: title,
            enabled: isEdit,
            fillColor: isEdit ? Colors.white : AppColors.c5,
            borderColor: isEdit ? AppColors.c2 : Colors.transparent,
          ),
        ],
      ),
    );
  }
}
