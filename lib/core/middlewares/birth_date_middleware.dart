import 'package:blessing/core/utils/app_routes.dart';
import 'package:blessing/core/utils/cache_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BirthDateMiddleware extends GetMiddleware {
  static const String birthDateCheckKey = 'requireBirthDateSetup';

  @override
  Future<GetNavConfig?> redirectDelegate(GetNavConfig route) async {
    try {
      final cacheUtil = CacheUtil();
      final userData = await cacheUtil.getData('user_data');

      if (userData != null) {
        final birthDate = userData['birth_date'];
        
        // Check apakah birth_date kosong/null atau default date (0001-01-01)
        bool isBirthDateEmpty = false;
        
        if (birthDate == null) {
          isBirthDateEmpty = true;
        } else if (birthDate is String) {
          final cleanDate = birthDate.trim();
          isBirthDateEmpty = cleanDate.isEmpty || 
                            cleanDate.startsWith('0001-') ||
                            cleanDate == '0001-01-01T00:00:00Z';
        } else if (birthDate is DateTime) {
          // Check apakah DateTime adalah default (year 1 atau sebelumnya)
          isBirthDateEmpty = birthDate.year <= 1;
        }
        
        debugPrint('BirthDateMiddleware: birthDate=$birthDate, isEmpty=$isBirthDateEmpty');
        
        // Jika tanggal lahir belum diisi, redirect ke profile setup
        if (isBirthDateEmpty) {
          debugPrint('BirthDateMiddleware: Birth date not set, redirecting to profile setup');
          return GetNavConfig.fromRoute(AppRoutes.profile);
        }
      }
    } catch (e) {
      debugPrint('BirthDateMiddleware Error: $e');
    }

    return null;
  }
}
