import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:blessing/core/utils/app_routes.dart';
import 'package:blessing/modules/admin/course/controllers/course_list_controller.dart';
import 'package:blessing/modules/admin/course/widgets/course_card.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AdminManageSubjectMainScreen extends StatelessWidget {
  const AdminManageSubjectMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminManageCourseListController>();
    final subjectId = Get.arguments?['subjectId'] as String?;
    final subjectName = Get.arguments?['subjectName'] as String?;
    final kelas = Get.arguments?['kelas'] as int?;

    return BaseWidgetContainer(
      backgroundColor: AppColors.c5,
      appBar: AppBar(
        title: GlobalText.semiBold(
          subjectName ?? 'Mata Pelajaran',
          fontSize: 18.sp,
          color: AppColors.c2,
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: AppColors.c2),
            onSelected: (String value) {
              if (value == 'edit_subject') {
                Get.toNamed(
                  AppRoutes.adminEditSubject,
                  arguments: {
                    'subjectId': subjectId,
                    'subjectName': subjectName,
                  },
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'edit_subject',
                child: Row(
                  children: [
                    Icon(Icons.edit, color: AppColors.c2),
                    SizedBox(width: 8),
                    Text('Edit Mata Pelajaran'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Obx(
        () {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.courses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.folder_open,
                    size: 64.sp,
                    color: Colors.grey.shade400,
                  ),
                  SizedBox(height: 16.h),
                  GlobalText.medium(
                    'Belum ada materi untuk mata pelajaran ini',
                    fontSize: 14.sp,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
            itemCount: controller.courses.length,
            itemBuilder: (context, index) {
              final courseData = controller.courses[index];
              
              // Handle both Map and CourseResponse types
              String courseId = '';
              String courseName = '';
              DateTime? createdAt;
              
              if (courseData is Map<String, dynamic>) {
                courseId = courseData['id'] ?? '';
                courseName = courseData['title'] ?? courseData['courseName'] ?? courseData['course_name'] ?? 'Tanpa Nama';
                final dateObj = courseData['dateObject'] ?? courseData['created_at'];
                if (dateObj is DateTime) {
                  createdAt = dateObj;
                } else if (dateObj is String) {
                  createdAt = DateTime.tryParse(dateObj);
                }
              } else {
                courseId = courseData.id ?? '';
                courseName = courseData.courseName ?? 'Tanpa Nama';
                createdAt = courseData.createdAt;
              }

              final dateText = createdAt != null
                  ? DateFormat('dd MMM yyyy').format(createdAt)
                  : 'Tanpa tanggal';

              return CourseCard(
                type: CourseContentType.material,
                title: courseName,
                dateText: dateText,
                onTapAction: () {
                  Get.toNamed(
                    AppRoutes.adminCourseDetail,
                    arguments: {
                      'courseId': courseId,
                      'subjectId': subjectId,
                      'kelas': kelas,
                      'subjectName': subjectName,
                    },
                  );
                },
              );
            },
          );  
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.c2,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () {
          Get.toNamed(AppRoutes.adminCreateCourse, arguments: {
            'subjectId': subjectId,
            'kelas': kelas,
            'onCourseCreated': () => controller.refreshCourses(),
          });
        },
      ),
    );
  }
}
