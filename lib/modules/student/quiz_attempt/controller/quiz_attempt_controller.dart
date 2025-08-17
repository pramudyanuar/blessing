import 'dart:async';
import 'package:blessing/core/global_components/global_confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuizAttemptController extends GetxController {
  // --- State & Data ---
  final RxInt totalDuration = 1800.obs;
  final RxInt remainingSeconds = 0.obs;
  Timer? _timer;

  final RxInt currentQuestionIndex = 0.obs;
  late final PageController pageController;

  final RxMap<int, int> userAnswers = <int, int>{}.obs;

  final List<Map<String, dynamic>> questions = List.generate(20, (index) {
    return {
      'image': 'assets/images/akutansi.webp',
      'options': ['5390', '759641', '45128', '425413', '11454'],
    };
  });

  // --- Lifecycle & Timer ---
  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
    startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    pageController.dispose();
    super.onClose();
  }

  void startTimer() {
    remainingSeconds.value = totalDuration.value;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        timer.cancel();
        Get.dialog(
          GlobalConfirmationDialog(
            message: "Waktu pengerjaan kuis telah berakhir.",
            onYes: () {
              Get.back();
            },
            onNo: () => Get.back(),
          ),
        );
      }
    });
  }

  String get timerText {
    final minutes = (remainingSeconds.value ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingSeconds.value % 60).toString().padLeft(2, '0');
    return "00:$minutes:$seconds";
  }

  // --- Logika Kuis ---
  void selectAnswer(int questionIndex, int answerIndex) {
    userAnswers[questionIndex] = answerIndex;
  }

  void nextPage() {
    if (currentQuestionIndex.value < questions.length - 1) {
      pageController.nextPage(
          duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
    }
  }

  void previousPage() {
    if (currentQuestionIndex.value > 0) {
      pageController.previousPage(
          duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
    }
  }

  void jumpToQuestion(int index) {
    pageController.jumpToPage(index);
    Get.back();
  }
}
