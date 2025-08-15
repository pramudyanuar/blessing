import 'package:blessing/data/core/models/paging_response.dart';
import 'package:blessing/data/course/datasource/course_remote_datasource.dart';
import 'package:blessing/data/course/models/response/course_response.dart';
import 'package:blessing/data/course/models/response/course_with_quizzes_response.dart';
import 'package:blessing/data/course/models/response/user_course_response.dart';
import 'package:flutter/foundation.dart';

class CourseRepository {
  // Instansiasi datasource secara langsung sesuai dengan pola yang ada
  final CourseDataSource _dataSource = CourseDataSource();

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

  Future<List<CourseResponse>?> adminGetAllCoursesWithoutPaging() async {
    try {
      final List<CourseResponse> allCourses = [];
      int currentPage = 1;
      int totalPages = 1; // Nilai awal agar loop berjalan setidaknya sekali
      const int pageSize = 50; // Ambil 50 data per request agar lebih efisien

      while (currentPage <= totalPages) {
        // Panggil metode paginasi yang sudah ada
        final result = await _dataSource.adminGetAllCourses(
          page: currentPage,
          size: pageSize,
        );

        // Jika salah satu halaman gagal diambil, gagalkan seluruh proses
        if (result == null) {
          debugPrint(
              'Gagal mengambil data halaman $currentPage. Proses dibatalkan.');
          return null; // Mengembalikan null untuk menandakan kegagalan
        }

        // Tambahkan hasil dari halaman saat ini ke daftar utama
        allCourses.addAll(result.courses);

        // Perbarui total halaman dari informasi paging di respons
        // Ini hanya perlu dilakukan sekali, tapi aman dilakukan di setiap iterasi
        totalPages = result.paging.totalPage;

        // Pindah ke halaman berikutnya untuk iterasi selanjutnya
        currentPage++;
      }

      debugPrint(
          'Sukses mengambil semua ${allCourses.length} course dari $totalPages halaman.');
      return allCourses;
    } catch (e) {
      debugPrint(
          'Error in CourseRepository (adminGetAllCoursesWithoutPaging): $e');
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
          subjectId: subjectId);
    } catch (e) {
      debugPrint('Error in CourseRepository (adminPostCourse): $e');
      return false;
    }
  }

  // =========================================================================
  // FUNGSI BARU DITAMBAHKAN DI SINI
  // Fungsi ini untuk mengambil data user course permission DENGAN PAGINASI.
  // =========================================================================
  Future<({List<UserCourseResponse> userCourses, PagingResponse paging})?>
      adminGetUserCoursesByCourseId({
    required String courseId,
    int page = 1,
    int size = 10,
  }) async {
    try {
      return await _dataSource.adminGetUserCoursesByCourseId(
        courseId: courseId,
        page: page,
        size: size,
      );
    } catch (e) {
      debugPrint(
          'Error in CourseRepository (adminGetUserCoursesByCourseId): $e');
      return null;
    }
  }

  // =========================================================================
  // FUNGSI INI SUDAH ADA SEBELUMNYA
  // Fungsi ini untuk mengambil SEMUA data user course permission TANPA PAGINASI
  // dengan cara looping semua halaman dari datasource.
  // =========================================================================
  Future<List<UserCourseResponse>?> adminGetAllUserCoursesByCourseId({
    required String courseId,
  }) async {
    try {
      // Memanggil metode baru di datasource
      return await _dataSource.adminGetAllUserCoursesByCourseId(
        courseId: courseId,
      );
    } catch (e) {
      debugPrint(
          'Error in CourseRepository (adminGetAllUserCoursesByCourseId): $e');
      return null;
    }
  }

  Future<bool> adminAssignCoursesToUsers({
    required List<String> userIds,
    required List<String> courseIds,
  }) async {
    try {
      return await _dataSource.adminAssignCoursesToUsers(
        userIds: userIds,
        courseIds: courseIds,
      );
    } catch (e) {
      debugPrint('Error in CourseRepository (adminAssignCoursesToUsers): $e');
      return false;
    }
  }

  Future<bool> adminDeleteUserCourse(String userCourseId) async {
    try {
      return await _dataSource.adminDeleteUserCourse(userCourseId);
    } catch (e) {
      debugPrint('Error in CourseRepository (adminDeleteUserCourse): $e');
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

  Future<({List<CourseResponse> courses, PagingResponse paging})?>
      getAccessibleCourses({
    int page = 1,
    int size = 10,
  }) async {
    try {
      final result = await _dataSource.getAccessibleCourses(
        page: page,
        size: size,
      );
      return result;
    } catch (e) {
      // Log error dari repository layer
      debugPrint('Error in CourseRepository (getAccessibleCourses): $e');
      return null;
    }
  }

  Future<List<CourseWithQuizzesResponse>?>
      getAllAccessibleCoursesWithQuizzes() async {
    try {
      return await _dataSource.getAllAccessibleCoursesWithQuizzes();
    } catch (e) {
      debugPrint(
          'Error in CourseRepository (getAllAccessibleCoursesWithQuizzes): $e');
      return null;
    }
  }

  Future<List<CourseResponse>?> getAllAccessibleCourses() async {
    try {
      return await _dataSource.getAllAccessibleCourses();
    } catch (e) {
      debugPrint('Error in CourseRepository (getAllAccessibleCourses): $e');
      return null;
    }
  }

  Future<CourseWithQuizzesResponse?> getAccessibleCourseById(
      String courseId) async {
    try {
      return await _dataSource.getAccessibleCourseById(courseId);
    } catch (e) {
      debugPrint('Error in CourseRepository (getAccessibleCourseById): $e');
      return null;
    }
  }
}
