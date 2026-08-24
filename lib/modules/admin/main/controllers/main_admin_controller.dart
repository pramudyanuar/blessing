import 'package:blessing/core/global_components/custom_snackbar.dart';
import 'package:get/get.dart';

class MainAdminController extends GetxController {
  var selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  // Double-back to exit logic
  DateTime? _lastPressedAt;

  Future<bool> onWillPop() async {
    final now = DateTime.now();
    if (_lastPressedAt == null ||
        now.difference(_lastPressedAt!) > const Duration(seconds: 2)) {
      _lastPressedAt = now;
      CustomSnackbar.show(
        title: "Keluar Aplikasi",
        message: "Tekan sekali lagi untuk keluar dari aplikasi.",
      );
      return false;
    }
    return true;
  }
}
