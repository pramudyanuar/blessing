import 'package:blessing/modules/student/course_detail/controllers/course_detail_controller.dart';
import 'package:get/get.dart';

class CourseDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CourseDetailController>(() => CourseDetailController());
  }
}
