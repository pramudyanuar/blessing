import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/core/global_components/subject_appbar.dart';
import 'package:blessing/core/utils/app_routes.dart';
import 'package:blessing/modules/admin/course/controllers/course_list_controller.dart';
import 'package:blessing/modules/student/course/widgets/course_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AdminManageCourseListScreen extends StatelessWidget {
  const AdminManageCourseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Temukan instance controller yang disediakan oleh binding
    final controller = Get.find<AdminManageCourseController>();

    return BaseWidgetContainer(
      // Bungkus AppBar dengan Obx agar bisa update secara reaktif
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(180.h),
        child: Obx(() => SubjectAppbar(
              title: controller.title.value,
              classLevel: controller.classLevel.value,
              imagePath: controller.imagePath.value,
            )),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 20.h),
        child: Column(
          children: [
            // Konten di sini idealnya juga dinamis dari controller
            // Ganti data statis dengan ListView.builder yang mengambil data dari controller
            Obx(() => ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.courses.length,
                  itemBuilder: (context, index) {
                    final course = controller.courses[index];
                    return CourseCard(
                      title: course.title,
                      description: course.description,
                      fileName: course.fileName,
                      dateText: course.dateText,
                      onTapDetail: () {
                        // Navigasi ke detail course, tambahkan logika sesuai kebutuhan
                        // Contoh:
                        Get.toNamed(AppRoutes.courseDetail);
                      },
                    );
                  },
                )),
          ],
        ),
      ),
    );
  }
}
