import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:blessing/core/global_components/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UploadCourseScreen extends StatelessWidget {
  const UploadCourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseWidgetContainer(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: GlobalText.semiBold("Unggah Materi", fontSize: 16.sp),
        backgroundColor: Colors.white,
        elevation: 0.5,
        titleSpacing: 0.2.w,
        leadingWidth: 40.w,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: TextButton(
              onPressed: () {
                // Aksi unggah
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.c2,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'Unggah',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: TextEditingController(),
                hintText: 'Tambahkan judul',
                fillColor: Colors.white,
              ),
              SizedBox(height: 12.h),
              CustomTextField(
                controller: TextEditingController(),
                hintText: 'Tambah deskripsi atau instruksi',
                fillColor: Colors.white,
                suffixButton: IconButton(
                  icon: const Icon(Icons.create_new_folder_sharp),
                  color: AppColors.c2,
                  onPressed: () {
                    // Aksi pilih file
                  },
                ),
              ),
              SizedBox(height: 12.h),
              _buildFileItem(
                icon: FontAwesomeIcons.filePdf,
                fileName: 'Chapter-1.pdf',
                size: '2.4 MB',
                color: Colors.redAccent.shade100,
                onRemove: () {},
              ),
              SizedBox(height: 8.h),
              _buildFileItem(
                icon: FontAwesomeIcons.image,
                fileName: 'diagram.jpg',
                size: '1.8 MB',
                color: Colors.blueAccent.shade100,
                onRemove: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFileItem({
    required IconData icon,
    required String fileName,
    required String size,
    required Color color,
    required VoidCallback onRemove,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          FaIcon(icon, color: color, size: 20.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(fileName, style: TextStyle(fontWeight: FontWeight.w600)),
                Text(size,
                    style: TextStyle(
                        color: Colors.grey.shade600, fontSize: 12.sp)),
              ],
            ),
          ),
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.close, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
