import 'package:blessing/modules/admin/course/controllers/admin_manage_access_course_controller.dart';
import 'package:get/get.dart';

class AdminManageAccessCourseBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminManageAccessCourseController>(
        () => AdminManageAccessCourseController());
  }
}