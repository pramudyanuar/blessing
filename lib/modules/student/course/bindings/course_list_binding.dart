import 'package:blessing/modules/student/course/controllers/course_list_controller.dart';
import 'package:get/get.dart';

class CourseListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CourseListController>(() => CourseListController());
  }
}
