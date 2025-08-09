// lib/modules/student/course/controllers/course_list_controller.dart

import 'package:blessing/core/utils/app_routes.dart';
import 'package:blessing/modules/student/course/widgets/course_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CourseItem {
  final CardType cardType;
  final String title;
  final String dateText;

  // Properti Materi
  final String? description;
  final String? fileName;
  final List<Widget>? previewImages;
  final VoidCallback? onTapDetail;

  // Properti Kuis
  final List<String>? quizDetails;
  final bool isCompleted;
  final int? score;
  final VoidCallback? onStart;

  CourseItem({
    required this.cardType,
    required this.title,
    required this.dateText,
    this.description,
    this.fileName,
    this.previewImages,
    this.onTapDetail,
    this.quizDetails,
    this.isCompleted = false,
    this.score,
    this.onStart,
  });
}

class AdminManageCourseListController extends GetxController {
  final RxString title = 'Mata Pelajaran'.obs;
  final RxString classLevel = ''.obs;
  final RxString imagePath = ''.obs;

  final RxList<CourseItem> courses = <CourseItem>[
    // Contoh Kuis Belum Dikerjakan
    CourseItem(
      cardType: CardType.quiz,
      title: 'Quiz 7',
      dateText: '3 hari yang lalu',
      quizDetails: ['Waktu Pengerjaan : 10 Menit', 'Jumlah Soal : 20 Soal'],
      isCompleted: false,
      onStart: () {
        Get.snackbar("Info", "Membuka halaman kuis...");
      },
    ),
    // Contoh Kuis Sudah Dikerjakan
    CourseItem(
      cardType: CardType.quiz,
      title: 'Quiz 6',
      dateText: '5 hari yang lalu',
      quizDetails: ['Waktu Pengerjaan : 10 Menit', 'Jumlah Soal : 20 Soal'],
      isCompleted: true,
      score: 98,
    ),
    // Contoh Materi
    CourseItem(
      cardType: CardType.material,
      title: 'Bab 5 : Geometri Ruang',
      description:
          'Materi lengkap tentang bangun ruang sisi datar dan lengkung.',
      fileName: 'geometri.pdf',
      dateText: '1 minggu yang lalu',
      onTapDetail: () => Get.toNamed(AppRoutes.courseDetail),
    ),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      title.value = arguments['title'] ?? 'Mata Pelajaran';
      classLevel.value = arguments['classLevel'] ?? 'Kelas 10';
    }
    imagePath.value = 'assets/images/bg-admin-subject.png';
  }
}
