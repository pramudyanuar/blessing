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
      appBar: AppBar(
        centerTitle: false,
        title: GlobalText.semiBold("Akses Materi", fontSize: 16.sp, color: AppColors.c2,),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.c2),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.navigateToAddUsers,
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(controller.errorMessage.value),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.fetchUserAccess,
                  child: const Text('Coba Lagi'),
                )
              ],
            ),
          );
        }

        if (controller.userAccessList.isEmpty) {
          return const Center(
            child: Text(
              'Belum ada pengguna yang memiliki akses ke materi ini.',
              textAlign: TextAlign.center,
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchUserAccess,
          child: ListView.builder(
            itemCount: controller.userAccessList.length,
            itemBuilder: (context, index) {
              final userAccess = controller.userAccessList[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(
                        userAccess.user.username!.substring(0, 1).toUpperCase()),
                  ),
                  title: Text(userAccess.user.username ?? ''),
                  subtitle: Text(userAccess.user.email ?? ''),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () {
                      Get.dialog(
                        GlobalConfirmationDialog(
                          message: "Apakah kamu yakin ingin menghapus akses untuk ${userAccess.user.username}?",
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
              );
            },
          ),
        );
      }),
    );
  }
}
