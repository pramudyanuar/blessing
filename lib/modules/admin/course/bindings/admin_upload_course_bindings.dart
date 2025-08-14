import 'package:blessing/data/course/repository/course_repository_impl.dart';
import 'package:blessing/modules/admin/course/controllers/admin_upload_course_controller.dart';
import 'package:get/get.dart';

class AdminUploadCourseBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CourseRepository>(() => CourseRepository());
    Get.lazyPut<AdminUploadCourseController>(() => AdminUploadCourseController());
  }
}