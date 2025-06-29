import 'package:blessing/modules/student/quiz_attempt/controller/quiz_attempt_controller.dart';
import 'package:get/get.dart';

class QuizAttemptBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuizAttemptController>(() => QuizAttemptController());
  }
}
