import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/core/global_components/global_button.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:blessing/modules/student/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    final isInitialSetup = controller.mode == ProfileMode.edit;

    return BaseWidgetContainer(
      backgroundColor: const Color(0xFFE9EBF0),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  SizedBox(height: 24.h),
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
                      CircleAvatar(
                        radius: 50.r,
                        backgroundImage:
                            const AssetImage('assets/images/image.png'),
                      ),
                      Container(
                        padding: EdgeInsets.all(6.r),
                        decoration: const BoxDecoration(
                          color: Color(0xFF0D47A1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 18.r,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  // Form
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- Field Nama Lengkap ---
                        GlobalText.medium('Nama Lengkap', fontSize: 14),
                        SizedBox(height: 8.h),
                        TextField(
                          controller: controller.fullNameController,
                          decoration: _inputDecoration(
                              'Masukkan nama lengkap anda',
                              Icons.person_outline),
                        ),
                        SizedBox(height: 16.h),
                        // --- Field Kelas ---
                        GlobalText.medium('Kelas', fontSize: 14),
                        SizedBox(height: 8.h),
                        Obx(() => DropdownButtonFormField<String>(
                              dropdownColor:
                                  Colors.white, // Latar belakang list dropdown
                              value: controller.selectedClass.value,
                              decoration: _inputDecoration(
                                  'Pilih kelas anda', Icons.book_outlined),
                              items: controller.classOptions
                                  .map((kelas) => DropdownMenuItem(
                                      value: kelas, child: Text(kelas)))
                                  .toList(),
                              onChanged: (value) {
                                controller.selectedClass.value = value;
                              },
                            )),
                        SizedBox(height: 16.h),
                        // --- Field Asal Sekolah ---
                        GlobalText.medium('Asal Sekolah', fontSize: 14),
                        SizedBox(height: 8.h),
                        TextField(
                          controller: controller.schoolController,
                          decoration: _inputDecoration(
                              'Masukkan asal sekolah anda',
                              Icons.school_outlined),
                        ),
                        SizedBox(height: 16.h),
                        // --- Field Tanggal Lahir ---
                        GlobalText.medium('Tanggal Lahir', fontSize: 14),
                        SizedBox(height: 8.h),
                        TextField(
                          controller: controller.birthDateController,
                          keyboardType: TextInputType.datetime,
                          decoration: _inputDecoration(
                              'DD/MM/YYYY', Icons.calendar_today_outlined),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),
                  // Tombol
                  Obx(() => isInitialSetup
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GlobalButton(
                              text: 'Simpan',
                              onPressed: controller.saveProfile,
                              height: 35.h,
                              width: 0.32.sw,
                              isLoading: controller.isLoading.value,
                            ),
                            SizedBox(width: 16.w),
                            GlobalButton(
                              text: 'Logout',
                              onPressed: controller.logout,
                              width: 0.32.sw,
                              height: 35.h,
                              color: Colors.red,
                            ),
                          ],
                        )
                      : GlobalButton(
                          text: 'Submit',
                          onPressed: controller.saveProfile,
                          height: 44.h,
                          width: double.infinity,
                          isLoading: controller.isLoading.value,
                        )),
                  SizedBox(height: 12.h),
                ],
              ),
            ),
            if (isInitialSetup)
              Positioned(
                top: 10.h,
                left: 10.w,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new,
                      color: Colors.black54),
                  onPressed: () => Get.back(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hintText, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon),
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey.shade500),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: const Color(0xFFF5F6FA),
    );
  }
}
