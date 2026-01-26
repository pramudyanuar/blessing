// lib/modules/admin/manage_student/view/detail_student_screen.dart

import 'package:blessing/core/constants/color.dart'; // Pastikan path ini benar
import 'package:blessing/core/global_components/base_widget_container.dart'; // Pastikan path ini benar
import 'package:blessing/core/global_components/global_button.dart'; // Pastikan path ini benar
import 'package:blessing/core/global_components/global_text.dart'; // Pastikan path ini benar
import 'package:blessing/core/global_components/global_confirmation_dialog.dart'; // Pastikan path ini benar
import 'package:blessing/modules/admin/manage_student/controller/detail_student_controller.dart';
import 'package:blessing/modules/admin/manage_student/widgets/detail_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DetailStudentScreen extends StatelessWidget {
  DetailStudentScreen({super.key});

  final controller = Get.find<DetailStudentController>();

  @override
  Widget build(BuildContext context) {
    return BaseWidgetContainer(
      backgroundColor: AppColors.c5,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        leading: Padding(
          padding: EdgeInsets.only(left: 12.w),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Get.back(),
          ),
        ),
        titleSpacing: 0.2,
        leadingWidth: 40.w,
        title: Obx(() => GlobalText.medium(
              controller.isEditMode.value ? "Edit Siswa" : "Detail Siswa",
              fontSize: 16.sp,
            )),
        backgroundColor: AppColors.c1,
        elevation: 1,
        actions: [
          Obx(() => IconButton(
                icon: Icon(
                  controller.isEditMode.value ? Icons.save : Icons.edit,
                  color: AppColors.c2,
                ),
                onPressed: () {
                  if (controller.isEditMode.value) {
                    showDialog(
                      context: context,
                      builder: (context) => GlobalConfirmationDialog(
                        message: "Apakah Anda yakin ingin menyimpan perubahan?",
                        onYes: () {
                          controller.saveChanges();
                          Navigator.of(context).pop();
                        },
                        onNo: () => Navigator.of(context).pop(),
                      ),
                    );
                  } else {
                    controller.toggleEditMode();
                  }
                },
              )),
        ],
      ),
      body: Obx(
        () => SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40.r,
                backgroundColor: AppColors.c2.withOpacity(0.2),
                child: Icon(Icons.person, size: 40.sp, color: AppColors.c2),
              ),
              SizedBox(height: 16.h),
              GlobalText.bold(controller.name.value, fontSize: 18.sp),
              SizedBox(height: 24.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5)
                    ]),
                child: Column(
                  children: [
                    DetailField(
                      icon: Icons.person_outline,
                      title: "Nama",
                      controller: controller.nameController,
                      isEdit: controller.isEditMode.value,
                    ),
                    DetailField(
                      icon: Icons.school_outlined,
                      title: "Kelas",
                      controller: controller.gradeController,
                      isEdit: controller.isEditMode.value,
                      keyboardType: TextInputType.text,
                    ),
                    // DetailField(
                    //   icon: Icons.location_city_outlined,
                    //   title: "Asal Sekolah",
                    //   controller: controller.schoolController,
                    //   isEdit: controller.isEditMode.value,
                    // ),
                    DetailField(
                      icon: Icons.cake_outlined,
                      title: "Tanggal Lahir",
                      controller: controller.birthDateController,
                      isEdit: controller.isEditMode.value,
                      readOnly: true,
                      onTap: () {
                        if (controller.isEditMode.value) {
                          controller.selectBirthDate(context);
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              GlobalButton(
                text: "Lihat Report Card",
                onPressed: () {
                  // Navigasi ke halaman report card siswa
                  Get.toNamed('/admin-student-report', arguments: {
                    'userId': controller.studentId.value,
                    'userName': controller.name.value,
                  });
                },
                width: double.infinity,
                color: AppColors.c2,
              ),
              SizedBox(height: 24.h),
              Obx(() => GlobalButton(
                    text: controller.isDeleting.value
                        ? "Menghapus..."
                        : "Hapus Siswa",
                    onPressed: controller.isDeleting.value
                        ? null
                        : () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return GlobalConfirmationDialog(
                                  message:
                                      "Tindakan ini tidak dapat diurungkan. Apakah Anda yakin ingin menghapus siswa ini?",
                                  onYes: () async {
                                    Navigator.of(context).pop();
                                    await controller.deleteStudent();
                                  },
                                  onNo: () => Navigator.of(context).pop(),
                                );
                              },
                            );
                          },
                    width: double.infinity,
                    color: controller.isDeleting.value
                        ? Colors.grey
                        : AppColors.c7,
                  )),
              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }
}
