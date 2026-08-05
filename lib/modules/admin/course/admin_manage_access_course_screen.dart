import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/core/global_components/global_confirmation_dialog.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:blessing/modules/admin/course/controllers/admin_manage_access_course_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AdminManageAccessCourseScreen extends StatelessWidget {
  const AdminManageAccessCourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminManageAccessCourseController>();

    return BaseWidgetContainer(
      backgroundColor: AppColors.c1,
      appBar: AppBar(
        title: GlobalText.semiBold(
          "Akses Materi",
          fontSize: 18.sp,
          color: AppColors.c2,
        ),
        backgroundColor: AppColors.c1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.c2),
          onPressed: () => Get.back(),
        ),
        shadowColor: Colors.black.withValues(alpha: 0.4),
        surfaceTintColor: Colors.white,
        elevation: 0.5,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.c2,
        onPressed: controller.navigateToAddUsers,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.c2));
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GlobalText.medium(
                  controller.errorMessage.value,
                  color: AppColors.c2,
                  fontSize: 14.sp,
                ),
                SizedBox(height: 16.h),
                ElevatedButton.icon(
                  onPressed: controller.refreshUserAccess,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Coba Lagi'),
                )
              ],
            ),
          );
        }

        if (controller.userAccessList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GlobalText.medium(
                  'Belum ada pengguna yang memiliki akses ke materi ini.',
                  textAlign: TextAlign.center,
                  color: AppColors.c2,
                  fontSize: 14.sp,
                ),
                SizedBox(height: 16.h),
                ElevatedButton.icon(
                  onPressed: controller.refreshUserAccess,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchUserAccess,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            itemCount: controller.userAccessList.length,
            itemBuilder: (context, index) {
              final userAccess = controller.userAccessList[index];
              return Card(
                elevation: 1,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  side: BorderSide(color: Colors.grey.shade200, width: 1),
                ),
                margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 4.w),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.c2.withValues(alpha: 0.1),
                      foregroundColor: AppColors.c2,
                      child: Text(
                        userAccess.user.username!
                            .substring(0, 1)
                            .toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      userAccess.user.username ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                        color: AppColors.c2,
                      ),
                      softWrap: true,
                    ),
                    subtitle: Text(
                      userAccess.user.email ?? '',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey.shade600,
                      ),
                      softWrap: true,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () {
                        Get.dialog(
                          GlobalConfirmationDialog(
                            message:
                                "Apakah kamu yakin ingin menghapus akses untuk ${userAccess.user.username}?",
                            onYes: () {
                              Get.back();
                              controller.removeUserAccess(userAccess.id);
                            },
                            onNo: () => Get.back(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
