import 'package:blessing/modules/admin/manage_student/controller/admin_manage_student_controller.dart';
import 'package:get/get.dart';

class AdminManageStudentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminManageStudentController>(() => AdminManageStudentController());
  }
}
