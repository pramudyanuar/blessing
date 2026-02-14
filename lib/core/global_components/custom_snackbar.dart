import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackbar {
  static void show({
    required String title,
    required String message,
    bool isError = false,
    IconData? icon,
  }) {
    // Tutup snackbar lama biar nggak bentrok
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }

    Get.snackbar(
      title,
      message,
      icon: Icon(
        icon ?? (isError ? Icons.error_rounded : Icons.check_circle_rounded),
        color: Colors.white,
        size: 28,
      ),
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(12),
      borderRadius: 16,
      backgroundColor:
          isError ? const Color(0xFFE53935) : const Color(0xFF43A047),
      colorText: Colors.white,
      shouldIconPulse: true,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.15),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
      duration: const Duration(seconds: 2),
      animationDuration: const Duration(milliseconds: 400),
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
    );
  }
}
