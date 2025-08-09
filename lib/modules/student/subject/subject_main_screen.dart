import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/modules/student/course/course_list_screen.dart';
import 'package:flutter/material.dart';

class SubjectMainScreen extends StatelessWidget {
  const SubjectMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BaseWidgetContainer(
        backgroundColor: AppColors.c6,
        body: CourseListScreen(),
      ),
    );
  }
}
