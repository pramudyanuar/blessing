import 'package:blessing/core/global_components/global_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'class_card.dart';

class ClassList extends StatelessWidget {
  const ClassList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlobalText.bold(
          "Mata Pelajaran",
          fontSize: 16.sp,
          color: Colors.black,
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 16.h),
        Column(
          children: [
            ClassCard.matematikaMinat(),
            ClassCard.matematikaWajib(),
            ClassCard.kimia(),
            ClassCard.akuntansi(),
            ClassCard.fisika(),
            ClassCard.biologi(),
            ClassCard.ekonomi(),
          ],
        ),
      ],
    );
  }
}
