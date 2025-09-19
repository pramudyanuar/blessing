import 'package:blessing/core/utils/app_routes.dart';
import 'package:blessing/data/course/models/response/course_response.dart';
import 'package:blessing/data/course/repository/course_repository_impl.dart';
import 'package:blessing/data/quiz/models/response/quiz_response.dart'; // --- TAMBAHAN ---
import 'package:blessing/data/quiz/repository/quiz_repository_impl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminCourseDetailController extends GetxController {
  // Controller for course name editing
  final courseNameController = TextEditingController();
  // --- MODIFIKASI: Tambahkan QuizRepository ---
  final _courseRepository = Get.find<CourseRepository>();
  final _quizRepository = Get.find<QuizRepository>();

  final course = Rxn<CourseResponse>();
  final isLoading = false.obs;
  final selectedIndex = 0.obs;

  late final String courseId;

  // State untuk editing
  final isEditing = false.obs;
  final editedCourseName = ''.obs;
  final editedContents = <String>[].obs;

  // --- TAMBAHAN: State untuk Kuis ---
  final quizzes = <QuizResponse>[].obs;
  final isQuizLoading = false.obs;
  Function?
      onCourseDeleted; // Callback untuk refresh course list setelah delete

  @override
  void onInit() {
    super.onInit();
    courseId = Get.arguments['courseId'] ?? '';
    onCourseDeleted =
        Get.arguments['onCourseDeleted']; // Ambil callback dari arguments
    if (courseId.isNotEmpty) {
      fetchCourseDetail();
    }
    // Sync controller with observable
    ever(editedCourseName, (String name) {
      if (courseNameController.text != name) {
        courseNameController.text = name;
        courseNameController.selection = TextSelection.fromPosition(
          TextPosition(offset: courseNameController.text.length),
        );
      }
    });
  }

  Future<void> fetchCourseDetail() async {
    try {
      isLoading.value = true;
      final result = await _courseRepository.adminGetCourseById(courseId);
      if (result != null) {
        course.value = result;
        // --- TAMBAHAN: Panggil fetch kuis setelah materi didapat ---
        await fetchQuizzesForCourse();
      }
    } catch (e) {
      debugPrint('Error fetchCourseDetail: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // --- TAMBAHAN: Fungsi untuk mengambil data kuis ---
  Future<void> fetchQuizzesForCourse() async {
    try {
      isQuizLoading.value = true;
      quizzes.clear(); // Kosongkan list sebelum fetch baru
      final result = await _quizRepository.searchQuizzesByCourseId(
        courseId: courseId,
        page: 1,
        size: 20, // Ambil 5 kuis teratas, sesuaikan jika perlu
      );
      if (result != null && result.quizzes.isNotEmpty) {
        quizzes.value = result.quizzes;
      }
    } catch (e) {
      debugPrint('Error fetchQuizzesForCourse: $e');
      Get.snackbar('Error', 'Gagal memuat data kuis');
    } finally {
      isQuizLoading.value = false;
    }
  }

  void startEditing() {
    if (course.value != null) {
      editedCourseName.value = course.value!.courseName ?? '';
      editedContents.value = course.value!.content!
          .where((c) => c.type == 'text')
          .map((c) => c.data)
          .toList();
      isEditing.value = true;
      // Set controller text when editing starts
      courseNameController.text = editedCourseName.value;
      courseNameController.selection = TextSelection.fromPosition(
        TextPosition(offset: courseNameController.text.length),
      );
    }
  }

  Future<void> deleteCourse() async {
    try {
      isLoading.value = true;
      final success = await _courseRepository.adminDeleteCourse(courseId);
      if (success) {
        Get.snackbar('Berhasil', 'Materi berhasil dihapus');

        // Tunggu sebentar agar user bisa melihat notifikasi sukses
        await Future.delayed(const Duration(seconds: 1));

        // Gunakan Get.offNamed() untuk memastikan kembali ke course list
        Get.offNamed(AppRoutes.manageSubject);

        // Panggil callback untuk refresh course list
        if (onCourseDeleted != null) {
          onCourseDeleted!();
        }
      } else {
        Get.snackbar('Gagal', 'Materi gagal dihapus');
      }
    } catch (e) {
      debugPrint('Error deleteCourse: $e');
      Get.snackbar('Error', 'Terjadi kesalahan saat menghapus materi');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveEdits() async {
    if (course.value == null) return;

    // Update editedCourseName from controller before saving
    editedCourseName.value = courseNameController.text;

    final textContents =
        course.value!.content!.where((c) => c.type == 'text').toList();

    final updatedContent = course.value!.content!.map((c) {
      if (c.type == 'text') {
        final index = textContents.indexOf(c);
        return {
          "type": "text",
          "data": editedContents[index],
        };
      } else {
        return {
          "type": c.type,
          "data": c.data,
        };
      }
    }).toList();

    try {
      final success = await _courseRepository.adminUpdateCourse(
        courseId: courseId,
        courseName: editedCourseName.value,
        content: updatedContent,
        gradeLevel: course.value!.gradeLevel ?? 0,
      );

      if (success) {
        await fetchCourseDetail(); // fetch ulang semua data termasuk kuis
        isEditing.value = false;
      } else {
        debugPrint("Update course gagal di backend");
      }
    } catch (e) {
      debugPrint("Error saving edits: $e");
    }
  }
}
