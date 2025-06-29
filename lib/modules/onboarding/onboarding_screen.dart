import 'package:blessing/modules/onboarding/controller/onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:blessing/core/constants/string.dart';
import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/core/global_components/global_button.dart';
import 'package:blessing/core/global_components/global_text.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});
  final OnboardingController controller = Get.find<OnboardingController>();
  final PageController pageController = PageController();
  final ValueNotifier<int> currentIndex = ValueNotifier(0);
  final ValueNotifier<double> buttonScale = ValueNotifier(1.0);

  @override
  Widget build(BuildContext context) {
    return BaseWidgetContainer(
      body: Stack(
        // Wrap the Column with Stack
        children: [
          Column(
            children: [
              // Rest of your existing Column content
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  onPageChanged: (index) => currentIndex.value = index,
                  itemCount: controller.images.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            transitionBuilder: (child, animation) =>
                                FadeTransition(
                                    opacity: animation, child: child),
                            child: Image.asset(
                              controller.images[index],
                              key: ValueKey(index),
                              height: 250.h,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: GlobalText.bold(
                              controller.titles[index],
                              key: ValueKey(index),
                              fontSize: 22.sp,
                              fontFamily: 'Inter',
                            ),
                          ),
                          SizedBox(height: 10.h),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: GlobalText.regular(
                              controller.descriptions[index],
                              key: ValueKey(index),
                              fontSize: 14.sp,
                              textAlign: TextAlign.center,
                              fontFamily: 'Inter',
                              color: Colors.grey[600] ?? Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Dots Indicator
              ValueListenableBuilder<int>(
                valueListenable: currentIndex,
                builder: (context, index, _) {
                  return SmoothPageIndicator(
                    controller: pageController,
                    count: controller.images.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: Colors.blue,
                      dotHeight: 5.h,
                      dotWidth: 5.w,
                    ),
                  );
                },
              ),

              SizedBox(height: 20.h),

              // Button Continue
              ValueListenableBuilder<double>(
                valueListenable: buttonScale,
                builder: (context, scale, child) {
                  return GestureDetector(
                    onTapDown: (_) => buttonScale.value = 0.95,
                    onTapUp: (_) {
                      buttonScale.value = 1.0;
                      if (currentIndex.value < controller.images.length - 1) {
                        pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        controller.completeOnboarding();
                      }
                    },
                    child: AnimatedScale(
                      scale: scale,
                      duration: const Duration(milliseconds: 100),
                      child: GlobalButton(
                        width: 200.w,
                        height: 40.h,
                        text: StringText.onBoardingButtonText,
                        onPressed: () {
                          if (currentIndex.value <
                              controller.images.length - 1) {
                            pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            controller.completeOnboarding();
                          }
                        },
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: 40.h),
            ],
          ),

          // Skip Button positioned on top of the Stack
          ValueListenableBuilder<int>(
            valueListenable: currentIndex,
            builder: (context, index, _) {
              return Positioned(
                top: 40.h,
                right: 20.w,
                child: Visibility(
                  visible: index < controller.images.length - 1,
                  child: TextButton(
                    onPressed: () {
                      controller.completeOnboarding();
                    },
                    child: GlobalText.regular('Skip',
                        fontSize: 14.sp, color: Colors.blue),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
