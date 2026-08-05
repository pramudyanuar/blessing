import 'package:flutter/material.dart';
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
      Get.snackbar(
        "Keluar Aplikasi",
        "Tekan sekali lagi untuk keluar dari aplikasi.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black87,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return false;
    }
    return true;
  }
}
