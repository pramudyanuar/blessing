import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/modules/admin/course/admin_manage_course_list_screen.dart';
import 'package:blessing/modules/admin/subject/controller/admin_manage_subject_controller.dart';
import 'package:blessing/modules/student/quiz/quiz_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminManageSubjectMainScreen extends StatelessWidget {
  AdminManageSubjectMainScreen({super.key});

  final controller = Get.find<AdminManageSubjectController>();

  final List<Widget> _screens = [
    // Course List Screen
    AdminManageCourseListScreen(),
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
