import 'package:blessing/modules/admin/course/controllers/admin_assign_user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminAssignUserScreen extends StatelessWidget {
  const AdminAssignUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminAssignUserController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambahkan Akses Pengguna'),
        actions: [
          // Tombol simpan
          Obx(() {
            return TextButton(
              onPressed: controller.isAssigning.value
                  ? null // Nonaktifkan tombol saat proses assignment
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
                  : const Text('TETAPKAN',
                      style: TextStyle(color: Colors.white)),
            );
          }),
        ],
      ),
      body: Column(
        children: [
          // --- Area Filter ---
          Padding(
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
                // Dropdown untuk kelas
                Obx(() => DropdownButton<String>(
                      value: controller.selectedKelas.value,
                      items: controller.kelasList
                          .map((kelas) => DropdownMenuItem(
                                value: kelas,
                                child: Text('Kelas $kelas'),
                              ))
                          .toList(),
                      onChanged: controller.onKelasChanged,
                    )),
              ],
            ),
          ),
          const Divider(height: 1),

          // --- Daftar Siswa ---
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.errorMessage.isNotEmpty) {
                return Center(child: Text(controller.errorMessage.value));
              }
              if (controller.filteredUsers.isEmpty) {
                return const Center(child: Text('Tidak ada siswa ditemukan.'));
              }

              // Daftar siswa dengan checkbox
              return ListView.builder(
                itemCount: controller.filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = controller.filteredUsers[index];
                  // Obx diperlukan di sini agar setiap item bisa rebuild saat status 'selected' berubah
                  return Obx(() {
                    final isSelected =
                        controller.selectedUserIds.contains(user.id);
                    return ListTile(
                      onTap: () => controller.toggleUserSelection(user.id),
                      leading: Checkbox(
                        value: isSelected,
                        onChanged: (bool? value) {
                          controller.toggleUserSelection(user.id);
                        },
                      ),
                      title: Text(user.username ?? 'Tanpa Nama'),
                      subtitle: Text('Kelas ${user.gradeLevel}'),
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
}
