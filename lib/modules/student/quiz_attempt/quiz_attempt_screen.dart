import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:blessing/modules/student/quiz_attempt/controller/quiz_attempt_controller.dart';
import 'package:blessing/modules/student/quiz_attempt/widgets/question_navigation_drawer.dart';
import 'package:blessing/modules/student/quiz_attempt/widgets/quiz_attempt_body.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuizAttemptScreen extends StatelessWidget {
  const QuizAttemptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<QuizAttemptController>();
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return BaseWidgetContainer(
      scaffoldKey: scaffoldKey,
      appBar: AppBar(
        backgroundColor: AppColors.c1,
        automaticallyImplyLeading: false,
        title: GlobalText.bold("Kuis 8"),
        centerTitle: true,
        // Tampilkan timer di AppBar
        flexibleSpace: SafeArea(
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 16),
            child: Obx(() => Text(
                  controller.timerText,
                  style: const TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                )),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => scaffoldKey.currentState?.openEndDrawer(),
          ),
        ],
      ),
      body: Container(
        color: AppColors.c5,
        child: const QuizAttemptBody(),
      ),
      endDrawer: const QuestionNavigationDrawer(),
    );
  }
}
