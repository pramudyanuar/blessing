import 'package:blessing/data/course/repository/course_repository_impl.dart';
import 'package:blessing/data/quiz/repository/quiz_repository_impl.dart';
import 'package:blessing/modules/admin/course/controllers/admin_course_detail_controller.dart';
import 'package:get/get.dart';

class AdminCourseDetailBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminCourseDetailController>(
      () => AdminCourseDetailController(),
    );

    Get.lazyPut<CourseRepository>(() => CourseRepository());
    Get.lazyPut<QuizRepository>(() => QuizRepository());
  }
}
