import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/constants/images.dart';
import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/core/global_components/global_button.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:blessing/modules/auth/widgets/auth_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseWidgetContainer(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  Images.login,
                  height: 180.h,
                  width: 180.w,
                ),
                SizedBox(height: 20.h),
                GlobalText.bold(
                  'Login',
                  fontSize: 32.sp,
                  color: AppColors.c2,
                  fontFamily: 'Inter',
                ),
                SizedBox(height: 20.h),
                AuthTextField(
                    label: 'Username', hintText: 'Masukkan username anda'),
                SizedBox(height: 15.h),
                AuthTextField(
                  label: 'Password',
                  hintText: 'Masukkan password anda',
                  isPassword: true,
                ),
                SizedBox(height: 30.h),
                GlobalButton(
                  text: 'Login',
                  height: 47.h,
                  width: 317.w,
                  onPressed: () {},
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
