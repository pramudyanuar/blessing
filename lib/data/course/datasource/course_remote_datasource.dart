import 'dart:io';

import 'package:blessing/core/services/endpoints.dart';
import 'package:blessing/core/services/http_manager.dart';
import 'package:blessing/data/core/models/paging_response.dart';
import 'package:blessing/data/course/models/response/course_response.dart';
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
