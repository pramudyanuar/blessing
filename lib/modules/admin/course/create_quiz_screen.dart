import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:blessing/modules/admin/course/controllers/create_quiz_controller.dart';
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
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.c2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r)),
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                ),
                child: Text('Unggah',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
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
              controller: controller.quizTitleController),
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
          SizedBox(height: 8.h),
          _buildTextFormField(
            hint: 'Tambah deskripsi atau instruksi',
            maxLines: 4,
            controller: question.descriptionController,
          ),
          SizedBox(height: 16.h),

          // Obx ini untuk membuat daftar OPSI yang dinamis untuk pertanyaan ini
          Obx(
            () => ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: question.optionControllers.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, optionIndex) {
                final optionLetter = String.fromCharCode(65 + optionIndex);
                return _buildOptionField(
                  optionLetter,
                  question.optionControllers[optionIndex],
                  onRemove: question.optionControllers.length > 2
                      ? () =>
                          controller.removeOption(questionIndex, optionIndex)
                      : null,
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

  Widget _buildOptionField(String option, TextEditingController textController,
      {VoidCallback? onRemove}) {
    return Row(
      children: [
        SizedBox(
            width: 20.w,
            child: Text('$option.',
                style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54))),
        SizedBox(width: 8.w),
        Expanded(
            child: _buildTextFormField(
                hint: 'Tulis Jawaban', controller: textController)),
        if (onRemove != null)
          IconButton(
            icon: Icon(Icons.remove_circle_outline, color: Colors.red.shade400),
            onPressed: onRemove,
            tooltip: 'Hapus Opsi',
          )
        else
          SizedBox(width: 48.w)
      ],
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
