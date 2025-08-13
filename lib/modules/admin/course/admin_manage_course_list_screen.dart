// lib/modules/admin/course/screens/course_list_screen.dart

import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/core/global_components/subject_appbar.dart';
import 'package:blessing/core/utils/app_routes.dart';
import 'package:blessing/modules/admin/course/controllers/course_list_controller.dart';
import 'package:blessing/modules/student/course/widgets/course_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';

class AdminManageCourseListScreen extends StatelessWidget {
  const AdminManageCourseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminManageCourseListController>();

    return BaseWidgetContainer(
      backgroundColor: AppColors.c5,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120.h),
        child: Obx(() => SubjectAppbar(
              title: controller.title.value,
              classLevel: controller.classLevel.value,
              imagePath: controller.imagePath.value,
              // --- PERUBAHAN DI SINI: Tambahkan action untuk edit & delete ---
              actions: [
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  onSelected: controller.handleMenuSelection,
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: AppColors.c2),
                          SizedBox(width: 8),
                          Text('Ubah Mata Pelajaran'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_forever, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Hapus Mata Pelajaran',
                              style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],

              // --- AKHIR PERUBAHAN ---
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
      floatingActionButton: SpeedDial(
        backgroundColor: AppColors.c2,
        foregroundColor: AppColors.c1,
        icon: Icons.add,
        activeIcon: Icons.close,
        spacing: 10,
        spaceBetweenChildren: 0,
        elevation: 4,
        children: [
          SpeedDialChild(
            backgroundColor: AppColors.c2,
            foregroundColor: AppColors.c1,
            labelWidget: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.c8,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.upload_file, color: AppColors.c1, size: 20.sp),
                  SizedBox(width: 6.w),
                  Text(
                    'Unggah Materi',
                    style: TextStyle(
                      color: AppColors.c1,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              Get.toNamed(AppRoutes.adminCreateCourse);
            },
          ),
          SpeedDialChild(
            backgroundColor: AppColors.c2,
            foregroundColor: AppColors.c1,
            labelWidget: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.c9,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.quiz, color: AppColors.c1, size: 20.sp),
                  SizedBox(width: 6.w),
                  Text(
                    'Buat Kuis',
                    style: TextStyle(
                      color: AppColors.c1,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              Get.toNamed(AppRoutes.adminCreateQuiz);
            },
          ),
        ],
      ),
    );
  }
}
