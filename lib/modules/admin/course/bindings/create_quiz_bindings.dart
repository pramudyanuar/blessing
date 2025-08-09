

import 'package:blessing/modules/admin/course/controllers/create_quiz_controller.dart';
import 'package:get/get.dart';

class CreateQuizBindings extends Bindings {
  @override
  void dependencies() {
    // Mendaftarkan controller agar bisa diakses oleh View
    Get.lazyPut<CreateQuizController>(() => CreateQuizController());
  }
}
