import 'package:blessing/core/constants/images.dart';
import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/modules/student/main/controllers/main_student_controllers.dart';
import 'package:blessing/modules/student/main/widgets/class_list.dart';
// import 'package:blessing/modules/student/main/widgets/new_activity.dart';
import 'package:blessing/core/global_components/search_bar.dart';
import 'package:blessing/modules/student/main/widgets/student_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MainStudent extends StatelessWidget {
  const MainStudent({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MainStudentController>();

    return BaseWidgetContainer(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Obx(() => StudentAppBar(
            name: controller.name.value,
            classInfo: controller.classInfo.value,
            profileImageUrl: 'assets/images/image.png')),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(12.h),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: Offset(2, 2),
                          blurRadius: 0,
                          spreadRadius: 0.5,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      Images.studentMain,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                // Connect the search bar to the controller's search method
                CustomSearchBar(
                  // Assuming your CustomSearchBar has an `onChanged` property.
                  // If not, you will need to add it.
                  onChanged: (query) => controller.onSearchChanged(query),
                  hintText: 'Cari mata pelajaran...',
                ),
                SizedBox(height: 16.h),
                // NewActivity(),
                ClassList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
