import 'package:blessing/modules/student/quiz/controllers/quiz_list_controller.dart';
import 'package:get/get.dart';

class QuizListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuizListController>(() => QuizListController());
  }
}
