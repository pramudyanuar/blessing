import 'package:blessing/data/core/models/paging_response.dart';
import 'package:blessing/data/course/datasource/course_remote_datasource.dart';
import 'package:blessing/data/course/models/response/course_response.dart';
import 'package:flutter/foundation.dart';

class CourseRepository {
  // Instansiasi datasource secara langsung sesuai dengan pola yang ada
  final CourseDataSource _dataSource = CourseDataSource();

  /// Memanggil datasource untuk mengambil semua course admin dengan paginasi.
  ///
  /// Meneruskan hasil atau null dari datasource.
  /// Penanganan error lebih lanjut bisa ditambahkan di sini jika diperlukan.
  Future<({List<CourseResponse> courses, PagingResponse paging})?>
      adminGetAllCourses({
    int page = 1,
    int size = 10,
  }) async {
    try {
      final result = await _dataSource.adminGetAllCourses(
        page: page,
        size: size,
      );
      return result;
    } catch (e) {
      // Log error dari repository layer
      debugPrint('Error in CourseRepository: $e');
      return null;
    }
  }

  Future<CourseResponse?> adminGetCourseById(String courseId) async {
    try {
      return await _dataSource.adminGetCourseById(courseId);
    } catch (e) {
      debugPrint('Error in CourseRepository (adminGetCourseById): $e');
      return null;
    }
  }

  Future<bool> adminUpdateCourse({
    required String courseId,
    required String courseName,
    required List<Map<String, dynamic>> content,
    required int gradeLevel,
  }) async {
    try {
      return await _dataSource.adminUpdateCourse(
        courseId: courseId,
        courseName: courseName,
        content: content,
        gradeLevel: gradeLevel,
      );
    } catch (e) {
      debugPrint('Error in CourseRepository (adminUpdateCourse): $e');
      return false;
    }
  }

  Future<bool> adminPostCourse({
    required String courseName,
    required List<Map<String, dynamic>> content,
    required int gradeLevel,
    required String subjectId,
  }) async {
    try {
      return await _dataSource.adminPostCourse(
        courseName: courseName,
        content: content,
        gradeLevel: gradeLevel,
        subjectId: subjectId
      );
    } catch (e) {
      debugPrint('Error in CourseRepository (adminPostCourse): $e');
      return false;
    }
  }

  Future<bool> adminDeleteCourse(String courseId) async {
    try {
      return await _dataSource.adminDeleteCourse(courseId);
    } catch (e) {
      debugPrint('Error in CourseRepository (adminDeleteCourse): $e');
      return false;
    }
  }


}
