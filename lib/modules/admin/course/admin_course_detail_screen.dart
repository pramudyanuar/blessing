import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/core/global_components/global_confirmation_dialog.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:blessing/core/utils/app_routes.dart';
import 'package:blessing/modules/admin/course/controllers/admin_course_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AdminCourseDetailScreen extends StatelessWidget {
  const AdminCourseDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminCourseDetailController>();

    return BaseWidgetContainer(
      appBar: AppBar(
        title: GlobalText.semiBold("Detail Materi",
            fontSize: 18.sp, color: AppColors.c2),
        backgroundColor: AppColors.c1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            if (controller.isEditing.value) {
              controller.isEditing.value = false;
            } else {
              Get.back();
            }
          },
        ),
        actions: [
          Obx(() {
            if (controller.isEditing.value) {
              return IconButton(
                icon: const Icon(Icons.check),
                onPressed: controller.saveEdits,
              );
            } else {
              return PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.r),
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, color: AppColors.c2),
                        const SizedBox(width: 8),
                        const Text('Edit Materi'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'akses',
                    child: Row(
                      children: [
                        Icon(Icons.accessibility, color: AppColors.c2),
                        const SizedBox(width: 8),
                        const Text('Akses Materi'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, color: AppColors.c7),
                        SizedBox(width: 8),
                        Text('Hapus Materi',
                            style: TextStyle(color: AppColors.c7)),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'edit') {
                    controller.startEditing();
                  } else if (value == 'akses') {
                    Get.toNamed(
                      AppRoutes.adminManageCourseAccess,
                      arguments: {
                        'courseId': controller.course.value!.id,
                        'gradeLevel': controller.course.value!.gradeLevel,
                      },
                    );
                  } else if (value == 'delete') {
                    Get.dialog(
                      GlobalConfirmationDialog(
                        message:
                            'Apakah Anda yakin ingin menghapus materi ini?',
                        onNo: () => Get.back(),
                        onYes: () {
                          controller.deleteCourse();
                        },
                      ),
                    );
                  }
                },
              );
            }
          }),
        ],
      ),
      backgroundColor: AppColors.c1,
      body: Obx(() {
        final index = controller.selectedIndex.value;
        if (index == 0) {
          if (controller.isLoading.value && controller.course.value == null) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.c2));
          }
          if (controller.course.value == null) {
            return Center(
                child: GlobalText.regular('Data tidak ditemukan',
                    color: AppColors.c2));
          }
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: controller.isEditing.value
                ? _buildEditMode(controller)
                : _buildViewMode(controller),
          );
        } else {
          if (controller.isQuizLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.c2),
            );
          }
          return _buildQuizSection(controller);
        }
      }),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: controller.selectedIndex.value,
            onTap: (i) => controller.selectedIndex.value = i,
            selectedItemColor: AppColors.c2,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.menu_book_outlined),
                label: 'Materi',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.quiz_outlined),
                label: 'Kuis',
              ),
            ],
          )),
    );
  }

  Widget _buildViewMode(AdminCourseDetailController controller) {
    final course = controller.course.value!;
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4,
            shadowColor: Colors.black.withOpacity(0.1),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlobalText.bold(course.courseName ?? 'Tanpa Judul',
                      fontSize: 22.sp, color: AppColors.c2),
                  SizedBox(height: 12.h),
                  _buildInfoRow(
                      icon: Icons.class_outlined,
                      text: 'Kelas: ${course.gradeLevel}'),
                  SizedBox(height: 8.h),
                  _buildInfoRow(
                      icon: Icons.book_outlined,
                      text:
                          'Mata Pelajaran: ${course.subject?.subjectName ?? 'N/A'}'),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.h),
          GlobalText.semiBold("Isi Materi",
              fontSize: 18.sp, color: AppColors.c2),
          SizedBox(height: 12.h),
          ...course.content!.map((content) {
            if (content.type == 'text') {
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: GlobalText.regular(
                  content.data,
                  textAlign: TextAlign.justify,
                  fontSize: 15.sp,
                  color: AppColors.c2,
                  lineHeight: 1.5,
                ),
              );
            } else if (content.type == 'image') {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.network(
                    content.data,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildQuizSection(AdminCourseDetailController controller) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Get.toNamed(AppRoutes.adminCreateQuiz,
                  arguments: {'courseId': controller.courseId});
            },
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(Icons.add, size: 20.sp, color: AppColors.c2),
                  SizedBox(width: 4.w),
                  GlobalText.medium("Tambah Kuis", color: AppColors.c2),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),
          if (controller.quizzes.isEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r)),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.quiz_outlined, size: 40.sp, color: Colors.grey),
                    SizedBox(height: 8.h),
                    GlobalText.regular("Belum ada kuis untuk materi ini.",
                        color: Colors.grey),
                  ],
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.quizzes.length,
              itemBuilder: (context, index) {
                final quiz = controller.quizzes[index];
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.only(bottom: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.quiz, color: AppColors.c2),
                    title: GlobalText.medium(
                      quiz.quizName ?? 'Kuis Tanpa Judul',
                      textAlign: TextAlign.start,
                    ),
                    subtitle: quiz.timeLimit != null
                        ? GlobalText.regular(
                            'Durasi: ${quiz.timeLimit} menit',
                            color: Colors.grey,
                            fontSize: 12.sp,
                            textAlign: TextAlign.start,
                          )
                        : null,
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Arahkan ke detail kuis
                      Get.toNamed(
                        AppRoutes.adminDetailQuiz,
                        arguments: {
                          'quizId': quiz.id,
                          'titleQuiz': quiz.quizName
                        },
                      );
                    },
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildEditMode(AdminCourseDetailController controller) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          TextField(
            controller:
                TextEditingController(text: controller.editedCourseName.value),
            onChanged: (v) => controller.editedCourseName.value = v,
            decoration: const InputDecoration(labelText: 'Judul Materi'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, color: AppColors.c2),
        SizedBox(width: 8.w),
        Flexible(
          child: GlobalText.regular(text, color: AppColors.c2),
        ),
      ],
    );
  }
}
