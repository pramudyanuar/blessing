// lib/modules/admin/course/controllers/create_quiz_controller.dart

import 'dart:io'; // <-- Tambahkan import
import 'package:blessing/core/global_components/custom_snackbar.dart';
import 'package:blessing/data/core/models/content_block.dart';
import 'package:blessing/data/core/models/question_model.dart';
import 'package:blessing/data/quiz/models/request/create_question_option_request.dart';
import 'package:blessing/data/quiz/models/request/create_question_request.dart';
import 'package:blessing/data/quiz/models/request/create_quiz_answer_request.dart';
import 'package:blessing/data/quiz/models/request/create_quiz_request.dart';
import 'package:blessing/data/quiz/repository/question_option_repository.dart';
import 'package:blessing/data/quiz/repository/question_repository_impl.dart';
import 'package:blessing/data/quiz/repository/quiz_answer_repository_impl.dart';
import 'package:blessing/data/quiz/repository/quiz_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart'; // <-- Tambahkan import

class CreateQuizController extends GetxController {
  final TextEditingController quizTitleController = TextEditingController();
  final TextEditingController timeLimitController = TextEditingController();
  final RxList<QuestionModel> questions = <QuestionModel>[].obs;

  // --- REPOSITORIES ---
  final QuizRepository _quizRepository = Get.find();
  final QuestionRepository _questionRepository = Get.find();
  final QuestionOptionRepository _questionOptionRepository = Get.find();
  final QuizAnswerRepository _quizAnswerRepository = Get.find();

  // --- END REPOSITORIES ---

  // --- BARU ---
  final ImagePicker _picker = ImagePicker();
  // --- SELESAI BARU ---

  final RxBool isLoading = false.obs;
  late final String courseId;
  Function? onQuizCreated; // Callback untuk refresh data quiz

  @override
  void onInit() {
    super.onInit();
    addQuestion();
    courseId = (Get.arguments as Map<String, dynamic>)['courseId'];
    onQuizCreated =
        Get.arguments['onQuizCreated']; // Ambil callback dari arguments
  }

  void addQuestion() {
    questions.add(QuestionModel());
  }

  void removeQuestion(int index) {
    if (questions.length > 1) {
      questions[index].dispose();
      questions.removeAt(index);
    } else {
      Get.snackbar("Gagal", "Kuis harus memiliki setidaknya satu pertanyaan.",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

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

  void removeOption(int questionIndex, int optionIndex) {
    final question = questions[questionIndex];
    if (question.optionControllers.length > 2) {
      // Minimal 2 opsi
      question.optionControllers[optionIndex].dispose();
      question.optionControllers.removeAt(optionIndex);
    } else {
      Get.snackbar(
          "Gagal", "Pertanyaan harus memiliki setidaknya dua opsi jawaban.",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // --- FUNGSI BARU UNTUK GAMBAR ---
  Future<void> pickImageForQuestion(int questionIndex) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery, // Bisa juga diganti ImageSource.camera
        imageQuality: 80, // Kompresi gambar agar tidak terlalu besar
      );

      if (pickedFile != null) {
        questions[questionIndex].imageFile.value = File(pickedFile.path);
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal memilih gambar: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void removeImageForQuestion(int questionIndex) {
    questions[questionIndex].imageFile.value = null;
  }
  // --- SELESAI FUNGSI BARU ---

  // --- FUNGSI BARU UNTUK VALIDASI ---
  bool _validateInputs() {
    // Validasi nama kuis
    if (quizTitleController.text.trim().isEmpty) {
      _showErrorMessage("Nama kuis tidak boleh kosong.");
      return false;
    }

    // Validasi batas waktu - WAJIB diisi dan harus angka positif
    if (timeLimitController.text.trim().isEmpty) {
      _showErrorMessage("Batas waktu harus diisi.");
      return false;
    }

    final timeLimit = int.tryParse(timeLimitController.text.trim());
    if (timeLimit == null || timeLimit <= 0) {
      _showErrorMessage("Batas waktu harus berupa angka positif.");
      return false;
    }

    // Validasi pertanyaan
    if (questions.isEmpty) {
      _showErrorMessage("Kuis harus memiliki setidaknya satu pertanyaan.");
      return false;
    }

    for (int i = 0; i < questions.length; i++) {
      final question = questions[i];

      // Validasi deskripsi pertanyaan
      if (question.descriptionController.text.trim().isEmpty) {
        _showErrorMessage("Pertanyaan ${i + 1} tidak boleh kosong.");
        return false;
      }

      // Validasi opsi jawaban
      if (question.optionControllers.length < 2) {
        _showErrorMessage("Pertanyaan ${i + 1} harus memiliki setidaknya 2 opsi jawaban.");
        return false;
      }

      // Validasi isi opsi jawaban
      for (int j = 0; j < question.optionControllers.length; j++) {
        if (question.optionControllers[j].text.trim().isEmpty) {
          _showErrorMessage("Opsi ${j + 1} pada pertanyaan ${i + 1} tidak boleh kosong.");
          return false;
        }
      }
    }

    return true;
  }

  // --- FUNGSI UNTUK MENAMPILKAN PESAN ERROR DENGAN WARNA MERAH DAN TANDA X ---
  void _showErrorMessage(String message) {
    Get.snackbar(
      "",
      "",
      titleText: Row(
        children: [
          Icon(Icons.close, color: Colors.white, size: 20),
          SizedBox(width: 8),
          Text(
            "Error",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      messageText: Text(
        message,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
      backgroundColor: Colors.red.shade600,
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 4),
      margin: EdgeInsets.all(16),
      borderRadius: 8,
      icon: Icon(Icons.close, color: Colors.white),
    );
  }

  // --- FUNGSI UNTUK UPLOAD KUIS ---
  // lib/modules/admin/course/controllers/create_quiz_controller.dart

  // --- FUNGSI UNTUK UPLOAD KUIS ---
  Future<void> uploadQuiz() async {
    // Validasi input sebelum upload
    if (!_validateInputs()) {
      return;
    }

    isLoading.value = true;
    try {
      // 1. Buat Kuis
      final createQuizRequest = CreateQuizRequest(
        quizName: quizTitleController.text,
        courseId: courseId,
        timeLimit: int.tryParse(timeLimitController.text),
      );

      // Panggil repository dan simpan hasilnya (objek QuizResponse)
      final newQuiz = await _quizRepository.createQuiz(createQuizRequest);

      // Periksa apakah pembuatan kuis berhasil (objek tidak null)
      if (newQuiz != null) {
        // DAPATKAN ID LANGSUNG DARI OBJEK YANG DIKEMBALIKAN. TIDAK PERLU SEARCH LAGI.
        final newQuizId = newQuiz.id;

        for (final questionModel in questions) {
          String? imageUrl;

          if (questionModel.imageFile.value != null) {
            imageUrl = await _questionRepository.uploadQuestionImage(
              questionModel.imageFile.value!,
            );
          }

          final createQuestionRequest = CreateQuestionRequest(
            content: [
              ContentBlock(
                type: 'text',
                data: questionModel.descriptionController.text,
              ),
              if (imageUrl != null && imageUrl.isNotEmpty)
                ContentBlock(
                  type: 'image',
                  data: imageUrl,
                ),
            ],
            quizId: newQuizId, // <-- Sekarang menggunakan ID yang 100% benar
          );

          // (ASUMSI) Terapkan pola yang sama untuk `createQuestion`.
          // Pastikan `createQuestion` juga mengembalikan objek QuestionResponse.
          final newQuestion = await _questionRepository.createQuestion(
            createQuestionRequest,
          );

          if (newQuestion != null) {
            // Dapatkan ID pertanyaan yang baru secara langsung
            final newQuestionId = newQuestion.id;

            for (final optionController in questionModel.optionControllers) {
              final createOptionRequest = CreateQuestionOptionRequest(
                option: optionController.text,
              );
              await _questionOptionRepository.createOption(
                newQuestionId, // <-- Gunakan ID pertanyaan yang benar
                createOptionRequest,
              );
            }

            final options =
                await _questionOptionRepository.getAllOptionsByQuestionId(
              newQuestionId,
            );

            if (options != null && options.options.isNotEmpty) {
              final correctOptionId =
                  options.options[questionModel.correctAnswerIndex.value].id;

              final createAnswerRequest = CreateQuizAnswerRequest(
                optionId: correctOptionId,
              );
              await _quizAnswerRepository.createQuizAnswer(createAnswerRequest);
            }
          }
        }

        CustomSnackbar.show(
            title: "Sukses", message: "Kuis berhasil diunggah.");

        // Tunggu sebentar agar user bisa melihat notifikasi sukses
        await Future.delayed(const Duration(seconds: 1));

        // Kembali ke halaman sebelumnya
        Get.back(closeOverlays: true);
        // Panggil callback untuk refresh data quiz di halaman sebelumnya
        if (onQuizCreated != null) {
          onQuizCreated!();
        }
      } else {
        _showErrorMessage("Gagal membuat kuis. Silakan coba lagi.");
      }
    } catch (e) {
      _showErrorMessage("Terjadi kesalahan: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }  @override
  void onClose() {
    quizTitleController.dispose();
    timeLimitController.dispose();
    for (var question in questions) {
      question.dispose();
    }
    super.onClose();
  }
}
