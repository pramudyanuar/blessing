import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/core/global_components/global_confirmation_dialog.dart';
import 'package:blessing/core/global_components/search_bar.dart';
import 'package:blessing/core/utils/app_routes.dart';
import 'package:blessing/modules/admin/homepage/controller/admin_homepage_controller.dart';
import 'package:blessing/modules/admin/homepage/widgets/subject_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AdminHomepageScreen extends StatelessWidget {
  const AdminHomepageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Menginisialisasi atau mencari controller yang sudah ada
    final controller = Get.find<AdminHomepageController>();

    return BaseWidgetContainer(
      backgroundColor: AppColors.c5,
      appBar: AppBar(
        title: _buildKelasFilter(controller),
        backgroundColor: Colors.white,
        elevation: 1.0,
        // Tombol aksi di AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () {
              // Menampilkan dialog konfirmasi saat logout
              showDialog(
                context: context,
                builder: (context) {
                  return GlobalConfirmationDialog(
                    message: 'Apakah Anda yakin ingin logout?',
                    onYes: () {
                      Navigator.of(context).pop(); // Tutup dialog
                      controller.logout(); // Panggil fungsi logout
                    },
                    onNo: () {
                      Navigator.of(context).pop(); // Tutup dialog
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
      // --- PERUBAHAN DIMULAI DI SINI ---
      body: Column(
        children: [
          _buildSearchBar(controller), // Menambahkan search bar
          Expanded(
            // Membungkus list dengan Expanded
            child: Obx(() {
              // Tampilkan loading indicator saat data sedang diambil
              if (controller.isLoading.value &&
                  controller.displayedSubjects.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              // Tampilkan pesan jika tidak ada mata pelajaran
              if (controller.displayedSubjects.isEmpty) {
                return const Center(
                  child: Text(
                    'Mata pelajaran tidak ditemukan atau belum ada.\nKetuk tombol + untuk menambahkan.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }

              // Tampilkan daftar mata pelajaran jika data tersedia
              return RefreshIndicator(
                onRefresh: () =>
                    controller.fetchAllSubjects(), // Fungsi refresh
                child: ListView.separated(
                  padding: EdgeInsets.fromLTRB(
                      16.w, 0, 16.w, 16.w), // Sesuaikan padding
                  itemCount: controller.displayedSubjects.length,
                  separatorBuilder: (context, index) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    // Ambil data subjek untuk item saat ini
                    final subject = controller.displayedSubjects[index];
                    return SubjectCard(
                      // Gunakan nama subjek dari API
                      title: subject.subjectName ?? 'Tanpa Nama',
                      // Gunakan icon default
                      icon: Icons.class_,
                      onTap: () {
                        final subjectId = subject.id;
                        final subjectName = subject.subjectName;
                        final kelas = controller.selectedKelas.value;

                        Get.toNamed(
                          AppRoutes.manageSubject,
                          arguments: {
                            'subjectId': subjectId,
                            'kelas': kelas,
                            'subjectName': subjectName,
                          },
                        );
                      },
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.c2,
        onPressed: () {
          Get.toNamed(AppRoutes.adminCreateSubject)
              ?.then((value) => controller.fetchAllSubjects());
        },
        child: const Icon(
          Icons.add,
          color: AppColors.c1,
        ),
      ),
    );
  }

  /// Widget untuk membangun search bar.
  Widget _buildSearchBar(AdminHomepageController controller) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
      child: CustomSearchBar(
        hintText: 'Cari Mata Pelajaran',
        onChanged: (value) {
          controller.setSearchQuery(value);
        },
        height: 30.h,
      ),
    );
  }

  /// Widget untuk membangun filter kelas di AppBar.
  Widget _buildKelasFilter(AdminHomepageController controller) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: controller.kelasList.map((kelas) {
            final bool isSelected = controller.selectedKelas.value == kelas;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0.w),
              child: GestureDetector(
                onTap: () {
                  controller.selectKelas(kelas);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(
                    vertical: 5.h,
                    horizontal: 15.w,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.c2 : Colors.transparent,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    'Kelas $kelas',
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
