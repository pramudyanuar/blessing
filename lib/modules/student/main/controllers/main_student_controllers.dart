import 'package:get/get.dart';
import 'package:blessing/core/utils/cache_util.dart';

class MainStudentController extends GetxController {
  var name = ''.obs;
  var classInfo = ''.obs;
  var profileImageUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  void _loadUserData() async {
    final userData = await CacheUtil().getData('user_data');
    if (userData != null) {
      name.value = userData['username'] ?? '';
      classInfo.value = userData['grade_level'] != null
          ? 'Kelas ${userData['grade_level']}'
          : '';
    }
  }
}
