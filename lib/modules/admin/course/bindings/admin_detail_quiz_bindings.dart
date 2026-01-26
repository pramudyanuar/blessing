import 'package:blessing/modules/admin/course/controllers/admin_detail_quiz_controller.dart';
import 'package:get/get.dart';

class AdminDetailQuizBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<AdminDetailQuizController>(() => AdminDetailQuizController());
  }
}