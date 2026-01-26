import 'package:blessing/data/user/repository/user_repository_impl.dart';
import 'package:blessing/modules/student/profile/controllers/profile_controller.dart';
import 'package:get/get.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<UserRepository>(() => UserRepository());
  }
}
