// lib/modules/admin/course/screens/course_list_screen.dart

import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/core/global_components/subject_appbar.dart';
import 'package:blessing/core/utils/app_routes.dart';
import 'package:blessing/modules/admin/course/controllers/course_list_controller.dart';
import 'package:blessing/modules/admin/course/widgets/course_card.dart';
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
            )),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
            bottom: 80.h, top: 10.h), // Tambah padding bawah untuk FAB
        child: Obx(
          () {
            if (controller.courses.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text(
                    'Belum ada materi atau kuis.\nTekan tombol + untuk menambahkan.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              );
            }
            // --- PERUBAHAN UTAMA DI SINI ---
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.courses.length,
              itemBuilder: (context, index) {
                final item = controller.courses[index] as Map<String, dynamic>;
                final type = item['type'] as CourseContentType;

                // Membangun CourseCard berdasarkan tipenya
                if (type == CourseContentType.material) {
                  return CourseCard(
                    type: CourseContentType.material,
                    title: item['title'],
                    dateText: item['dateText'],
                    description: item['description'],
                    fileName: item['fileName'],
                    previewImages: item['previewImages'],
                    actionButtonText: "Lihat Materi",
                    onTapAction: () {
                      print("Navigasi ke detail materi: ${item['title']}");
                      Get.toNamed(AppRoutes.adminCourseDetail,
                          arguments: {'courseId': item['id']});
                    },
                  );
                } else {
                  // type == CourseContentType.quiz
                  return CourseCard(
                    type: CourseContentType.quiz,
                    title: item['title'],
                    dateText: item['dateText'],
                    description: item['description'],
                    timeLimit: item['timeLimit'],
                    actionButtonText: "Lihat Kuis",
                    onTapAction: () {
                      print("Navigasi ke detail kuis: ${item['title']}");
                      Get.toNamed(AppRoutes.adminCreateQuiz,
                          arguments: {'quizId': item['id']});
                    },
                  );
                }
              },
            );
          },
        ),
      ),
      floatingActionButton: buildSpeedDial(context, controller),
    );
  }

  // Helper untuk membuat SpeedDial FAB
  SpeedDial buildSpeedDial(
      BuildContext context, AdminManageCourseListController controller) {
    return SpeedDial(
      backgroundColor: AppColors.c2,
      foregroundColor: AppColors.c1,
      icon: Icons.add,
      activeIcon: Icons.close,
      spacing: 10,
      spaceBetweenChildren: 10,
      elevation: 4,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.upload_file),
          backgroundColor: AppColors.c8,
          foregroundColor: AppColors.c1,
          label: 'Unggah Materi',
          onTap: () {
            // Kirim subjectId dan kelas saat navigasi
            debugPrint(
                'Navigasi ke adminUploadCourse dengan subjectId: ${controller.subjectId} dan kelas: ${controller.kelas}');
            Get.toNamed(AppRoutes.adminCreateCourse, arguments: {
              'subjectId': controller.subjectId,
              'kelas': controller.kelas,
            });
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.quiz),
          backgroundColor: AppColors.c9,
          foregroundColor: AppColors.c1,
          label: 'Buat Kuis',
          onTap: () {
            // Kirim subjectId dan kelas saat navigasi
            Get.toNamed(AppRoutes.adminCreateQuiz, arguments: {
              'subjectId': controller.subjectId,
              'kelas': controller.kelas,
            });
          },
        ),
      ],
    );
  }
}
