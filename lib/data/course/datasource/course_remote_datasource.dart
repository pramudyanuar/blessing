import 'dart:io';

import 'package:blessing/core/services/endpoints.dart';
import 'package:blessing/core/services/http_manager.dart';
import 'package:blessing/data/core/models/paging_response.dart';
import 'package:blessing/data/course/models/response/course_response.dart';
import 'package:blessing/data/course/models/response/course_with_quizzes_response.dart';
import 'package:blessing/data/course/models/response/user_course_response.dart';
import 'package:flutter/foundation.dart';

class CourseDataSource {
  final HttpManager _httpManager = HttpManager();

  Future<({List<CourseResponse> courses, PagingResponse paging})?>
      adminGetAllCourses({
    int page = 1,
    int size = 10,
  }) async {
    try {
      // Menambahkan query parameter untuk paginasi ke URL
      final url = '${Endpoints.getAllCourses}?page=$page&size=$size';

      final response = await _httpManager.restRequest(
        url: url,
        method: HttpMethods.get,
      );

      if (response['statusCode'] == 200) {
        debugPrint(
            'adminGetAllCourses DataSource response: ${response['data']}');

        // Parsing list of courses dari response['data']['data']
        final courses = (response['data']['data'] as List)
            .map((e) => CourseResponse.fromJson(e))
            .toList();

        // Parsing data paging dari response['data']['paging']
        final paging = PagingResponse.fromJson(response['data']['paging']);

        return (courses: courses, paging: paging);
      } else {
        debugPrint(
            'adminGetAllCourses DataSource failed: ${response['statusMessage']}');
        return null;
      }
    } catch (e) {
      debugPrint('adminGetAllCourses DataSource error: $e');
      return null;
    }
  }
  

  Future<CourseResponse?> adminGetCourseById(String courseId) async {
    try {
      final url = Endpoints.getCourseById.replaceFirst('{courseId}', courseId);

      final response = await _httpManager.restRequest(
        url: url,
        method: HttpMethods.get,
      );

      if (response['statusCode'] == 200) {
        debugPrint(
            'adminGetCourseById DataSource response: ${response['data']}');

        final data = response['data']['data'];
        return CourseResponse.fromJson(data);
      } else {
        debugPrint(
            'adminGetCourseById DataSource failed: ${response['statusMessage']}');
        return null;
      }
    } catch (e) {
      debugPrint('adminGetCourseById DataSource error: $e');
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
      final url =
          Endpoints.updateCourseForAdmin.replaceFirst('{courseId}', courseId);

      final body = {
        "course_name": courseName,
        "content": content,
        "grade_level": gradeLevel,
      };

      final response = await _httpManager.restRequest(
        url: url,
        method: HttpMethods.put,
        body: body,
      );

      if (response['statusCode'] == 200) {
        debugPrint('adminUpdateCourse DataSource success: ${response['data']}');
        return true;
      } else {
        debugPrint(
            'adminUpdateCourse DataSource failed: ${response['statusMessage']}');
        return false;
      }
    } catch (e) {
      debugPrint('adminUpdateCourse DataSource error: $e');
      return false;
    }
  }

  Future<String?> _uploadImage(File imageFile) async {
    try {
      final url = Endpoints.uploadCourseDataForAdmin;
      final response = await _httpManager.uploadFileRequest(
        url: url,
        file: imageFile,
        // Sesuaikan 'fileFieldKey' jika backend mengharapkan nama field yang berbeda, misal 'image'
        fileFieldKey: 'file',
      );

      if (response['statusCode'] == 200 && response['data'] != null) {
        // Berdasarkan JSON response Anda: { "data": { "url": "..." } }
        final imageUrl = response['data']['data']['url'];
        debugPrint('Image uploaded successfully: $imageUrl');
        return imageUrl;
      } else {
        debugPrint(
            'Image upload failed: ${response['statusCode']} - ${response['statusMessage']}');
        return null;
      }
    } catch (e) {
      debugPrint('Image upload error: $e');
      return null;
    }
  }

  Future<bool> adminPostCourse({
    required String courseName,
    required List<Map<String, dynamic>> content,
    required int gradeLevel,
    required String subjectId,
  }) async {
    try {
      // LANGKAH 1: Proses 'content' untuk mengunggah gambar dan mendapatkan URL
      final List<Map<String, dynamic>> processedContent = [];

      for (final item in content) {
        if (item['type'] == 'image' && item['data'] is File) {
          // Jika item adalah gambar, unggah terlebih dahulu
          File imageFile = item['data'];
          String? imageUrl = await _uploadImage(imageFile);

          if (imageUrl == null) {
            // Jika salah satu gambar gagal diunggah, gagalkan seluruh proses
            debugPrint('Failed to upload an image. Aborting course creation.');
            return false;
          }
          // Ganti File object dengan URL string yang didapat dari server
          processedContent.add({'type': 'image', 'data': imageUrl});
        } else {
          // Jika item adalah teks atau tipe lain, langsung tambahkan
          processedContent.add(item);
        }
      }

      // LANGKAH 2: Kirim data final ke endpoint pembuatan course
      debugPrint(
          'All images uploaded. Creating course with processed content...');

      final url = Endpoints.createCourseForAdmin;
      final body = {
        "course_name": courseName,
        "content": processedContent, // Gunakan content yang sudah diproses
        "grade_level": gradeLevel,
        "subject_id": subjectId, // Uncomment jika dibutuhkan
      };

      debugPrint('Payload for course creation: $body');

      final response = await _httpManager.restRequest(
        url: url,
        method: HttpMethods.post,
        body: body,
      );

      debugPrint(
          'adminPostCourse DataSource response: ${response['data']}');

      if (response['statusCode'] == 200 || response['statusCode'] == 201) {
        debugPrint('Course created successfully: ${response['data']}');
        return true;
      } else {
        debugPrint(
            'Course creation failed: ${response['statusCode']} - ${response['statusMessage']}');
        return false;
      }
    } catch (e) {
      debugPrint('adminPostCourse DataSource error: $e');
      return false;
    }
  }

  Future<({List<CourseResponse> courses, PagingResponse paging})?>
      getAccessibleCourses({
    int page = 1,
    int size = 10,
  }) async {
    try {
      final url =
          '${Endpoints.getAllAccessibleCourses}?page=$page&size=$size';

      final response = await _httpManager.restRequest(
        url: url,
        method: HttpMethods.get,
      );

      if (response['statusCode'] == 200) {
        debugPrint(
            'getAccessibleCourses DataSource response: ${response['data']}');

        // Respons berisi daftar objek UserCourseResponse.
        // Kita perlu mem-parsingnya terlebih dahulu.
        final userCourses = (response['data']['data'] as List)
            .map((e) => UserCourseResponse.fromJson(e))
            .toList();

        // Ekstrak objek CourseResponse dari setiap UserCourseResponse.
        final courses = userCourses.map((uc) => uc.course).toList();

        // Parsing data paging.
        final paging = PagingResponse.fromJson(response['data']['paging']);

        return (courses: courses, paging: paging);
      } else {
        debugPrint(
            'getAccessibleCourses DataSource failed: ${response['statusMessage']}');
        return null;
      }
    } catch (e) {
      debugPrint('getAccessibleCourses DataSource error: $e');
      return null;
    }
  }

  Future<bool> adminAssignCoursesToUsers({
    required List<String> userIds,
    required List<String> courseIds,
  }) async {
    try {
      final url = Endpoints.createUserCourseForAdmin;

      final body = {
        "user_ids": userIds,
        "course_ids": courseIds,
      };

      final response = await _httpManager.restRequest(
        url: url,
        method: HttpMethods.post,
        body: body,
      );

      // Biasanya API mengembalikan 200 (OK) atau 201 (Created) untuk operasi POST yang berhasil
      if (response['statusCode'] == 200 || response['statusCode'] == 201) {
        debugPrint(
            'adminAssignCoursesToUsers DataSource success: ${response['data']}');
        return true;
      } else {
        debugPrint(
            'adminAssignCoursesToUsers DataSource failed: ${response['statusMessage']}');
        return false;
      }
    } catch (e) {
      debugPrint('adminAssignCoursesToUsers DataSource error: $e');
      return false;
    }
  }

  Future<({List<UserCourseResponse> userCourses, PagingResponse paging})?>
      adminGetUserCoursesByCourseId({
    required String courseId,
    int page = 1,
    int size = 10,
  }) async {
    try {
      final url =
          '${Endpoints.manageAccessibleCoursesForAdmin}?page=$page&size=$size&course_id=$courseId';

      final response = await _httpManager.restRequest(
        url: url,
        method: HttpMethods.get,
      );

      if (response['statusCode'] == 200) {
        debugPrint(
            'adminGetUserCoursesByCourseId DataSource response: ${response['data']}');

        // Parsing list of user-courses dari response['data']['data']
        final userCourses = (response['data']['data'] as List)
            .map((e) => UserCourseResponse.fromJson(e))
            .toList();

        // Parsing data paging dari response['data']['paging']
        final paging = PagingResponse.fromJson(response['data']['paging']);

        return (userCourses: userCourses, paging: paging);
      } else {
        debugPrint(
            'adminGetUserCoursesByCourseId DataSource failed: ${response['statusMessage']}');
        return null;
      }
    } catch (e) {
      debugPrint('adminGetUserCoursesByCourseId DataSource error: $e');
      return null;
    }
  }

  Future<CourseWithQuizzesResponse?> getAccessibleCourseById(
      String courseId) async {
    try {
      // Mengganti placeholder {courseId} dengan ID yang sebenarnya.
      // Pastikan Endpoints.getAccessibleCourseById sudah didefinisikan dengan benar.
      final url = Endpoints.getAccessibleCourseById
          .replaceFirst('{courseId}', courseId);

      final response = await _httpManager.restRequest(
        url: url,
        method: HttpMethods.get,
      );

      if (response['statusCode'] == 200) {
        debugPrint(
            'getAccessibleCourseById DataSource response: ${response['data']}');

        // Berdasarkan struktur JSON, data utama ada di response['data']['data']
        final data = response['data']['data'];

        // Dari data tersebut, kita ambil object 'course' untuk diparsing.
        final courseJson = data['course'];

        // Parsing menggunakan CourseWithQuizzesResponse untuk mendapatkan detail kuis juga.
        return CourseWithQuizzesResponse.fromJson(courseJson);
      } else {
        debugPrint(
            'getAccessibleCourseById DataSource failed: ${response['statusMessage']}');
        return null;
      }
    } catch (e) {
      debugPrint('getAccessibleCourseById DataSource error: $e');
      return null;
    }
  }

  Future<List<UserCourseResponse>?> adminGetAllUserCoursesByCourseId({
    required String courseId,
  }) async {
    try {
      final List<UserCourseResponse> allUserCourses = [];
      int currentPage = 1;
      int totalPages =
          1; // Nilai awal, akan diperbarui setelah panggilan pertama
      const int pageSize = 50; // Ambil 50 item per panggilan agar lebih efisien

      // Lakukan perulangan selama halaman saat ini belum melewati total halaman
      while (currentPage <= totalPages) {
        // Panggil metode paginasi yang sudah ada
        final result = await adminGetUserCoursesByCourseId(
          courseId: courseId,
          page: currentPage,
          size: pageSize,
        );

        // Jika ada satu halaman yang gagal diambil, gagalkan seluruh proses
        if (result == null) {
          debugPrint(
              'Failed to fetch page $currentPage for course $courseId. Aborting operation.');
          return null;
        }

        // Tambahkan hasil dari halaman saat ini ke daftar utama
        allUserCourses.addAll(result.userCourses);

        // Perbarui total halaman dari informasi paging
        // Ini hanya perlu dilakukan sekali, tetapi aman untuk dilakukan di setiap iterasi
        totalPages = result.paging.totalPage;

        // Pindah ke halaman berikutnya untuk iterasi selanjutnya
        currentPage++;
      }

      debugPrint(
          'Successfully fetched all ${allUserCourses.length} user course permissions across $totalPages pages.');
      return allUserCourses;
    } catch (e) {
      debugPrint('adminGetAllUserCoursesByCourseId DataSource error: $e');
      return null;
    }
  }

  Future<bool> adminDeleteUserCourse(String userCourseId) async {
    try {
      final url = Endpoints.deleteUserCourseForAdmin
          .replaceFirst('{userCourseId}', userCourseId);

      final response = await _httpManager.restRequest(
        url: url,
        method: HttpMethods.delete,
      );

      if (response['statusCode'] == 200) {
        debugPrint('adminDeleteUserCourse DataSource success');
        return true;
      } else {
        debugPrint(
            'adminDeleteUserCourse DataSource failed: ${response['statusMessage']}');
        return false;
      }
    } catch (e) {
      debugPrint('adminDeleteUserCourse DataSource error: $e');
      return false;
    }
  }

    Future<List<CourseResponse>?> getAllAccessibleCourses() async {
    try {
      final List<CourseResponse> allCourses = [];
      int currentPage = 1;
      int totalPages = 1; // Nilai awal agar loop berjalan setidaknya sekali
      const int pageSize =
          50; // Ambil data dalam jumlah besar agar lebih efisien

      // Lakukan perulangan selama halaman saat ini belum melewati total halaman
      while (currentPage <= totalPages) {
        // Panggil metode paginasi yang sudah ada
        final result = await getAccessibleCourses(
          page: currentPage,
          size: pageSize,
        );

        // Jika salah satu halaman gagal diambil, gagalkan seluruh proses
        if (result == null) {
          debugPrint(
              'Gagal mengambil data halaman $currentPage. Proses dibatalkan.');
          return null;
        }

        // Tambahkan hasil dari halaman saat ini ke daftar utama
        allCourses.addAll(result.courses);

        // Perbarui total halaman dari informasi paging di respons
        totalPages = result.paging.totalPage;

        // Pindah ke halaman berikutnya untuk iterasi selanjutnya
        currentPage++;
      }

      debugPrint(
          'Sukses mengambil semua ${allCourses.length} course dari $totalPages halaman.');
      return allCourses;
    } catch (e) {
      debugPrint('getAllAccessibleCourses DataSource error: $e');
      return null;
    }
  }

    Future<List<CourseWithQuizzesResponse>?>
      getAllAccessibleCoursesWithQuizzes() async {
    try {
      final List<CourseWithQuizzesResponse> allCourses = [];
      int currentPage = 1;
      int totalPages = 1;
      const int pageSize = 50;

      while (currentPage <= totalPages) {
        final result = await _getPaginatedAccessibleCoursesWithQuizzes(
          page: currentPage,
          size: pageSize,
        );

        if (result == null) {
          debugPrint(
              'Gagal mengambil data course (halaman $currentPage). Proses dibatalkan.');
          return null;
        }

        allCourses.addAll(result.courses);
        totalPages = result.paging.totalPage;
        currentPage++;
      }

      debugPrint(
          'Sukses mengambil semua ${allCourses.length} course dengan detail kuis.');
      return allCourses;
    } catch (e) {
      debugPrint('getAllAccessibleCoursesWithQuizzes DataSource error: $e');
      return null;
    }
  }

  /// Fungsi helper paginasi yang mengembalikan model CourseWithQuizzesResponse.
  Future<({List<CourseWithQuizzesResponse> courses, PagingResponse paging})?>
      _getPaginatedAccessibleCoursesWithQuizzes({
    int page = 1,
    int size = 10,
  }) async {
    try {
      final url =
          '${Endpoints.getAllAccessibleCourses}?page=$page&size=$size';

      final response = await _httpManager.restRequest(
        url: url,
        method: HttpMethods.get,
      );

      if (response['statusCode'] == 200) {
        // Dari JSON response, kita ambil object 'course' di dalamnya
        // dan langsung parsing menggunakan model baru kita.
        final courses = (response['data']['data'] as List)
            .map((userCourseJson) =>
                CourseWithQuizzesResponse.fromJson(userCourseJson['course']))
            .toList();

        final paging = PagingResponse.fromJson(response['data']['paging']);

        return (courses: courses, paging: paging);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint(
          '_getPaginatedAccessibleCoursesWithQuizzes DataSource error: $e');
      return null;
    }
  }

  Future<bool> adminDeleteCourse(String courseId) async {
    try {
      final url =
          Endpoints.deleteCourseForAdmin.replaceFirst('{courseId}', courseId);

      final response = await _httpManager.restRequest(
        url: url,
        method: HttpMethods.delete,
      );

      if (response['statusCode'] == 200) {
        debugPrint('adminDeleteCourse DataSource success: ${response['data']}');
        return true;
      } else {
        debugPrint(
            'adminDeleteCourse DataSource failed: ${response['statusMessage']}');
        return false;
      }
    } catch (e) {
      debugPrint('adminDeleteCourse DataSource error: $e');
      return false;
    }
  }


}
