import 'package:blessing/data/core/models/question_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateQuizController extends GetxController {
  final TextEditingController quizTitleController = TextEditingController();

  // State utama sekarang adalah daftar (list) dari QuestionModel
  final RxList<QuestionModel> questions = <QuestionModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Mulai dengan satu pertanyaan saat layar dibuka
    addQuestion();
  }

  // Fungsi untuk menambah pertanyaan baru ke dalam list
  void addQuestion() {
    questions.add(QuestionModel());
  }

  // Fungsi untuk menghapus pertanyaan
  void removeQuestion(int index) {
    if (questions.length > 1) {
      questions[index].dispose(); // Hapus controllernya dari memori
      questions.removeAt(index);
    } else {
      Get.snackbar("Gagal", "Kuis harus memiliki setidaknya satu pertanyaan.",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Fungsi untuk menambah opsi PADA pertanyaan tertentu
  void addOption(int questionIndex) {
    final question = questions[questionIndex];
    if (question.optionControllers.length < 5) {
      question.optionControllers.add(TextEditingController());
    } else {
      Get.snackbar(
          "Batas Maksimal", "Anda hanya dapat menambahkan hingga 5 opsi.",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Fungsi untuk menghapus opsi PADA pertanyaan tertentu
  void removeOption(int questionIndex, int optionIndex) {
    final question = questions[questionIndex];
    if (question.optionControllers.length > 1) {
      question.optionControllers[optionIndex].dispose();
      question.optionControllers.removeAt(optionIndex);
    } else {
      Get.snackbar(
          "Gagal", "Pertanyaan harus memiliki setidaknya dua opsi jawaban.",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  void onClose() {
    quizTitleController.dispose();
    // Pastikan semua controller di setiap pertanyaan juga dibersihkan
    for (var question in questions) {
      question.dispose();
    }
    super.onClose();
  }
}
