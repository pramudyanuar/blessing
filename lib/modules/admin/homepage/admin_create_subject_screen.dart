import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/core/global_components/global_button.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:blessing/core/global_components/custom_text_field.dart';
import 'package:blessing/modules/admin/homepage/controller/admin_create_subject_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AdminCreateSubjectScreen extends StatelessWidget {
  AdminCreateSubjectScreen({super.key});

  // Ganti controller ke controller yang baru dibuat
  final controller = Get.find<AdminCreateSubjectController>();

  @override
  Widget build(BuildContext context) {
    return BaseWidgetContainer(
      backgroundColor: AppColors.c5,
      appBar: AppBar(
        centerTitle: false,
        title: GlobalText.semiBold("Buat Mata Pelajaran", fontSize: 16.sp),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(), // Gunakan Get.back()
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        // Gunakan Form untuk validasi
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Subject Name Input Field
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: CustomTextField(
                  controller: controller.subjectNameController,
                  title: "Nama Mata Pelajaran",
                  hintText: "Contoh: Matematika",
                  fillColor: Colors.white,
                  borderColor: Colors.grey.shade300,
                  // Tambahkan validator
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama mata pelajaran tidak boleh kosong';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 24.h), // Beri jarak lebih
              // Create Subject Button
              Obx(
                () => GlobalButton(
                  // Nonaktifkan tombol saat loading
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.createSubject(),
                  text: controller.isLoading.value
                      ? 'Memproses...'
                      : "Buat Mata Pelajaran",
                  width: double.infinity,
                  height: 48,
                  fontSize: 14,
                  borderRadius: 8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
