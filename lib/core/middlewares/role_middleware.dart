import 'package:blessing/core/utils/app_routes.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class RoleMiddleware extends GetMiddleware {
  final String requiredRole;

  RoleMiddleware({required this.requiredRole});

  @override
  RouteSettings? redirect(String? route) {
    // final prefs = SharedPreferences.getInstance();
    // final userRole = prefs.getString('role');

    final userRole = 'student'; // Simulating a user role for demonstration purposes

    if (userRole != requiredRole) {
      return RouteSettings(name: AppRoutes.accessDenied);
    }
    return null;
  }
}
