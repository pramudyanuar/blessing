import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:blessing/modules/student/report_card/controllers/report_card_controller.dart';
import 'package:blessing/modules/student/report_card/widgets/report_card_statistics.dart';
import 'package:blessing/modules/student/report_card/widgets/report_card_filters.dart';
import 'package:blessing/modules/student/report_card/widgets/quiz_report_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ReportCardScreen extends StatelessWidget {
  const ReportCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReportCardController>();

    return BaseWidgetContainer(
      backgroundColor: AppColors.c5,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: GlobalText.semiBold(
          'Report Card',
          fontSize: 18.sp,
          color: Colors.black,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: controller.refreshData,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.allQuizzes.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64.sp,
                    color: Colors.red,
                  ),
                  SizedBox(height: 16.h),
                  GlobalText.medium(
                    controller.errorMessage.value,
                    fontSize: 16.sp,
                    textAlign: TextAlign.center,
                    color: Colors.red,
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: controller.refreshData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.c2,
                      foregroundColor: Colors.white,
                    ),
                    child: GlobalText.medium('Coba Lagi', fontSize: 14.sp),
                  ),
                ],
              ),
            ),
          );
        }

        if (controller.allQuizzes.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.quiz_outlined,
                    size: 64.sp,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16.h),
                  GlobalText.medium(
                    'Belum ada data kuis',
                    fontSize: 16.sp,
                    textAlign: TextAlign.center,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 8.h),
                  GlobalText.regular(
                    'Kuis yang sudah dikerjakan akan muncul di sini',
                    fontSize: 14.sp,
                    textAlign: TextAlign.center,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshData,
          child: CustomScrollView(
            slivers: [
              // Header dengan nama user
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  color: Colors.white,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24.r,
                        backgroundColor: AppColors.c2,
                        child: GlobalText.bold(
                          controller.userName.value.isNotEmpty
                              ? controller.userName.value[0].toUpperCase()
                              : 'U',
                          fontSize: 18.sp,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GlobalText.bold(
                              controller.userName.value,
                              fontSize: 16.sp,
                              color: Colors.black,
                            ),
                            GlobalText.regular(
                              'Report Card Siswa',
                              fontSize: 12.sp,
                              color: Colors.grey.shade600,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Statistics
              SliverToBoxAdapter(
                child: ReportCardStatistics(
                  statistics: controller.getStatistics(),
                ),
              ),

              // Filters
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  child: ReportCardFilters(
                    selectedFilter: controller.selectedFilter.value,
                    selectedSubject: controller.selectedSubject.value,
                    availableSubjects: controller.availableSubjects,
                    onFilterChanged: controller.changeFilter,
                    onSubjectChanged: controller.changeSubjectFilter,
                  ),
                ),
              ),

              // Quiz Count Info
              SliverToBoxAdapter(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: GlobalText.medium(
                    'Menampilkan ${controller.filteredQuizzes.length} kuis',
                    fontSize: 14.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),

              // Quiz List
              if (controller.filteredQuizzes.isEmpty)
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      children: [
                        Icon(
                          Icons.filter_list_off,
                          size: 48.sp,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16.h),
                        GlobalText.medium(
                          'Tidak ada kuis dengan filter yang dipilih',
                          fontSize: 14.sp,
                          textAlign: TextAlign.center,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final quiz = controller.filteredQuizzes[index];
                      return QuizReportCard(
                        quiz: quiz,
                        getScoreColor: controller.getScoreColor,
                        getStatusColor: controller.getStatusColor,
                        getStatusText: controller.getStatusText,
                        formatDate: controller.formatDate,
                        formatTime: controller.formatTime,
                      );
                    },
                    childCount: controller.filteredQuizzes.length,
                  ),
                ),

              // Bottom padding
              SliverToBoxAdapter(
                child: SizedBox(height: 20.h),
              ),
            ],
          ),
        );
      }),
    );
  }
}
