import 'package:blessing/data/course/repository/course_repository_impl.dart';
import 'package:blessing/data/subject/repository/subject_repository_impl.dart';
import 'package:blessing/modules/admin/course/controllers/course_list_controller.dart';
import 'package:get/get.dart';

class AdminManageCourseListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubjectRepository>(() => SubjectRepository());
    Get.lazyPut<CourseRepository>(() => CourseRepository());
    Get.lazyPut<AdminManageCourseListController>(() => AdminManageCourseListController());
  }
}
