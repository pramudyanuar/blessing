import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:blessing/core/global_components/search_bar.dart';
import 'package:blessing/core/utils/app_routes.dart';
import 'package:blessing/modules/admin/subject/controllers/admin_subject_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AdminSubjectListScreen extends StatelessWidget {
  const AdminSubjectListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminSubjectListController>();

    return BaseWidgetContainer(
      backgroundColor: AppColors.c5,
      appBar: AppBar(
        title: GlobalText.semiBold(
          'Mata Pelajaran',
          fontSize: 18.sp,
          color: AppColors.c2,
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.c2,
        onPressed: () => Get.toNamed(
          AppRoutes.adminCreateSubject,
          arguments: {'onSubjectAdded': () => controller.fetchSubjects()},
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.all(16.w),
            child: CustomSearchBar(
              hintText: 'Cari mata pelajaran...',
              onChanged: (value) => controller.updateSearchQuery(value),
            ),
          ),

          // List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredSubjects.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.book_outlined,
                        size: 64.sp,
                        color: Colors.grey.shade400,
                      ),
                      SizedBox(height: 16.h),
                      GlobalText.medium(
                        'Tidak ada mata pelajaran',
                        fontSize: 16.sp,
                        color: Colors.grey.shade600,
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.fetchSubjects,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  itemCount: controller.filteredSubjects.length,
                  itemBuilder: (context, index) {
                    final subject = controller.filteredSubjects[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 6.h),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        leading: Container(
                          decoration: BoxDecoration(
                            color: AppColors.c2.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          padding: EdgeInsets.all(8.w),
                          child: Icon(
                            Icons.book,
                            color: AppColors.c2,
                            size: 24.sp,
                          ),
                        ),
                        title: GlobalText.semiBold(
                          subject.subjectName ?? 'Tanpa Nama',
                          fontSize: 14.sp,
                          color: Colors.black87,
                        ),
                        subtitle: GlobalText.regular(
                          'ID: ${subject.id.substring(0, 8)}...',
                          fontSize: 12.sp,
                          color: Colors.grey.shade600,
                        ),
                        trailing: PopupMenuButton<String>(
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.grey,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit_outlined,
                                      color: AppColors.c2, size: 20.sp),
                                  SizedBox(width: 8.w),
                                  GlobalText.medium('Edit',
                                      fontSize: 12.sp, color: AppColors.c2),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete_outline,
                                      color: Colors.red, size: 20.sp),
                                  SizedBox(width: 8.w),
                                  GlobalText.medium('Hapus',
                                      fontSize: 12.sp,
                                      color: Colors.red),
                                ],
                              ),
                            ),
                          ],
                          onSelected: (value) {
                            if (value == 'edit') {
                              Get.toNamed(
                                AppRoutes.adminEditSubject,
                                arguments: {
                                  'subjectId': subject.id,
                                  'subjectName': subject.subjectName,
                                  'onSubjectUpdated': () =>
                                      controller.fetchSubjects(),
                                },
                              );
                            } else if (value == 'delete') {
                              Get.dialog(
                                AlertDialog(
                                  title: const Text('Hapus Mata Pelajaran'),
                                  content: Text(
                                    'Apakah Anda yakin ingin menghapus "${subject.subjectName}"? Tindakan ini tidak dapat dibatalkan.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Get.back(),
                                      child: const Text('Batal'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        Get.back();
                                        await controller.deleteSubject(subject.id);
                                      },
                                      child: const Text('Hapus',
                                          style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                        onTap: () => Get.toNamed(
                          AppRoutes.adminSubjectDetail,
                          arguments: {
                            'subjectId': subject.id,
                            'subjectName': subject.subjectName,
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
