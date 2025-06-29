import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/core/global_components/global_button.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:blessing/core/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class AccessDeniedScreen extends StatelessWidget {
  const AccessDeniedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseWidgetContainer(
      backgroundColor: Colors.white,
      body: Padding(
        // Padding utama untuk seluruh layar
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Column(
          children: [
            // BAGIAN KONTEN TENGAH
            // Expanded akan mengambil semua ruang kosong yang tersedia
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/lottie/no-access.json',
                      width: 0.6.sw,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.lock,
                          size: 100.sp,
                          color: Colors.grey.shade400,
                        );
                      },
                    ),
                    SizedBox(height: 24.h),
                    GlobalText.bold(
                      'Oops, Akses Ditolak!',
                      fontSize: 24.sp,
                      color: AppColors.c2,
                    ),
                    SizedBox(height: 8.h),
                    GlobalText.regular(
                      'Anda tidak memiliki izin untuk mengakses halaman ini. Silakan kembali dan coba login ulang.',
                      textAlign: TextAlign.center,
                      fontSize: 14.sp,
                      color: Colors.grey.shade600,
                      lineHeight: 1.5,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),

            // BAGIAN TOMBOL BAWAH
            // Tombol ini akan terdorong ke bawah karena widget Expanded di atasnya
            GlobalButton(
              width: double.infinity, // Lebarkan tombol sesuai padding
              height: 48.h,
              text: 'Kembali ke Login',
              onPressed: () {
                Get.offAllNamed(AppRoutes.login);
              },
            ),
          ],
        ),
      ),
    );
  }
}
