import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/modules/student/course/course_list_screen.dart';
import 'package:blessing/modules/student/quiz/quiz_list_screen.dart';
import 'package:blessing/modules/student/subject/controller/subject_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubjectMainScreen extends StatelessWidget {
  SubjectMainScreen({super.key});

  final controller = Get.find<SubjectController>();

  final List<Widget> _screens = [
    // Course List Screen
    CourseListScreen(),
    // Quiz List Screen
    QuizListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: BaseWidgetContainer(
            backgroundColor: AppColors.c6,
            body: _screens[controller.selectedIndex.value],
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: AppColors.c1,
            currentIndex: controller.selectedIndex.value,
            onTap: controller.changeIndex,
            unselectedItemColor: AppColors.c6,
            selectedItemColor: AppColors.c2,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.menu_book),
                label: 'Course',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.quiz),
                label: 'Quiz',
              ),
            ],
          ),
        ));
  }
}
