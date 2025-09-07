import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/core/global_components/global_confirmation_dialog.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:blessing/core/global_components/search_bar.dart';
import 'package:blessing/modules/admin/course/controllers/admin_detail_quiz_controller.dart';
import 'package:blessing/modules/admin/course/quiz_result_controller.dart';
import 'package:blessing/data/report/repository/report_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AdminDetailQuizScreen extends StatelessWidget {
  const AdminDetailQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminDetailQuizController>();

    return DefaultTabController(
      length: 2,
      child: BaseWidgetContainer(
        appBar: AppBar(
          centerTitle: false,
          title:
              GlobalText.semiBold("Kuis", fontSize: 16.sp, color: AppColors.c2),
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.c2),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            Obx(() => controller.isDeleting.value
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      Get.dialog(
                        GlobalConfirmationDialog(
                          message:
                              "Apakah kamu yakin ingin menghapus kuis ini?",
                          onYes: () {
                            Get.back();
                            controller.deleteQuiz();
                          },
                          onNo: () => Get.back(),
                        ),
                      );
                    },
                  )),
          ],
          bottom: const TabBar(
            labelColor: AppColors.c2,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.c2,
            tabs: [
              Tab(text: "Detail"),
              Tab(text: "Hasil"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _DetailTab(),
            _ResultTab(),
          ],
        ),
      ),
    );
  }
}

class _DetailTab extends StatelessWidget {
  const _DetailTab();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminDetailQuizController>();

    return Obx(() {
      if (controller.isLoadingQuestions.value ||
          controller.isLoadingOptions.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.questions.isEmpty) {
        return const Center(child: Text("Belum ada pertanyaan"));
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              controller.titleQuiz,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.c2,
                  ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: controller.questions.length,
              itemBuilder: (context, index) {
                final question = controller.questions[index];
                final options = controller.optionsByQuestion[question.id] ?? [];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Pertanyaan ${index + 1}",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        ...question.content.map((c) {
                          if (c.type == "text") {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text(c.data,
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                            );
                          } else if (c.type == "image" && c.data.isNotEmpty) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  c.data,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    height: 150,
                                    color: Colors.grey[200],
                                    alignment: Alignment.center,
                                    child: const Text("Gagal memuat gambar"),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        }).toList(),
                        const SizedBox(height: 12),
                        Text(
                          "Pilihan Jawaban:",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        ...options.map((opt) => ListTile(
                              leading: const Icon(Icons.circle_outlined),
                              title: Text(opt.option),
                            )),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}

class _ResultTab extends StatelessWidget {
  const _ResultTab();

  @override
  Widget build(BuildContext context) {
    final detailController = Get.find<AdminDetailQuizController>();

    // Initialize quiz result controller dengan quiz ID
    final resultController = Get.put(
      AdminQuizResultController(ReportRepository()),
      tag: 'quiz_${detailController.quizId}',
    );

    // Fetch data ketika pertama kali load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      resultController.fetchQuizReportCard(detailController.quizId);
    });

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          // Quiz Info Card
          Obx(() {
            final quizData = resultController.quizData;
            final statistics = resultController.statistics;

            if (resultController.isLoading.value) {
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
                child: const Center(child: CircularProgressIndicator()),
              );
            }

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
                  GlobalText.bold(
                    quizData?.quizName ?? detailController.titleQuiz,
                    fontSize: 18.sp,
                  ),
                  SizedBox(height: 4.h),
                  GlobalText.medium(
                    resultController.formatDate(DateTime.now()),
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
                            statistics?.averageScore.toStringAsFixed(1) ??
                                '0.0',
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
          }),

          SizedBox(height: 16.h),

          CustomSearchBar(
            hintText: "Cari nama siswa...",
            onChanged: (value) => resultController.updateSearchText(value),
          ),

          SizedBox(height: 16.h),

          // Student Results List
          Expanded(
            child: Obx(() {
              if (resultController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (resultController.quizReportData.value == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.quiz, size: 64.sp, color: Colors.grey),
                      SizedBox(height: 16.h),
                      GlobalText.medium("Belum ada data hasil kuis",
                          fontSize: 14.sp, color: Colors.grey),
                    ],
                  ),
                );
              }

              final users = resultController.filteredUsers;

              if (users.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 64.sp, color: Colors.grey),
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
                  final rank = resultController.getUserRanking(user);
                  return Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: _buildStudentCard(
                      user.username,
                      resultController.getAchievementText(rank),
                      user.score ?? 0,
                      resultController.getCardColor(rank),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
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
          CircleAvatar(
            radius: 20.r,
            backgroundColor: Colors.grey.shade300,
            child: Icon(Icons.person, color: Colors.grey.shade600, size: 20.sp),
          ),
          SizedBox(width: 12.w),
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
