// lib/modules/admin/course/views/upload_course_screen.dart

import 'dart:io';
import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:blessing/core/global_components/custom_text_field.dart';
import 'package:blessing/modules/admin/course/controllers/admin_upload_course_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class UploadCourseScreen extends StatelessWidget {
  const UploadCourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Gunakan Get.put jika ini adalah halaman pertama yang membuat controller,
    // atau Get.find jika sudah dibuat oleh binding.
    final controller = Get.find<AdminUploadCourseController>();

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
            child: Obx(() {
              return TextButton(
                onPressed:
                    controller.isLoading.value ? null : controller.uploadCourse,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: Colors.transparent,
                ),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppColors.c2,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Unggah',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              );
            }),
          ),
        ],
        leading: Padding(
          padding: EdgeInsets.only(left: 12.w),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Get.back(),
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
                controller: controller.titleController,
                hintText: 'Tambahkan judul',
                fillColor: Colors.white,
              ),
              SizedBox(height: 12.h),
              CustomTextField(
                controller: controller.descriptionController,
                hintText: 'Tambah deskripsi atau instruksi (opsional)',
                fillColor: Colors.white,
              ),
              SizedBox(height: 16.h),
              // [BARU] Input dan tombol untuk menambah link
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: controller.linkController,
                      hintText:
                          'Masukkan link video/URL (contoh: https://youtube.com/watch?v=...)',
                      fillColor: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  ElevatedButton(
                    onPressed: controller.addLink,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.c2,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: const Icon(Icons.add_link),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              // [DIUBAH] Tombol untuk memilih gambar
              ElevatedButton.icon(
                onPressed: controller.pickImages,
                icon: const Icon(Icons.add_photo_alternate_outlined),
                label: const Text("Tambah Gambar"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.c2.withOpacity(0.1),
                  foregroundColor: AppColors.c2,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              // [DIUBAH] Tampilkan semua content items (gambar dan link)
              Obx(() {
                return Column(
                  children: controller.contentItems.map((item) {
                    // Tampilkan item gambar
                    if (item['type'] == 'image' && item['data'] is File) {
                      final file = item['data'] as File;
                      return _buildFileItem(
                        icon: FontAwesomeIcons.image,
                        fileName: file.path.split('/').last,
                        size:
                            '${(file.lengthSync() / 1024 / 1024).toStringAsFixed(2)} MB',
                        color: Colors.purple.shade300,
                        onRemove: () => controller.removeContentItem(item),
                        file: file,
                      );
                    }
                    // Tampilkan item link
                    else if (item['type'] == 'link') {
                      final link = item['data'] as String;
                      return _buildLinkItem(
                        link: link,
                        onRemove: () => controller.removeContentItem(item),
                      );
                    }
                    return const SizedBox.shrink();
                  }).toList(),
                );
              }),
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
    required File file, // Tambahkan file untuk menampilkan preview
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.file(
              file,
              width: 40.w,
              height: 40.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  size,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12.sp,
                  ),
                ),
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

  Widget _buildLinkItem({
    required String link,
    required VoidCallback onRemove,
  }) {
    // Determine icon and color based on URL
    IconData linkIcon = FontAwesomeIcons.link;
    Color color = Colors.blue.shade300;
    String displayText = 'Link';

    if (link.contains('youtube.com') || link.contains('youtu.be')) {
      linkIcon = FontAwesomeIcons.youtube;
      color = Colors.red.shade300;
      displayText = 'Video YouTube';
    } else if (link.contains('vimeo.com')) {
      linkIcon = FontAwesomeIcons.vimeo;
      color = Colors.blue.shade400;
      displayText = 'Video Vimeo';
    }

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              linkIcon,
              color: color,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayText,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  link.length > 50 ? '${link.substring(0, 50)}...' : link,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12.sp,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
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
