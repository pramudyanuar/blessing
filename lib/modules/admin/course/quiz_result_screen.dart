import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:blessing/core/global_components/search_bar.dart';
import 'package:blessing/data/report/repository/report_repository_impl.dart';
import 'package:blessing/modules/admin/course/quiz_result_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AdminQuizResultScreen extends StatelessWidget {
  const AdminQuizResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final controller = Get.put(AdminQuizResultController(ReportRepository()));

    return BaseWidgetContainer(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        centerTitle: false,
        title: GlobalText.semiBold("Hasil Kuis", fontSize: 16.sp),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.grey),
            onPressed: () => controller.refreshData(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.quizReportData.value == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.quiz, size: 64.sp, color: Colors.grey),
                SizedBox(height: 16.h),
                GlobalText.medium("Data kuis tidak ditemukan",
                    fontSize: 14.sp, color: Colors.grey),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () => controller.refreshData(),
                  child: GlobalText.medium("Coba Lagi", fontSize: 12.sp),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              // Quiz Info Card
              _buildQuizInfoCard(controller),
              SizedBox(height: 16.h),

              CustomSearchBar(
                hintText: "Cari nama siswa...",
                onChanged: (value) => controller.updateSearchText(value),
              ),

              SizedBox(height: 16.h),

              // Student Results List
              Expanded(
                child: Obx(() {
                  final users = controller.filteredUsers;

                  if (users.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off,
                              size: 64.sp, color: Colors.grey),
                          SizedBox(height: 16.h),
                          GlobalText.medium("Tidak ada siswa yang ditemukan",
                              fontSize: 14.sp, color: Colors.grey),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      final rank = controller.getUserRanking(user);
                      return Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: _buildStudentCard(
                          user.username,
                          controller.getAchievementText(rank),
                          user.score ?? 0,
                          controller.getCardColor(rank),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildQuizInfoCard(AdminQuizResultController controller) {
    return Obx(() {
      final quizData = controller.quizData;
      final statistics = controller.statistics;

      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            GlobalText.bold(quizData?.quizName ?? "Kuis", fontSize: 18.sp),
            SizedBox(height: 4.h),
            GlobalText.medium("Matematika", // TODO: Get from course data
                fontSize: 14.sp,
                color: Colors.grey),
            SizedBox(height: 2.h),
            GlobalText.medium(
              controller.formatDate(DateTime.now()), // TODO: Get quiz date
              fontSize: 12.sp,
              color: Colors.grey,
            ),
            SizedBox(height: 20.h),

            // Statistics Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    GlobalText.bold(
                      "${statistics?.studentsAttempted ?? 0}",
                      fontSize: 24.sp,
                      color: Colors.black,
                    ),
                    GlobalText.medium("Peserta",
                        fontSize: 12.sp, color: Colors.grey),
                  ],
                ),
                Column(
                  children: [
                    GlobalText.bold(
                      statistics?.averageScore.toStringAsFixed(1) ?? '0.0',
                      fontSize: 24.sp,
                      color: Colors.green,
                    ),
                    GlobalText.medium("Rata-rata",
                        fontSize: 12.sp, color: Colors.grey),
                  ],
                ),
                Column(
                  children: [
                    GlobalText.bold(
                      "${statistics?.highestScore ?? 0}",
                      fontSize: 24.sp,
                      color: Colors.blue,
                    ),
                    GlobalText.medium("Tertinggi",
                        fontSize: 12.sp, color: Colors.grey),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStudentCard(
      String name, String achievement, int score, Color cardColor) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 20.r,
            backgroundColor: Colors.grey.shade300,
            child: Icon(Icons.person, color: Colors.grey.shade600, size: 20.sp),
          ),
          SizedBox(width: 12.w),

          // Student Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GlobalText.semiBold(name, fontSize: 14.sp, color: Colors.white),
                if (achievement.isNotEmpty)
                  GlobalText.medium(achievement,
                      fontSize: 12.sp, color: Colors.white70),
              ],
            ),
          ),

          // Score
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GlobalText.bold(score.toString(),
                  fontSize: 16.sp, color: Colors.white),
              GlobalText.medium("/100", fontSize: 12.sp, color: Colors.white70),
            ],
          ),
        ],
      ),
    );
  }
}
