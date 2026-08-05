// lib/data/core/models/question_model.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuestionModel {
  final TextEditingController descriptionController = TextEditingController();
  final RxList<TextEditingController> optionControllers =
      <TextEditingController>[].obs;
  final Rx<File?> imageFile = Rx<File?>(null);
  final RxInt correctAnswerIndex = 0.obs; // <-- Tambahkan ini
  final TextEditingController explanationController = TextEditingController();
  final TextEditingController videoUrlController = TextEditingController();
  final Rx<File?> explanationImageFile = Rx<File?>(null);

  QuestionModel() {
    // Memulai dengan 2 opsi jawaban default
    optionControllers.add(TextEditingController());
    optionControllers.add(TextEditingController());
  }

  // Fungsi untuk membersihkan semua controller dari memori
  void dispose() {
    descriptionController.dispose();
    explanationController.dispose();
    videoUrlController.dispose();
    for (var controller in optionControllers) {
      controller.dispose();
    }
  }
}
