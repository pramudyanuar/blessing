import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:blessing/modules/admin/course/controllers/create_quiz_controller.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CreateQuizScreen extends StatelessWidget {
  const CreateQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CreateQuizController>();

    return BaseWidgetContainer(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        centerTitle: true,
        title: GlobalText.semiBold("Buat Kuis", fontSize: 16.sp),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Center(
              child: Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                            controller.uploadQuiz();
                          },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.c2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r)),
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        disabledBackgroundColor: Colors.grey.shade300),
                    child: controller.isLoading.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text('Unggah',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600)),
                  )),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Gunakan Obx untuk membuat daftar pertanyaan yang dinamis
            Obx(
              () => ListView.separated(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 100.h),
                itemCount:
                    controller.questions.length + 1, // +1 untuk kartu nama kuis
                separatorBuilder: (context, index) => SizedBox(height: 24.h),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    // Item pertama adalah input nama kuis
                    return _buildQuizNameCard(controller);
                  }
                  // Item selanjutnya adalah kartu pertanyaan
                  final questionIndex = index - 1;
                  return _buildQuestionSection(controller, questionIndex);
                },
              ),
            ),
            // Tombol permanen di bagian bawah
            _buildBottomButton(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizNameCard(CreateQuizController controller) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Nama Kuis",
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 8.h),
          _buildTextFormField(
            hint: 'Masukkan Nama Kuis',
            controller: controller.quizTitleController,
          ),
          SizedBox(height: 16.h),

          // Input Time Limit
          Text("Batas Waktu (menit)",
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 8.h),
          _buildTextFormField(
            hint: 'Contoh: 30',
            controller: controller.timeLimitController,
          ),
        ],
      ),
    );
  }

  // Widget ini sekarang membangun satu blok pertanyaan berdasarkan index-nya
  Widget _buildQuestionSection(
      CreateQuizController controller, int questionIndex) {
    final question = controller.questions[questionIndex];

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Pertanyaan ${questionIndex + 1}",
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
              // Tombol hapus pertanyaan, hanya muncul jika pertanyaan > 1
              if (controller.questions.length > 1)
                IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
                  onPressed: () => controller.removeQuestion(questionIndex),
                ),
            ],
          ),
          SizedBox(height: 16.h),

          // --- WIDGET UNTUK GAMBAR ---
          _buildImagePicker(controller, questionIndex),
          // --- SELESAI WIDGET GAMBAR ---

          SizedBox(height: 16.h),
          _buildTextFormField(
            hint: 'Tambah deskripsi atau instruksi',
            maxLines: 4,
            controller: question.descriptionController,
          ),
          SizedBox(height: 24.h),
          GlobalText.semiBold("Opsi Jawaban", fontSize: 14.sp),
          SizedBox(height: 12.h),

          // Obx ini untuk membuat daftar OPSI yang dinamis untuk pertanyaan ini
          Obx(
            () => ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: question.optionControllers.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, optionIndex) {
                return _buildOptionField(
                  controller,
                  questionIndex,
                  optionIndex,
                );
              },
            ),
          ),
          SizedBox(height: 16.h),

          // Tombol Tambah Opsi untuk pertanyaan ini
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () => controller
                  .addOption(questionIndex), // <-- Kirim index pertanyaan
              icon: const Icon(Icons.add),
              label: const Text('Tambah Opsi'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.c2,
                backgroundColor: const Color(0xFFEAF0F9),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r)),
                padding: EdgeInsets.symmetric(vertical: 10.h),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildImagePicker(CreateQuizController controller, int questionIndex) {
    final question = controller.questions[questionIndex];

    return Obx(() {
      if (question.imageFile.value == null) {
        // Tampilan jika tidak ada gambar
        return GestureDetector(
          onTap: () => controller.pickImageForQuestion(questionIndex),
          child: DottedBorder(
            child: Container(
              height: 150.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image_outlined,
                      color: Colors.grey.shade500, size: 40.sp),
                  SizedBox(height: 8.h),
                  Text("Tambah Gambar (Opsional)",
                      style: TextStyle(
                          color: Colors.grey.shade600, fontSize: 14.sp)),
                ],
              ),
            ),
          ),
        );
      } else {
        // Tampilan jika ada gambar yang dipilih
        return ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Image.file(
                question.imageFile.value!,
                width: double.infinity,
                height: 180.h,
                fit: BoxFit.cover,
              ),
              Container(
                margin: EdgeInsets.all(8.w),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white, size: 20.sp),
                  onPressed: () =>
                      controller.removeImageForQuestion(questionIndex),
                  tooltip: 'Hapus Gambar',
                ),
              ),
            ],
          ),
        );
      }
    });
  }

  Widget _buildBottomButton(CreateQuizController controller) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        color: const Color(0xFFF5F5F5),
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () =>
              controller.addQuestion(), // <-- Hubungkan ke fungsi addQuestion
          icon: const Icon(Icons.add, color: Colors.white),
          label: Text("Tambah Pertanyaan",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600)),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.c2,
            padding: EdgeInsets.symmetric(vertical: 14.h),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r)),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionField(
      CreateQuizController controller, int questionIndex, int optionIndex) {
    final question = controller.questions[questionIndex];
    final textController = question.optionControllers[optionIndex];

    return Obx(
      () => Row(
        children: [
          Radio<int>(
            value: optionIndex,
            groupValue: question.correctAnswerIndex.value,
            onChanged: (value) {
              if (value != null) {
                question.correctAnswerIndex.value = value;
              }
            },
            activeColor: AppColors.c2,
          ),
          Expanded(
              child: _buildTextFormField(
                  hint: 'Tulis Jawaban', controller: textController)),
          if (question.optionControllers.length > 2)
            IconButton(
              icon:
                  Icon(Icons.remove_circle_outline, color: Colors.red.shade400),
              onPressed: () =>
                  controller.removeOption(questionIndex, optionIndex),
              tooltip: 'Hapus Opsi',
            )
          else
            SizedBox(width: 48.w) // Placeholder to keep alignment
        ],
      ),
    );
  }

  Widget _buildTextFormField(
      {required String hint,
      int maxLines = 1,
      TextEditingController? controller}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14.sp),
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: AppColors.c2)),
      ),
    );
  }
}
