import 'package:blessing/modules/admin/subject/controller/admin_manage_subject_controller.dart';
import 'package:blessing/data/subject/repository/subject_repository_impl.dart';
import 'package:get/get.dart';

class AdminManageSubjectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminManageSubjectController>(() => AdminManageSubjectController());
  }
}

class AdminCreateSubjectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubjectRepository>(() => SubjectRepository());
  }
}