import 'package:blessing/data/user/repository/user_repository_impl.dart';
import 'package:blessing/modules/admin/manage_student/controller/detail_student_controller.dart';
import 'package:get/get.dart';

class DetailStudentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailStudentController>(() => DetailStudentController());
    Get.lazyPut<UserRepository>(() => UserRepository());
  }
}
