import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/modules/student/subject/controller/subject_controller.dart';
import 'package:blessing/modules/student/course/course_list_screen.dart';
import 'package:blessing/modules/student/quiz/quiz_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubjectMainScreen extends StatelessWidget {
  SubjectMainScreen({super.key});

  final SubjectController controller = Get.put(SubjectController());

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
            body: _screens[controller.selectedIndex.value],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: controller.selectedIndex.value,
            onTap: controller.changeIndex,
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
