import 'package:blessing/data/user/repository/user_repository_impl.dart';
import 'package:get/get.dart';
import 'package:blessing/modules/auth/login/controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserRepository());
    Get.lazyPut(() => LoginController());
  }
}
