import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackbar {
  static void show({
    required String title,
    required String message,
    bool isError = false,
    IconData? icon,
  }) {
    // Defer to the next frame: Get.overlayContext can point at an element
    // that's mid-teardown from a route transition if called synchronously
    // right after navigation (e.g. right after Get.offAllNamed), which makes
    // Overlay.of() fail even inside GetX's own SnackbarController.
    WidgetsBinding.instance.addPostFrameCallback((_) => _showNow(
          title: title,
          message: message,
          isError: isError,
          icon: icon,
        ));
  }

  static void _showNow({
    required String title,
    required String message,
    required bool isError,
    IconData? icon,
  }) {
    // Don't call Get.closeCurrentSnackbar() here: its internal controller is a
    // `late` field that's only initialized once a snackbar has actually been
    // shown, so closing "no snackbar yet" throws LateInitializationError.
    // Get.rawSnackbar already queues overlapping snackbars on its own.
    Get.rawSnackbar(
      titleText: Text(
        title,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      messageText: Text(
        message,
        style: const TextStyle(
          color: Colors.black54,
          fontSize: 12.5,
        ),
      ),
      icon: Icon(
        icon ?? (isError ? Icons.error_rounded : Icons.check_circle_rounded),
        color: isError ? const Color(0xFFD32F2F) : const Color(0xFF388E3C),
        size: 24,
      ),
      backgroundColor: Colors.white,
      borderRadius: 8,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
