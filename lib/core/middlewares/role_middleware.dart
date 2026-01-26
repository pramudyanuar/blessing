import 'package:blessing/core/utils/app_routes.dart';
import 'package:blessing/core/utils/secure_storage_util.dart';
import 'package:get/get.dart';

class RoleMiddleware extends GetMiddleware {
  final String requiredRole;

  RoleMiddleware({required this.requiredRole});

  @override
  Future<GetNavConfig?> redirectDelegate(GetNavConfig route) async {
    final storage = Get.find<SecureStorageUtil>();
    final userRole = await storage.getUserRole();

    if (userRole != requiredRole) {
      return GetNavConfig.fromRoute(AppRoutes.accessDenied);
    }

    return null;
  }
}
