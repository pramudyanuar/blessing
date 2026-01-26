import 'package:blessing/data/course/repository/course_repository_impl.dart';
import 'package:blessing/data/user/repository/user_repository_impl.dart';
import 'package:blessing/modules/admin/course/controllers/admin_assign_user_controller.dart';
import 'package:get/get.dart';

class AdminAssignUserBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => AdminAssignUserController());
    Get.lazyPut(() => CourseRepository());
    Get.lazyPut(() => UserRepository());
  }
  
}