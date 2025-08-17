import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/core/global_components/global_confirmation_dialog.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:blessing/modules/admin/course/controllers/admin_detail_quiz_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AdminDetailQuizScreen extends StatelessWidget {
  const AdminDetailQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminDetailQuizController>();

    return BaseWidgetContainer(
      appBar: AppBar(
        centerTitle: false,
        title: GlobalText.semiBold(
          "Detail Kuis",
          fontSize: 16.sp,
          color: AppColors.c2,
        ),
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
                        message: "Apakah kamu yakin ingin menghapus kuis ini?",
                        onYes: () {
                          Get.back(); // tutup dialog
                          controller.deleteQuiz();
                        },
                        onNo: () => Get.back(),
                      ),
                    );
                  },
                )),
        ],
      ),
      body: Obx(() {
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
                  final options =
                      controller.optionsByQuestion[question.id] ?? [];

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
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 8),

                          // konten pertanyaan
                          ...question.content.map((c) {
                            if (c.type == "text") {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Text(
                                  c.data,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              );
                            } else if (c.type == "image" && c.data.isNotEmpty) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
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
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
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
      }),
    );
  }
}
