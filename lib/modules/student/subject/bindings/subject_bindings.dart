import 'package:get/get.dart';
import 'package:blessing/modules/student/subject/controller/subject_controller.dart';

class SubjectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubjectController>(() => SubjectController());
  }
}