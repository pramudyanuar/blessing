import 'package:blessing/core/constants/color.dart';
import 'package:blessing/data/quiz/models/response/question_response.dart'; // 1. Tambahkan import ini
import 'package:blessing/modules/student/quiz_attempt/controller/quiz_attempt_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class QuestionCard extends StatelessWidget {
  final int questionIndex;
  final QuestionResponse questionData; // 2. Ubah tipe data di sini

  const QuestionCard({
    super.key,
    required this.questionIndex,
    required this.questionData,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<QuizAttemptController>();
    // 3. Ambil daftar opsi untuk pertanyaan ini dari controller
    final options = controller.optionsByQuestion[questionData.id] ?? [];

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          // 4. Tampilkan Konten Soal (bisa teks atau gambar)
          ...questionData.content.map((content) {
            if (content.type == "text") {
              return Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Text(
                  content.data,
                  style: TextStyle(fontSize: 16.sp, height: 1.5),
                  textAlign: TextAlign.justify,
                ),
              );
            } else if (content.type == "image" && content.data.isNotEmpty) {
              return Container(
                margin: EdgeInsets.only(bottom: 8.h),
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  // Gunakan Image.network untuk memuat dari URL
                  child: Image.network(
                    content.data,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Container(
                      height: 150,
                      alignment: Alignment.center,
                      child: const Text("Gagal memuat gambar"),
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }).toList(),

          SizedBox(height: 24.h),

          // 5. Tampilkan Pilihan Jawaban
          ...List.generate(options.length, (index) {
            final option = options[index];
            final optionChar = String.fromCharCode('A'.codeUnitAt(0) + index);

            return Obx(() {
              // 6. Logika pengecekan jawaban diubah menjadi berbasis ID
              final selectedOptionId = controller.userAnswers[questionData.id];
              final isSelected = selectedOptionId == option.id;

              return Card(
                color: isSelected ? AppColors.c4 : Colors.white,
                elevation: isSelected ? 4 : 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  side: BorderSide(
                    color: isSelected ? AppColors.c3 : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: ListTile(
                  onTap: () => controller.selectAnswer(questionIndex, index),
                  leading: Text(
                    "$optionChar.",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                  ),
                  // Gunakan data dari objek 'option'
                  title: Text(option.option, style: TextStyle(fontSize: 16.sp)),
                ),
              );
            });
          }),
        ],
      ),
    );
  }
}
