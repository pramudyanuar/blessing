
import 'package:blessing/data/subject/repository/subject_repository_impl.dart';
import 'package:blessing/modules/admin/homepage/controller/admin_create_subject_controller.dart';
import 'package:get/get.dart';

class AdminCreateSubjectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminCreateSubjectController>(() => AdminCreateSubjectController());
    Get.lazyPut<SubjectRepository>(() => SubjectRepository());
  }
}
