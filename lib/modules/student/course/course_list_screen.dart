// lib/modules/student/course/course_list_screen.dart

import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/core/global_components/subject_appbar.dart';
import 'package:blessing/modules/student/course/controllers/course_list_controller.dart';
import 'package:blessing/modules/student/course/widgets/course_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CourseListScreen extends StatelessWidget {
  const CourseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CourseListController>();

    return BaseWidgetContainer(
      backgroundColor: AppColors.c5,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120.h),
        child: Obx(() => SubjectAppbar(
              title: controller.title.value,
              classLevel: controller.classLevel.value,
              imagePath: controller.imagePath.value,
            )),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 10.h, top: 10.h),
        child: Obx(
          () => ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.courses.length,
            itemBuilder: (context, index) {
              final course = controller.courses[index];
              switch (course.cardType) {
                case CardType.material:
                  return CourseCard.material(
                    title: course.title,
                    dateText: course.dateText,
                    description: course.description!,
                    fileName: course.fileName,
                    previewImages: course.previewImages,
                    onTapDetail: course.onTapDetail,
                  );
                case CardType.quiz:
                  return CourseCard.quiz(
                    title: course.title,
                    dateText: course.dateText,
                    quizDetails: course.quizDetails!,
                    isCompleted: course.isCompleted,
                    score: course.score,
                    onStart: course.onStart,
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}
