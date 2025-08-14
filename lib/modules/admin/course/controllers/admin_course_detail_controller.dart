import 'package:blessing/data/course/models/response/course_response.dart';
import 'package:blessing/data/course/repository/course_repository_impl.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class AdminCourseDetailController extends GetxController {
  final _repository = Get.find<CourseRepository>();

  final course = Rxn<CourseResponse>();
  final isLoading = false.obs;

  late final String courseId;

  // State untuk editing
  final isEditing = false.obs;
  final editedCourseName = ''.obs;
  final editedContents = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    courseId = Get.arguments['courseId'] ?? '';
    if (courseId.isNotEmpty) {
      fetchCourseDetail();
    }
  }

  Future<void> fetchCourseDetail() async {
    try {
      isLoading.value = true;
      final result = await _repository.adminGetCourseById(courseId);
      if (result != null) {
        course.value = result;
      }
    } catch (e) {
      debugPrint('Error fetchCourseDetail: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void startEditing() {
    if (course.value != null) {
      editedCourseName.value = course.value!.courseName ?? '';
      // hanya ambil konten type text
      editedContents.value = course.value!.content!
          .where((c) => c.type == 'text')
          .map((c) => c.data)
          .toList();
      isEditing.value = true;
    }
  }

  Future<void> deleteCourse() async {
    try {
      isLoading.value = true;
      final success = await _repository.adminDeleteCourse(courseId);
      if (success) {
        Get.back(); // keluar dialog konfirmasi
        Get.back(); // keluar dari detail page
        Get.snackbar('Berhasil', 'Materi berhasil dihapus');
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
        // konten non-text tidak diubah
        return {
          "type": c.type,
          "data": c.data,
        };
      }
    }).toList();

    try {
      final success = await _repository.adminUpdateCourse(
        courseId: courseId,
        courseName: editedCourseName.value,
        content: updatedContent,
        gradeLevel: course.value!.gradeLevel ?? 0,
      );

      if (success) {
        await fetchCourseDetail();
        isEditing.value = false;
      } else {
        debugPrint("Update course gagal di backend");
      }
    } catch (e) {
      debugPrint("Error saving edits: $e");
    }
  }
}
