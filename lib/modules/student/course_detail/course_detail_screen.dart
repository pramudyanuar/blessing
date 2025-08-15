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
    // Dapatkan instance controller yang sudah di-initialize
    final controller = Get.find<CourseDetailController>();

    return BaseWidgetContainer(
      appBar: AppBar(
        backgroundColor: AppColors.c2,
        foregroundColor: Colors.white,
        // Judul AppBar akan reaktif terhadap nama course
        title: Obx(() => GlobalText.regular(
              controller.course.value?.courseName ?? 'Detail Materi',
              color: Colors.white,
            )),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Get.back(),
        ),
      ),
      // Body akan reaktif terhadap state dari controller
      body: Obx(() {
        // 1. Tampilkan loading indicator jika sedang memuat
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // 2. Tampilkan pesan error jika ada
        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Text(
                controller.errorMessage.value,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          );
        }

        // 3. Tampilkan pesan jika konten kosong
        if (controller.contentItems.isEmpty) {
          return const Center(child: Text("Materi ini tidak memiliki konten."));
        }

        // 4. Jika data berhasil dimuat, tampilkan konten menggunakan ListView
        return _buildContentView(controller);
      }),
    );
  }

  /// Widget untuk membangun tampilan konten dari List
  Widget _buildContentView(CourseDetailController controller) {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: controller.contentItems.length,
      itemBuilder: (context, index) {
        final content = controller.contentItems[index];
        final type = content['type'];
        final data = content['data'];

        // Render widget berdasarkan tipe konten
        switch (type) {
          case 'text':
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: GlobalText.regular(data.toString(), textAlign: TextAlign.start,),
            );
          case 'image':
            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                // Gunakan Image.network untuk memuat gambar dari URL
                child: Image.network(
                  data.toString(),
                  fit: BoxFit.cover,
                  // Tampilkan loading indicator saat gambar dimuat
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  // Tampilkan icon error jika gambar gagal dimuat
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image,
                        size: 50, color: Colors.grey);
                  },
                ),
              ),
            );
          // Anda bisa menambahkan case lain di sini, misalnya untuk PDF, video, dll.
          // case 'pdf':
          //   return SfPdfViewer.network(data.toString());
          default:
            return const SizedBox
                .shrink(); // Widget kosong untuk tipe tak dikenal
        }
      },
    );
  }
}
