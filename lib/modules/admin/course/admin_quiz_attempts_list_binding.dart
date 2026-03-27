import 'package:get/get.dart';
import 'admin_quiz_attempts_list_controller.dart';

class AdminQuizAttemptsListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminQuizAttemptsListController>(
      () => AdminQuizAttemptsListController(),
    );
  }
}
