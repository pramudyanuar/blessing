import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/core/global_components/custom_text_field.dart';
import 'package:blessing/core/global_components/global_button.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:blessing/modules/admin/manage_student/controller/add_student_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddStudentScreen extends StatelessWidget {
  AddStudentScreen({super.key});

  final controller = Get.find<AddStudentController>();

  @override
  Widget build(BuildContext context) {
    return BaseWidgetContainer(
      appBar: AppBar(
        title: GlobalText.semiBold("Tambah Siswa", fontSize: 16.sp),
        backgroundColor: Colors.white,
        elevation: 0.5,
        titleSpacing: 0.2.w,
        leadingWidth: 40.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 12.w),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              CustomTextField(
                title: "Email",
                controller: controller.emailController,
                hintText: "Masukkan email",
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 12.h),
              CustomTextField(
                title: "Password",
                controller: controller.passwordController,
                hintText: "Masukkan password",
                icon: Icons.lock,
              ),
              SizedBox(height: 12.h),
              CustomTextField(
                title: "Username",
                controller: controller.usernameController,
                hintText: "Masukkan username",
                icon: Icons.person,
              ),
              SizedBox(height: 12.h),
              CustomTextField(
                title: "Kelas",
                controller: controller.gradeController,
                hintText: "Contoh: 12",
                icon: Icons.grade,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 24.h),
              GlobalButton(
                text: "Tambah Siswa",
                width: double.infinity,
                height: 48.h,
                onPressed: controller.addStudent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
