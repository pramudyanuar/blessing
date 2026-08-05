import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:blessing/modules/admin/course/controllers/admin_assign_user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AdminAssignUserScreen extends StatelessWidget {
  const AdminAssignUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminAssignUserController>();

    return BaseWidgetContainer(
      backgroundColor: AppColors.c1,
      appBar: AppBar(
        title: GlobalText.semiBold("Tambah Akses",
            fontSize: 18.sp, color: AppColors.c2),
        backgroundColor: AppColors.c1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.c2),
          onPressed: () => Get.back(),
        ),
        shadowColor: Colors.black.withValues(alpha: 0.4),
        surfaceTintColor: Colors.white,
        elevation: 0.5,
        actions: [
          Obx(() {
            return TextButton(
              onPressed: controller.isAssigning.value
                  ? null
                  : controller.assignSelectedUsers,
              child: controller.isAssigning.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('SIMPAN', style: TextStyle(color: AppColors.c2)),
            );
          }),
        ],
      ),
      body: Column(
        children: [
          // --- Area Filter yang Diperbarui ---
          _buildFilterSection(controller),

          // --- Daftar Siswa yang Diperbarui ---
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator(color: AppColors.c2));
              }
              if (controller.errorMessage.isNotEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: GlobalText.medium(
                      controller.errorMessage.value,
                      textAlign: TextAlign.center,
                      color: AppColors.c2,
                      fontSize: 14.sp,
                    ),
                  ),
                );
              }
              if (controller.filteredUsers.isEmpty) {
                return Center(
                  child: GlobalText.medium(
                    'Tidak ada siswa ditemukan.',
                    color: AppColors.c2,
                    fontSize: 14.sp,
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                itemCount: controller.filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = controller.filteredUsers[index];
                  // Obx diperlukan di sini agar setiap item bisa rebuild
                  return Obx(() {
                    final isSelected =
                        controller.selectedUserIds.contains(user.id);
                    // Cek apakah user ini sudah punya akses dari awal
                    final hasExistingAccess =
                        controller.existingUserIds.contains(user.id);

                    return Card(
                      elevation: 1,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        side: BorderSide(color: Colors.grey.shade200, width: 1),
                      ),
                      margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                        onTap: () => controller.toggleUserSelection(user.id),
                        leading: Checkbox(
                          value: isSelected,
                          activeColor: AppColors.c2,
                          onChanged: (bool? value) {
                            controller.toggleUserSelection(user.id);
                          },
                        ),
                        title: Text(
                          user.username ?? 'Tanpa Nama',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            color: AppColors.c2,
                          ),
                          softWrap: true,
                        ),
                        subtitle: Text(
                          'Kelas ${user.gradeLevel}${hasExistingAccess ? " • Sudah memiliki akses" : ""}',
                          style: TextStyle(
                            color: hasExistingAccess
                                ? Colors.green.shade600
                                : Colors.grey.shade600,
                            fontWeight: hasExistingAccess
                                ? FontWeight.w600
                                : FontWeight.normal,
                            fontSize: 12.sp,
                          ),
                          softWrap: true,
                        ),
                      ),
                    );
                  });
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  /// Widget terpisah untuk bagian filter agar lebih rapi
  Widget _buildFilterSection(AdminAssignUserController controller) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: controller.onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Cari nama siswa...',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14.sp),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                fillColor: const Color(0xFFFAFAFA),
                filled: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: AppColors.c2),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          // Dropdown yang dibungkus agar terlihat lebih baik
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Obx(() => DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: controller.selectedKelas.value,
                    style: TextStyle(
                        color: AppColors.c2,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500),
                    icon: const Icon(Icons.arrow_drop_down, color: AppColors.c2),
                    items: controller.kelasList
                        .map((kelas) => DropdownMenuItem(
                              value: kelas,
                              child: Text('Kelas $kelas'),
                            ))
                        .toList(),
                    onChanged: controller.onKelasChanged,
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
