import 'package:blessing/modules/admin/manage_student/controller/add_student_controller.dart';
import 'package:get/get.dart';

class AddStudentBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddStudentController>(() => AddStudentController());
  }
}
