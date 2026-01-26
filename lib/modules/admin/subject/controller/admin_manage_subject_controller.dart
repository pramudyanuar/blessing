import 'package:get/get.dart';

class AdminManageSubjectController extends GetxController {
  var selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}
