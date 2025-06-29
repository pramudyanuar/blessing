import 'package:blessing/core/constants/color.dart';
import 'package:blessing/modules/student/quiz_attempt/controller/quiz_attempt_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class QuestionCard extends StatelessWidget {
  final int questionIndex;
  final Map<String, dynamic> questionData;

  const QuestionCard({
    super.key,
    required this.questionIndex,
    required this.questionData,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<QuizAttemptController>();
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          // Gambar Soal
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Image.asset(questionData['image']),
          ),
          SizedBox(height: 24.h),
          // Pilihan Jawaban
          ...List.generate(questionData['options'].length, (index) {
            final optionChar = String.fromCharCode('A'.codeUnitAt(0) + index);
            return Obx(() {
              final isSelected = controller.userAnswers[questionIndex] == index;
              return Card(
                elevation: isSelected ? 4 : 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  side: BorderSide(
                    color: isSelected ? AppColors.c2 : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: ListTile(
                  onTap: () => controller.selectAnswer(questionIndex, index),
                  leading: Text("$optionChar.",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.sp)),
                  title: Text(questionData['options'][index],
                      style: TextStyle(fontSize: 16.sp)),
                ),
              );
            });
          }),
        ],
      ),
    );
  }
}
