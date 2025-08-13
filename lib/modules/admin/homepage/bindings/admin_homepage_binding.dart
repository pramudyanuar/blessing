import 'package:blessing/data/subject/repository/subject_repository_impl.dart';
import 'package:blessing/data/user/repository/user_repository_impl.dart';
import 'package:blessing/modules/admin/homepage/controller/admin_homepage_controller.dart';
import 'package:get/get.dart';

class AdminHomepageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminHomepageController>(() => AdminHomepageController());
    Get.lazyPut<UserRepository>(() => UserRepository());
    Get.lazyPut<SubjectRepository>(() => SubjectRepository());
  }
}
