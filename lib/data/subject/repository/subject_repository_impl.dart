import 'package:blessing/data/core/models/paging_response.dart';
import 'package:blessing/data/subject/datasource/subject_remote_datasource.dart';
import 'package:blessing/data/subject/models/request/create_subject_request.dart';
import 'package:blessing/data/subject/models/request/update_subject_request.dart';
import 'package:blessing/data/subject/models/response/subject_response.dart';

class SubjectRepository {
  final SubjectDataSource _dataSource = SubjectDataSource();

  /// Mengambil semua mata pelajaran dengan paginasi.
  Future<({List<SubjectResponse> subjects, PagingResponse paging})?>
      getAllSubjects({
    int page = 1,
    int size = 10,
  }) {
    return _dataSource.getAllSubjects(page: page, size: size);
  }

  /// Mengambil semua data mata pelajaran tanpa paginasi.
  Future<List<SubjectResponse>> getAllSubjectsComplete() {
    return _dataSource.getAllSubjectsComplete();
  }

  /// Membuat mata pelajaran baru (hanya untuk Admin).
  Future<SubjectResponse?> createSubject(CreateSubjectRequest request) {
    return _dataSource.createSubject(request);
  }

  /// Memperbarui mata pelajaran (hanya untuk Admin).
  Future<SubjectResponse?> updateSubject(
      String subjectId, UpdateSubjectRequest request) {
    return _dataSource.updateSubject(subjectId, request);
  }

  /// Menghapus mata pelajaran (hanya untuk Admin).
  Future<SubjectResponse?> deleteSubject(String subjectId) {
    return _dataSource.deleteSubject(subjectId);
  }
}
