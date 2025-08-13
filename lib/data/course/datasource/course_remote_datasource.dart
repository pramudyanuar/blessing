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
}
