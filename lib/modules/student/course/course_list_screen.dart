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
              final item = controller.courses[index] as Map<String, dynamic>;
              final type = item['type'] as CourseContentType;

              // Logika untuk membangun CourseCard berdasarkan tipe
              if (type == CourseContentType.material) {
                // Membuat kartu untuk Materi
                return CourseCard(
                  type: CourseContentType.material,
                  title: item['title'],
                  dateText: item['dateText'],
                  description: item['description'],
                  fileName: item['fileName'],
                  previewImages: item['previewImages'],
                  onTapAction: () {
                    print("Melihat detail materi: ${item['title']}");
                    Get.toNamed(AppRoutes.courseDetail, arguments: {'materialId': item['id']});
                  },
                );
              } else { 
                // Membuat kartu untuk Kuis
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
                    // Aksi hanya berjalan jika kuis belum selesai
                    if (!(item['isCompleted'] as bool)) {
                      print("Memulai kuis: ${item['title']}");
                      // Navigasi ke halaman pengerjaan kuis
                      Get.toNamed(AppRoutes.quizAttempt, arguments: {'quizId': item['id']});
                    }
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}