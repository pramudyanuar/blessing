import 'package:blessing/modules/admin/subject/controller/admin_manage_subject_controller.dart';
import 'package:blessing/modules/admin/subject/controllers/admin_subject_list_controller.dart';
import 'package:blessing/data/subject/repository/subject_repository_impl.dart';
import 'package:get/get.dart';

class AdminManageSubjectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminManageSubjectController>(() => AdminManageSubjectController());
  }
}

class AdminSubjectListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubjectRepository>(() => SubjectRepository());
    Get.lazyPut<AdminSubjectListController>(
      () => AdminSubjectListController(),
    );
  }
}

class AdminCreateSubjectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubjectRepository>(() => SubjectRepository());
  }
}