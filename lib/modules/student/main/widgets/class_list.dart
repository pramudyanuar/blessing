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

    return SliverPadding(
      padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.w),
      sliver: Obx(() {
        final isLoading = controller.isLoadingSubjects.value;
        final subjects = controller.filteredSubjectList;
        final hasSearch = controller.searchQuery.value.isNotEmpty;
        final isEmpty = subjects.isEmpty;

        final hasItems = !isLoading && !isEmpty;
        final totalCount = hasItems ? 2 + subjects.length : 3;

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == 0) {
                return GlobalText.bold(
                  "Mata Pelajaran",
                  fontSize: 16.sp,
                  color: Colors.black,
                  textAlign: TextAlign.left,
                );
              }

              if (index == 1) {
                return SizedBox(height: 16.h);
              }

              if (isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (isEmpty) {
                return Center(
                  child: Text(
                    hasSearch
                        ? "Mata pelajaran tidak ditemukan."
                        : "Tidak ada mata pelajaran yang tersedia.",
                  ),
                );
              }

              final subjectIndex = index - 2;
              final subject = subjects[subjectIndex];
              return ClassCard(
                subjectId: subject.id,
                subjectName: subject.subjectName ?? 'Tanpa Nama',
                imageUrl: ClassCard.getImageForSubject(subject.subjectName),
                classLevel: controller.classInfo.value,
                subtitle: 'SMA Blessing',
              );
            },
            childCount: totalCount,
          ),
        );
      }),
    );
  }
}
