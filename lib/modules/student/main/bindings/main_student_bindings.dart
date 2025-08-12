import 'package:blessing/modules/student/main/controllers/main_student_controllers.dart';
import 'package:get/get.dart';

class MainStudentBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainStudentController>(() => MainStudentController());
  }
}
