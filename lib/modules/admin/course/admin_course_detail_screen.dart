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
      // --- AppBar yang Lebih Stylish ---
      appBar: AppBar(
        title: GlobalText.semiBold("Detail Materi",
            fontSize: 18.sp, color: AppColors.c2),
        backgroundColor: AppColors.c1,
        // elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            if (controller.isEditing.value) {
              controller.isEditing.value = false; // batal edit
            } else {
              Get.back(); // keluar halaman
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
      // --- Body dengan Background dan Penanganan State ---
      backgroundColor: AppColors.c1,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(color: AppColors.c2));
        }
        if (controller.course.value == null) {
          return Center(
              child: GlobalText.regular('Data tidak ditemukan',
                  color: AppColors.c2));
        }

        // --- Transisi Halus antara Mode View dan Edit ---
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: controller.isEditing.value
              ? _buildEditMode(controller) // Widget untuk Mode Edit
              : _buildViewMode(controller), // Widget untuk Mode View
        );
      }),
    );
  }

  // --- WIDGET UNTUK MODE VIEW (LEBIH RAPI) ---
  Widget _buildViewMode(AdminCourseDetailController controller) {
    final course = controller.course.value!;
    return SingleChildScrollView(
      key: const ValueKey('viewMode'),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4,
            shadowColor: Colors.black.withOpacity(0.1),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r)),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlobalText.bold(
                    course.courseName ?? 'Tanpa Judul',
                    fontSize: 22.sp,
                    color: AppColors.c2,
                  ),
                  SizedBox(height: 12.h),
                  _buildInfoRow(
                    icon: Icons.class_outlined,
                    text: 'Kelas: ${course.gradeLevel}',
                  ),
                  SizedBox(height: 8.h),
                  _buildInfoRow(
                    icon: Icons.book_outlined,
                    text:
                        'Mata Pelajaran: ${course.subject?.subjectName ?? 'N/A'}',
                  ),
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
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          color: AppColors.c2,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.broken_image,
                        size: 50,
                        color: Colors.grey),
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

  // --- WIDGET UNTUK MODE EDIT (LEBIH MODERN) ---
  Widget _buildEditMode(AdminCourseDetailController controller) {
    return SingleChildScrollView(
      key: const ValueKey('editMode'),
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          _buildStyledTextField(
            controller:
                TextEditingController(text: controller.editedCourseName.value)
                  ..selection = TextSelection.fromPosition(TextPosition(
                      offset: controller.editedCourseName.value.length)),
            onChanged: (v) => controller.editedCourseName.value = v,
            labelText: 'Judul Materi',
            icon: Icons.title,
          ),
          SizedBox(height: 16.h),
          ...List.generate(controller.editedContents.length, (index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: _buildStyledTextField(
                controller: TextEditingController(
                    text: controller.editedContents[index])
                  ..selection = TextSelection.fromPosition(TextPosition(
                      offset: controller.editedContents[index].length)),
                onChanged: (v) => controller.editedContents[index] = v,
                labelText: 'Konten Teks ${index + 1}',
                icon: Icons.article_outlined,
                maxLines: 5,
              ),
            );
          }),
        ],
      ),
    );
  }

  // Helper untuk baris info (Kelas, Mapel)
  Widget _buildInfoRow({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, color: AppColors.c2, size: 20.sp),
        SizedBox(width: 8.w),
        GlobalText.regular(text,
            color: AppColors.c2, fontSize: 14.sp),
      ],
    );
  }

  // Helper untuk TextField yang stylish
  Widget _buildStyledTextField({
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
    required String labelText,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: AppColors.c2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.c2, width: 2.0),
        ),
        floatingLabelStyle: const TextStyle(color: AppColors.c2),
      ),
    );
  }
}
