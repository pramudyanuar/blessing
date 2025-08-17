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
      appBar: AppBar(
        title: GlobalText.semiBold("Tambah Akses",
            fontSize: 18.sp, color: AppColors.c2),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
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
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.errorMessage.isNotEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      controller.errorMessage.value,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
              if (controller.filteredUsers.isEmpty) {
                return const Center(child: Text('Tidak ada siswa ditemukan.'));
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
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        contentPadding: const EdgeInsets.only(left: 8.0),
                        onTap: () => controller.toggleUserSelection(user.id),
                        leading: Checkbox(
                          value: isSelected,
                          onChanged: (bool? value) {
                            controller.toggleUserSelection(user.id);
                          },
                        ),
                        title: Text(user.username ?? 'Tanpa Nama'),
                        subtitle: Text(
                          'Kelas ${user.gradeLevel}${hasExistingAccess ? " • Sudah memiliki akses" : ""}',
                          style: TextStyle(
                            color: hasExistingAccess
                                ? Theme.of(context).primaryColor
                                : null,
                            fontWeight: hasExistingAccess
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
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
    return Material(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: controller.onSearchChanged,
                decoration: const InputDecoration(
                  hintText: 'Cari nama siswa...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Dropdown yang dibungkus agar terlihat lebih baik
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.grey),
              ),
              child: Obx(() => DropdownButton<String>(
                    value: controller.selectedKelas.value,
                    underline:
                        const SizedBox(), // Hilangkan garis bawah default
                    items: controller.kelasList
                        .map((kelas) => DropdownMenuItem(
                              value: kelas,
                              child: Text('Kelas $kelas'),
                            ))
                        .toList(),
                    onChanged: controller.onKelasChanged,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
