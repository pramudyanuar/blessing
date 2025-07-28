import 'package:blessing/modules/admin/homepage/controller/admin_homepage_controller.dart';
import 'package:get/get.dart';

class AdminHomepageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminHomepageController>(() => AdminHomepageController());
  }
}
