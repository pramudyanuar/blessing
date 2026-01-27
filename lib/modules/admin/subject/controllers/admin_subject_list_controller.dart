import 'package:blessing/data/subject/models/response/subject_response.dart';
import 'package:blessing/data/subject/repository/subject_repository_impl.dart';
import 'package:blessing/core/global_components/custom_snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class AdminSubjectListController extends GetxController {
  final _subjectRepository = Get.find<SubjectRepository>();

  final RxBool isLoading = false.obs;
  final RxList<SubjectResponse> allSubjects = <SubjectResponse>[].obs;
  final RxList<SubjectResponse> filteredSubjects = <SubjectResponse>[].obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSubjects();

    // Listen to search query changes
    ever(searchQuery, (_) => _filterSubjects());
  }

  Future<void> fetchSubjects() async {
    try {
      isLoading.value = true;
      final result = await _subjectRepository.getAllSubjectsComplete();
      allSubjects.assignAll(result);
      _filterSubjects();
    } catch (e) {
      debugPrint('Error fetching subjects: $e');
      CustomSnackbar.show(title: 'Error', message: 'Gagal memuat mata pelajaran', isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void _filterSubjects() {
    final query = searchQuery.value.toLowerCase();

    if (query.isEmpty) {
      filteredSubjects.assignAll(allSubjects);
    } else {
      final results = allSubjects.where((subject) {
        return subject.subjectName?.toLowerCase().contains(query) ?? false;
      }).toList();
      filteredSubjects.assignAll(results);
    }
  }

  Future<void> deleteSubject(String subjectId) async {
    try {
      isLoading.value = true;
      final result = await _subjectRepository.deleteSubject(subjectId);
      if (result != null) {
        allSubjects.removeWhere((s) => s.id == subjectId);
        _filterSubjects();
        CustomSnackbar.show(title: 'Sukses', message: 'Mata pelajaran berhasil dihapus');
      } else {
        CustomSnackbar.show(title: 'Error', message: 'Gagal menghapus mata pelajaran', isError: true);
      }
    } catch (e) {
      CustomSnackbar.show(title: 'Error', message: 'Error: $e', isError: true);
    } finally {
      isLoading.value = false;
    }
  }
}
