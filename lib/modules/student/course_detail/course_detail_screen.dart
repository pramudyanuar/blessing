import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:blessing/modules/student/course_detail/controllers/course_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CourseDetailScreen extends StatelessWidget {
  const CourseDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CourseDetailController>();

    return BaseWidgetContainer(
      appBar: AppBar(
        backgroundColor: AppColors.c2,
        foregroundColor: Colors.white,
        title: Obx(() =>
            GlobalText.regular(controller.title.value, color: Colors.white)),
      ),
      body: Obx(() {
        if (controller.contentPaths.isEmpty) {
          return const Center(child: Text("Materi tidak ditemukan."));
        }

        // Tampilkan UI berdasarkan tipe konten
        if (controller.contentType.value == ContentType.pdf) {
          return Image.asset('assets/images/akutansi.webp', // Ganti dengan path PDF placeholder
              fit: BoxFit.contain);
        } else {
          return _buildGalleryView(controller);
        }
      }),
    );
  }

  // Widget untuk menampilkan galeri gambar
  Widget _buildGalleryView(CourseDetailController controller) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: controller.pageController,
            itemCount: controller.contentPaths.length,
            onPageChanged: (index) {
              controller.currentPage.value = index;
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.all(16.w),
                child: Image.asset(
                  // Menggunakan asset lokal sebagai contoh
                  controller.contentPaths[index],
                  fit: BoxFit.contain,
                ),
              );
            },
          ),
        ),
        _buildPaginationControls(controller),
      ],
    );
  }

  // Widget untuk kontrol navigasi galeri ( < 2/4 > )
  Widget _buildPaginationControls(CourseDetailController controller) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, size: 32),
                onPressed: controller.goToPreviousPage,
                color: controller.currentPage.value > 0
                    ? Colors.black
                    : Colors.grey,
              ),
              SizedBox(width: 16.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: GlobalText.bold(
                  '${controller.currentPage.value + 1} / ${controller.contentPaths.length}',
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(width: 16.w),
              IconButton(
                icon: const Icon(Icons.chevron_right, size: 32),
                onPressed: controller.goToNextPage,
                color: controller.currentPage.value <
                        controller.contentPaths.length - 1
                    ? Colors.black
                    : Colors.grey,
              ),
            ],
          )),
    );
  }
}
