import 'package:blessing/modules/admin/subject/controller/admin_manage_subject_controller.dart';
import 'package:get/get.dart';

class AdminManageSubjectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminManageSubjectController>(() => AdminManageSubjectController());
  }
}