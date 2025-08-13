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
}
