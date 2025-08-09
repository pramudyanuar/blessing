import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuestionModel {
  // Controller untuk teks deskripsi/pertanyaan
  final TextEditingController descriptionController;

  // Daftar reaktif yang berisi controller untuk setiap opsi jawaban
  final RxList<TextEditingController> optionControllers;

  QuestionModel()
      : descriptionController = TextEditingController(),
        optionControllers = <TextEditingController>[].obs {
    // Setiap pertanyaan baru otomatis dibuat dengan 2 opsi awal
    optionControllers.add(TextEditingController());
    optionControllers.add(TextEditingController());
  }

  // Fungsi untuk membersihkan semua controller dari memori
  void dispose() {
    descriptionController.dispose();
    for (var controller in optionControllers) {
      controller.dispose();
    }
  }
}
