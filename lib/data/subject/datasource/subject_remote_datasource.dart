import 'package:blessing/core/services/endpoints.dart';
import 'package:blessing/core/services/http_manager.dart';
import 'package:blessing/data/core/models/paging_response.dart';
import 'package:blessing/data/subject/models/request/create_subject_request.dart';
import 'package:blessing/data/subject/models/request/update_subject_request.dart';
import 'package:blessing/data/subject/models/response/subject_response.dart';
import 'package:flutter/foundation.dart';

class SubjectDataSource {
  final HttpManager _httpManager = HttpManager();

  /// Mengambil semua mata pelajaran dengan paginasi.
  Future<({List<SubjectResponse> subjects, PagingResponse paging})?>
      getAllSubjects({
    int page = 1,
    int size = 10,
  }) async {
    try {
      final response = await _httpManager.restRequest(
        url: '${Endpoints.getAllSubjects}?page=$page&size=$size',
        method: HttpMethods.get,
      );

      if (response['statusCode'] == 200) {
        debugPrint('getAllSubjects DataSource response: ${response['data']}');

        final subjects = (response['data']['data'] as List)
            .map((e) => SubjectResponse.fromJson(e))
            .toList();

        final paging = PagingResponse.fromJson(response['data']['paging']);

        return (subjects: subjects, paging: paging);
      } else {
        debugPrint(
            'getAllSubjects DataSource failed: ${response['statusMessage']}');
        return null;
      }
    } catch (e) {
      debugPrint('getAllSubjects DataSource error: $e');
      return null;
    }
  }

  /// Mengambil semua data mata pelajaran tanpa paginasi (mengambil semua halaman).
  Future<List<SubjectResponse>> getAllSubjectsComplete() async {
    List<SubjectResponse> allSubjects = [];
    int page = 1;
    const int size = 100; // Ambil 100 item per halaman untuk efisiensi

    while (true) {
      final result = await getAllSubjects(page: page, size: size);
      if (result == null) break;

      allSubjects.addAll(result.subjects);

      // Jika data yang diterima kurang dari ukuran halaman, berarti ini halaman terakhir.
      if (result.subjects.length < size) {
        break;
      } else {
        page++;
      }
    }
    return allSubjects;
  }

  /// Membuat mata pelajaran baru (hanya untuk Admin).
  Future<SubjectResponse?> createSubject(CreateSubjectRequest data) async {
    try {
      final response = await _httpManager.restRequest(
        url: Endpoints.createSubjectForAdmin,
        method: HttpMethods.post,
        body: data.toJson(),
      );

      if (response['statusCode'] == 200 || response['statusCode'] == 201) {
        debugPrint('createSubject DataSource response: ${response['data']}');
        return SubjectResponse.fromJson(response['data']['data']);
      } else {
        debugPrint(
            'createSubject DataSource failed: ${response['statusMessage']}');
        return null;
      }
    } catch (e) {
      debugPrint('createSubject DataSource error: $e');
      return null;
    }
  }

  /// Memperbarui mata pelajaran (hanya untuk Admin).
  Future<SubjectResponse?> updateSubject(
      String subjectId, UpdateSubjectRequest data) async {
    try {
      final url = Endpoints.updateSubjectForAdmin
          .replaceFirst('{subjectId}', subjectId);

      final response = await _httpManager.restRequest(
        url: url,
        method: HttpMethods.put,
        body: data.toJson(),
      );

      if (response['statusCode'] == 200) {
        debugPrint('updateSubject DataSource response: ${response['data']}');
        return SubjectResponse.fromJson(response['data']['data']);
      } else {
        debugPrint(
            'updateSubject DataSource failed: ${response['statusMessage']}');
        return null;
      }
    } catch (e) {
      debugPrint('updateSubject DataSource error: $e');
      return null;
    }
  }

  /// Menghapus mata pelajaran (hanya untuk Admin).
  Future<SubjectResponse?> deleteSubject(String subjectId) async {
    try {
      final url = Endpoints.deleteSubjectForAdmin
          .replaceFirst('{subjectId}', subjectId);

      final response = await _httpManager.restRequest(
        url: url,
        method: HttpMethods.delete,
      );

      if (response['statusCode'] == 200) {
        debugPrint('deleteSubject DataSource success: ${response['data']}');
        // Beberapa API mungkin hanya mengembalikan status sukses tanpa body,
        // yang lain mengembalikan objek yang dihapus. Contoh ini mengasumsikan objek dikembalikan.
        return SubjectResponse.fromJson(response['data']['data']);
      } else {
        debugPrint(
            'deleteSubject DataSource failed: ${response['statusMessage']}');
        return null;
      }
    } catch (e) {
      debugPrint('deleteSubject DataSource error: $e');
      return null;
    }
  }
}
