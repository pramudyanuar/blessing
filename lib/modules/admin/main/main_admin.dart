import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/modules/admin/homepage/admin_homepage_screen.dart';
import 'package:blessing/modules/admin/main/controllers/main_admin_controller.dart';
import 'package:blessing/modules/admin/manage_student/admin_manage_student_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainAdminScreen extends StatelessWidget {
  MainAdminScreen({super.key});

  final controller = Get.find<MainAdminController>();

  final List<Widget> _screens = [
    AdminHomepageScreen(),
    AdminManageStudentScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: BaseWidgetContainer(
            backgroundColor: AppColors.c5,
            body: _screens[controller.selectedIndex.value],
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            currentIndex: controller.selectedIndex.value,
            onTap: controller.changeIndex,
            selectedItemColor: AppColors.c2,
            unselectedItemColor: AppColors.c6,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home,),
                label: 'Homepage',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people_rounded,),
                label: 'Manage Students',
              ),
            ],
          ),
        ));
  }
}
