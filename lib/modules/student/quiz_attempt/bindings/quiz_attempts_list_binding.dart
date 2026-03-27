// lib/modules/student/quiz_attempt/bindings/quiz_attempts_list_binding.dart

import 'package:blessing/modules/student/quiz_attempt/controller/quiz_attempts_list_controller.dart';
import 'package:get/get.dart';

class QuizAttemptsListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuizAttemptsListController>(
      () => QuizAttemptsListController(),
    );
  }
}
