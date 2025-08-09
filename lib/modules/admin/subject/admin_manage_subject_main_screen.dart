import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/modules/admin/course/admin_manage_course_list_screen.dart';
import 'package:flutter/material.dart';

class AdminManageSubjectMainScreen extends StatelessWidget {
  const AdminManageSubjectMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BaseWidgetContainer(
        body: AdminManageCourseListScreen(),
      ),
    );
  }
}
