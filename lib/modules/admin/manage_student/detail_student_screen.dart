import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/core/global_components/global_button.dart';
import 'package:blessing/core/global_components/global_text.dart';
// Impor dialog yang sudah kita buat
import 'package:blessing/core/global_components/global_confirmation_dialog.dart'; 
import 'package:blessing/modules/admin/manage_student/controller/detail_student_controller.dart';
import 'package:blessing/modules/admin/manage_student/widgets/detail_field.dart';
import 'package:blessing/modules/admin/manage_student/widgets/quiz_score_card.dart';
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
          padding:
              EdgeInsets.only(left: 12.w), // <-- 2. Beri jarak di kiri
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        // Atur properti ini untuk mengurangi jarak
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
                onPressed: controller.toggleEditMode,
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
                backgroundColor: AppColors.c2,
                child: Icon(Icons.person, size: 40.sp, color: Colors.white),
              ),
              SizedBox(height: 16.h),
              GlobalText.bold(controller.name.value, fontSize: 18.sp),
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 12.h),
                    DetailField(
                      icon: Icons.person,
                      title: "Nama",
                      value: controller.name.value,
                      isEdit: controller.isEditMode.value,
                      onChanged: controller.updateName,
                    ),
                    DetailField(
                      icon: Icons.school,
                      title: "Kelas",
                      value: controller.grade.value,
                      isEdit: controller.isEditMode.value,
                      onChanged: controller.updateGrade,
                    ),
                    DetailField(
                      icon: Icons.location_city,
                      title: "Asal Sekolah",
                      value: controller.school.value,
                      isEdit: controller.isEditMode.value,
                      onChanged: controller.updateSchool,
                    ),
                    DetailField(
                      icon: Icons.cake,
                      title: "Tanggal Lahir",
                      value: controller.birthDate.value,
                      isEdit: controller.isEditMode.value,
                      onChanged: controller.updateBirthDate,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GlobalText.semiBold("Nilai Kuis", fontSize: 16.sp),
                        TextButton(
                          onPressed: () {},
                          child: GlobalText.medium("Lihat Semua",
                              color: AppColors.c2, fontSize: 14.sp),
                        )
                      ],
                    ),
                    ...controller.quizScores.entries
                        .map((e) => QuizScoreCard(title: e.key, score: e.value))
                        .toList(),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              GlobalButton(
                text: "Hapus Siswa",
                onPressed: () {
                  // --- PEMANGGILAN DIALOG KONFIRMASI ---
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return GlobalConfirmationDialog(
                        message: "Apakah Anda yakin ingin menghapus siswa ini?",
                        onYes: () {
                          // Panggil fungsi hapus dari controller
                          // controller.deleteStudent();
                          print("Siswa dihapus!"); 
                          Navigator.of(context).pop(); // Tutup dialog
                        },
                        onNo: () {
                          // Cukup tutup dialog
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  );
                },
                width: double.infinity,
                height: 30.h,
                color: AppColors.c7,
              ),
              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }
}
