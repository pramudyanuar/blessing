import 'package:blessing/core/global_components/global_text.dart';
import 'package:blessing/modules/student/main/controllers/main_student_controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'class_card.dart';

class ClassList extends StatelessWidget {
  const ClassList({super.key});

  @override
  Widget build(BuildContext context) {
    // Cari controller yang sudah di-inject di halaman MainStudent
    final controller = Get.find<MainStudentController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlobalText.bold(
          "Mata Pelajaran",
          fontSize: 16.sp,
          color: Colors.black,
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 16.h),
        Obx(() {
          if (controller.isLoadingSubjects.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Check the filtered list now
          if (controller.filteredSubjectList.isEmpty) {
            // Differentiate between no data at all vs. no search results
            if (controller.searchQuery.value.isNotEmpty) {
              return const Center(
                child: Text("Mata pelajaran tidak ditemukan."),
              );
            }
            return const Center(
              child: Text("Tidak ada mata pelajaran yang tersedia."),
            );
          }

          // Build the list using the filtered data
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.filteredSubjectList.length,
            itemBuilder: (context, index) {
              final subject = controller.filteredSubjectList[index];
              return ClassCard(
                subjectId: subject.id,
                subjectName: subject.subjectName ?? 'Tanpa Nama',
                imageUrl: ClassCard.getImageForSubject(subject.subjectName),
                classLevel: controller.classInfo.value,
                subtitle: 'SMA Blessing',
              );
            },
          );
        }),
      ],
    );
  }
}
