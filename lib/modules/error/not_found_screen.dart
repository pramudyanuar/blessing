import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:blessing/core/global_components/global_button.dart';
import 'package:blessing/core/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseWidgetContainer(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(8.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/lottie/not-found.json',
                width: 0.6.sh,
                // height: 200.h,
                // fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Text('Error loading animation');
                },
              ),
              SizedBox(height: 16.h),
              GlobalText.medium(
                'Halaman yang Anda cari tidak ditemukan.',
                textAlign: TextAlign.center,
                fontSize: 10.sp,
              ),
              SizedBox(height: 16.h),
              GlobalButton(
                width: 200.w,
                height: 40.h,
                text: 'Kembali',
                onPressed: () {
                  Get.offAllNamed(AppRoutes.login);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
