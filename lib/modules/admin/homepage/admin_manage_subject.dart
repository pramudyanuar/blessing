import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:blessing/core/global_components/global_button.dart';
import 'package:blessing/core/global_components/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ManageSubject extends StatelessWidget {
  const ManageSubject({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController subjectController = TextEditingController();

    return BaseWidgetContainer(
      backgroundColor: AppColors.c5,
      appBar: AppBar(
        centerTitle: false,
        title: GlobalText.semiBold("Buat Mata Pelajaran", fontSize: 16.sp),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subject Name Input Field
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: CustomTextField(
                controller: subjectController,
                title: "Nama Mata Pelajaran",
                hintText: "Matematika",
                fillColor: Colors.white,
                borderColor: Colors.grey.shade300,
              ),
            ),
            
            SizedBox(height: 10.h),

            // Create Subject Button
            GlobalButton(
              text: "Buat Mata Pelajaran",
              width: double.infinity,
              height: 48,
              fontSize: 14,
              borderRadius: 8,
              onPressed: () {
                // Handle create subject action
              },
            ),
          ],
        ),
      ),
    );
  }
}
