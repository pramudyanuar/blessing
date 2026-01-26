import 'package:blessing/data/course/repository/course_repository_impl.dart';
import 'package:blessing/modules/student/course_detail/controllers/course_detail_controller.dart';
import 'package:get/get.dart';

class CourseDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CourseDetailController>(() => CourseDetailController());
    Get.lazyPut<CourseRepository>(() => CourseRepository());
  }
}
