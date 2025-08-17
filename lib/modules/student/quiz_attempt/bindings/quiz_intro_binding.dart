import 'package:blessing/modules/student/quiz_attempt/controller/quiz_intro_controller.dart';
import 'package:get/get.dart';

class QuizIntroBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => QuizIntroController());
  }
}