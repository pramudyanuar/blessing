import 'package:blessing/modules/student/quiz_attempt/controller/quiz_attempt_controller.dart';
import 'package:blessing/modules/student/quiz_attempt/widgets/question_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class QuizAttemptBody extends StatelessWidget {
  const QuizAttemptBody({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<QuizAttemptController>();
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: controller.previousPage,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text(
                        "Soal ${controller.currentQuestionIndex.value + 1}"),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: controller.nextPage,
                  ),
                ],
              )),
        ),
        Expanded(
          child: PageView.builder(
            controller: controller.pageController,
            itemCount: controller.questions.length,
            onPageChanged: (index) {
              controller.currentQuestionIndex.value = index;
            },
            itemBuilder: (context, index) {
              final question = controller.questions[index];
              return QuestionCard(
                questionIndex: index,
                questionData: question,
              );
            },
          ),
        ),
      ],
    );
  }
}
