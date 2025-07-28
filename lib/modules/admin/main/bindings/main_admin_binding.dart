import 'package:blessing/modules/admin/main/controllers/main_admin_controller.dart';
import 'package:get/get.dart';

class MainAdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainAdminController>(() => MainAdminController());
  }
}
