import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:blessing/modules/admin/report_card/controller/admin_report_card_controller.dart';
import 'package:blessing/modules/admin/report_card/widgets/admin_quiz_card.dart';
import 'package:blessing/modules/admin/report_card/widgets/admin_analytics_summary.dart';
import 'package:blessing/modules/admin/report_card/widgets/admin_filter_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AdminReportCardScreen extends StatelessWidget {
  const AdminReportCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminReportCardController>();

    return BaseWidgetContainer(
      backgroundColor: AppColors.c5,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        leading: Padding(
          padding: EdgeInsets.only(left: 12.w),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Get.back(),
          ),
        ),
        titleSpacing: 0.2,
        leadingWidth: 40.w,
        title: Obx(() => GlobalText.medium(
              "Report Card - ${controller.userName.value}",
              fontSize: 16.sp,
            )),
        backgroundColor: AppColors.c1,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.c2),
            onPressed: () => controller.refreshData(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64.w,
                  color: Colors.red,
                ),
                SizedBox(height: 16.h),
                GlobalText.medium(
                  controller.errorMessage.value,
                  fontSize: 16.sp,
                  color: Colors.red,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () => controller.refreshData(),
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.refreshData(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Analytics Summary
                AdminAnalyticsSummary(),
                SizedBox(height: 20.h),

                // Filter Section
                AdminFilterSection(),
                SizedBox(height: 20.h),

                // Quiz List Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GlobalText.semiBold(
                      "Riwayat Quiz",
                      fontSize: 18.sp,
                    ),
                    Obx(() => GlobalText.regular(
                          "${controller.filteredQuizzes.length} quiz",
                          fontSize: 14.sp,
                          color: Colors.grey.shade600,
                        )),
                  ],
                ),
                SizedBox(height: 12.h),

                // Quiz List
                Obx(() {
                  if (controller.filteredQuizzes.isEmpty) {
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(32.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.quiz_outlined,
                            size: 48.w,
                            color: Colors.grey.shade400,
                          ),
                          SizedBox(height: 12.h),
                          GlobalText.medium(
                            "Tidak ada quiz ditemukan",
                            fontSize: 16.sp,
                            color: Colors.grey.shade600,
                          ),
                          SizedBox(height: 8.h),
                          GlobalText.regular(
                            "Coba ubah filter untuk melihat data lainnya",
                            fontSize: 14.sp,
                            color: Colors.grey.shade500,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.filteredQuizzes.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final quiz = controller.filteredQuizzes[index];
                      return AdminQuizCard(quiz: quiz);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      }),
    );
  }
}
