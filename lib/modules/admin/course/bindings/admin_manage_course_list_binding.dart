import 'package:blessing/modules/admin/course/controllers/course_list_controller.dart';
import 'package:get/get.dart';

class AdminManageCourseListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminManageCourseListController>(() => AdminManageCourseListController());
  }
}
