import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/core/global_components/global_button.dart';
import 'package:blessing/core/global_components/global_confirmation_dialog.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:blessing/core/utils/app_routes.dart';
import 'package:blessing/modules/student/profile/controllers/profile_controller.dart';
import 'package:blessing/core/global_components/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return BaseWidgetContainer(
      backgroundColor: const Color(0xFFE9EBF0),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24.w, 60.h, 24.w, 24.h),
              child: Column(
                children: [
                  GlobalText.bold(
                    'Data Diri Siswa',
                    fontSize: 18.sp,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 6.h),
                  GlobalText.medium(
                    'Isi data diri anda di bawah ini',
                    fontSize: 12.sp,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16.h),
                  // Avatar
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/images/image.png'),
                      ),
                      Obx(() => controller.isEditMode.value
                          ? InkWell(
                              onTap: () {
                                Get.snackbar(
                                    'Info', 'Fitur ganti foto belum tersedia');
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF0D47A1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.camera_alt,
                                    color: Colors.white, size: 18),
                              ),
                            )
                          : const SizedBox.shrink()),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  // Form
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Obx(() => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GlobalText.medium('Nama Lengkap', fontSize: 14),
                            SizedBox(height: 8.h),
                            CustomTextField(
                              enabled: controller.isEditMode.value,
                              controller: controller.fullNameController,
                              hintText: 'Masukkan nama lengkap anda',
                              icon: Icons.person_outline,
                            ),
                            SizedBox(height: 16.h),
                            GlobalText.medium('Kelas', fontSize: 14),
                            SizedBox(height: 8.h),
                            // Logika untuk menampilkan field kelas:
                            // - Initial setup: dropdown bisa diedit
                            // - Edit mode: read-only dengan lock icon
                            // - View mode: read-only tanpa lock icon
                            if (controller.mode == ProfileMode.initialSetup)
                              DropdownButtonFormField<String>(
                                dropdownColor: Colors.white,
                                value: controller.selectedClass.value,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.book_outlined),
                                  hintText: 'Pilih kelas anda',
                                  hintStyle:
                                      TextStyle(color: Colors.grey.shade500),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFFF5F6FA),
                                ),
                                items: controller.classOptions
                                    .map((kelas) => DropdownMenuItem(
                                        value: kelas, child: Text(kelas)))
                                    .toList(),
                                onChanged: (value) {
                                  controller.selectedClass.value = value;
                                },
                              )
                            else if (controller.isEditMode.value)
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.w, vertical: 16.h),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.book_outlined,
                                      color: Colors.grey.shade500,
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Text(
                                        controller.selectedClass.value ??
                                            'Belum dipilih',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.lock,
                                      color: Colors.grey.shade400,
                                      size: 16.sp,
                                    ),
                                  ],
                                ),
                              )
                            else
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.w, vertical: 16.h),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.book_outlined,
                                      color: Colors.grey.shade700,
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Text(
                                        controller.selectedClass.value ??
                                            'Belum dipilih',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (controller.mode == ProfileMode.edit &&
                                controller.isEditMode.value)
                              Padding(
                                padding: EdgeInsets.only(top: 4.h),
                                child: Text(
                                  'Kelas tidak dapat diubah oleh siswa',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.grey.shade500,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            SizedBox(height: 16.h),
                            GlobalText.medium('Tanggal Lahir', fontSize: 14),
                            SizedBox(height: 8.h),
                            CustomTextField(
                              enabled: controller.isEditMode.value,
                              controller: controller.birthDateController,
                              hintText: 'Pilih tanggal lahir',
                              icon: Icons.calendar_today_outlined,
                              readOnly:
                                  true, // Membuat field tidak bisa diketik
                              onTap: () {
                                // Hanya bisa di-tap saat mode edit aktif
                                if (controller.isEditMode.value) {
                                  controller.selectBirthDate(context);
                                }
                              },
                            ),
                          ],
                        )),
                  ),
                  SizedBox(height: 24.h),

                  // Tombol Report Card (hanya untuk mode edit, bukan initial setup)
                  if (controller.mode == ProfileMode.edit)
                    GlobalButton(
                      text: 'Lihat Report Card',
                      onPressed: () {
                        Get.toNamed(AppRoutes.reportCard);
                      },
                      color: const Color(0xFF0D47A1),
                      width: double.infinity,
                      height: 40.h,
                    ),

                  if (controller.mode == ProfileMode.edit)
                    SizedBox(height: 12.h),

                  // Tombol Simpan atau Logout
                  if (controller.mode == ProfileMode.initialSetup)
                    Obx(() => GlobalButton(
                          text: 'Simpan dan Lanjutkan',
                          onPressed: controller.saveProfile,
                          isLoading: controller.isLoading.value,
                          width: double.infinity,
                        ))
                  else
                    GlobalButton(
                      text: 'Logout',
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (dialogContext) => GlobalConfirmationDialog(
                            message: 'Apakah Anda yakin ingin logout?',
                            onYes: () {
                              Navigator.of(dialogContext).pop();
                              controller.logout();
                            },
                            onNo: () => Navigator.of(dialogContext).pop(),
                          ),
                        );
                      },
                      color: Colors.red.shade700,
                      width: double.infinity,
                      height: 40.h,
                    ),

                  SizedBox(height: 12.h),
                ],
              ),
            ),

            // Tombol Back (kiri atas)
            if (controller.mode != ProfileMode.initialSetup)
              Positioned(
                top: 10.h,
                left: 10.w,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new,
                      color: Colors.black54),
                  onPressed: () => Get.back(),
                ),
              ),

            // Tombol Edit/Simpan (kanan atas)
            if (controller.mode == ProfileMode.edit)
              Positioned(
                top: 10.h,
                right: 10.w,
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator()),
                    );
                  }
                  if (controller.isEditMode.value) {
                    return IconButton(
                      icon:
                          const Icon(Icons.check, color: Colors.blue, size: 28),
                      onPressed: controller.saveProfile,
                      tooltip: 'Simpan',
                    );
                  } else {
                    return IconButton(
                      icon: const Icon(Icons.edit_outlined,
                          color: Colors.black54),
                      onPressed: controller.toggleEditMode,
                      tooltip: 'Edit Profil',
                    );
                  }
                }),
              ),
          ],
        ),
      ),
    );
  }
}
