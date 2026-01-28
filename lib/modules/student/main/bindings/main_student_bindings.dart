import 'package:blessing/data/subject/repository/subject_repository_impl.dart';
import 'package:blessing/data/user/repository/user_repository_impl.dart';
import 'package:blessing/modules/student/main/controllers/main_student_controllers.dart';
import 'package:get/get.dart';

class MainStudentBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainStudentController>(() => MainStudentController());
    Get.lazyPut<SubjectRepository>(() => SubjectRepository());
    Get.lazyPut<UserRepository>(() => UserRepository());
  }
}
