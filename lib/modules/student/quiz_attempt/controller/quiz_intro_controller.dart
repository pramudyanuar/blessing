import 'package:blessing/data/quiz/repository/quiz_repository_impl.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
// TODO: Import repository kuis Anda di sini
// import 'package:blessing/data/quiz/repository/quiz_repository.dart';

class QuizIntroController extends GetxController {
  // --- Dependencies ---
  final QuizRepository _quizRepository = QuizRepository(); // Contoh

  // --- State & Data ---
  late final String quizId;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  // Untuk menyimpan detail kuis seperti judul, durasi, dll.
  final Rx<Map<String, dynamic>> quizDetails = Rx<Map<String, dynamic>>({});

  @override
  void onInit() {
    super.onInit();
    // Ambil quizId dari argument
    if (Get.arguments is String) {
      quizId = Get.arguments;
      fetchQuizDetails();
    } else {
      isLoading.value = false;
      errorMessage.value = "ID Kuis tidak valid.";
    }
  }


  Future<void> fetchQuizDetails() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _quizRepository.getQuizById(quizId);
      if (response != null) {
        quizDetails.value = {
          "title": response.quizName,
          "duration": response.timeLimit,
        };
      } else {
        throw Exception("Gagal memuat detail kuis.");
      }
    } catch (e) {
      errorMessage.value = e.toString();
      debugPrint("Error fetching quiz details: $e");
    } finally {
      isLoading.value = false;
    }
  }

  //dapatkan score dari myreport card, kalau sudah ada score maka langsung tampilkan saja, kalau belum ada bisa mulai kuisnya
}
