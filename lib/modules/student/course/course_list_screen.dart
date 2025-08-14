// lib/modules/student/course/course_list_screen.dart

import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/core/global_components/subject_appbar.dart';
import 'package:blessing/core/utils/app_routes.dart';
import 'package:blessing/modules/student/course/controllers/course_list_controller.dart';
import 'package:blessing/modules/student/course/widgets/course_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CourseListScreen extends StatelessWidget {
  const CourseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Gunakan Get.put jika controller belum di-binding di tempat lain
    // Jika sudah, Get.find() tidak masalah.
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
      body: Obx(
        () {
          // Tampilkan loading indicator saat data sedang dimuat
          if (controller.isLoading.value && controller.displayItems.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // Tampilkan pesan jika data kosong setelah selesai loading
          if (!controller.isLoading.value && controller.displayItems.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada materi atau kuis untuk mata pelajaran ini.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          // Tampilkan daftar course jika data tersedia
          return RefreshIndicator(
            onRefresh: () => controller.loadCourseData(),
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
              itemCount: controller.displayItems.length,
              itemBuilder: (context, index) {
                final item = controller.displayItems[index] as Map<String, dynamic>;
                final type = item['type'] as CourseContentType;

                if (type == CourseContentType.material) {
                  return CourseCard(
                    type: CourseContentType.material,
                    title: item['title'],
                    dateText: item['dateText'],
                    description: item['description'],
                    fileName: item['fileName'],
                    previewImages: item['previewImages'],
                    onTapAction: () {
                      print("Melihat detail materi: ${item['title']}");
                      Get.toNamed(AppRoutes.courseDetail, arguments: {'courseId': item['id']});
                    },
                  );
                } else {
                  return CourseCard(
                    type: CourseContentType.quiz,
                    title: item['title'],
                    dateText: item['dateText'],
                    description: item['description'],
                    timeLimit: item['timeLimit'],
                    questionCount: item['questionCount'],
                    isCompleted: item['isCompleted'],
                    score: item['score'],
                    onTapAction: () {
                      if (!(item['isCompleted'] as bool)) {
                        print("Memulai kuis: ${item['title']}");
                        Get.toNamed(AppRoutes.quizAttempt, arguments: {'quizId': item['id']});
                      }
                    },
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}