import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/core/global_components/custom_snackbar.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:blessing/data/subject/models/request/create_subject_request.dart';
import 'package:blessing/data/subject/repository/subject_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AdminCreateSubjectScreen extends StatefulWidget {
  const AdminCreateSubjectScreen({super.key});

  @override
  State<AdminCreateSubjectScreen> createState() =>
      _AdminCreateSubjectScreenState();
}

class _AdminCreateSubjectScreenState extends State<AdminCreateSubjectScreen> {
  late final TextEditingController nameController;
  late final SubjectRepository _subjectRepository;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    _subjectRepository = Get.find<SubjectRepository>();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<void> _createSubject() async {
    final name = nameController.text.trim();

    if (name.isEmpty) {
      CustomSnackbar.show(title: 'Error', message: 'Nama mata pelajaran tidak boleh kosong', isError: true);
      return;
    }

    setState(() => isLoading = true);

    try {
      final request = CreateSubjectRequest(subjectName: name);
      final result = await _subjectRepository.createSubject(request);

      if (result != null) {
        CustomSnackbar.show(title: 'Sukses', message: 'Mata pelajaran berhasil dibuat');
        Get.back(result: true);
      } else {
        CustomSnackbar.show(title: 'Error', message: 'Gagal membuat mata pelajaran', isError: true);
      }
    } catch (e) {
      CustomSnackbar.show(title: 'Error', message: 'Error: $e', isError: true);
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidgetContainer(
      appBar: AppBar(
        title: GlobalText.semiBold(
          'Tambah Mata Pelajaran',
          fontSize: 18.sp,
          color: AppColors.c2,
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Form Title
            GlobalText.semiBold(
              'Informasi Mata Pelajaran',
              fontSize: 16.sp,
              color: Colors.black87,
            ),
            SizedBox(height: 20.h),

            // Subject Name Field
            GlobalText.medium(
              'Nama Mata Pelajaran',
              fontSize: 13.sp,
              color: Colors.black87,
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: nameController,
              enabled: !isLoading,
              decoration: InputDecoration(
                hintText: 'Contoh: Matematika, Bahasa Indonesia, Fisika',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                prefixIcon: Icon(Icons.book_outlined, color: AppColors.c2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: AppColors.c2, width: 2),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 14.h,
                ),
              ),
            ),

            SizedBox(height: 40.h),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.c2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                onPressed: isLoading ? null : _createSubject,
                icon: isLoading
                    ? SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : Icon(Icons.add, size: 20.sp),
                label: GlobalText.semiBold(
                  'BUAT MATA PELAJARAN',
                  fontSize: 14.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
