import 'package:blessing/core/constants/images.dart';
import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/modules/student/main/widgets/class_list.dart';
import 'package:blessing/modules/student/main/widgets/new_activity.dart';
import 'package:blessing/modules/student/main/widgets/search_bar.dart';
import 'package:blessing/modules/student/main/widgets/student_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainStudent extends StatelessWidget {
  const MainStudent({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseWidgetContainer(
      appBar: StudentAppBar(
        name: "John Doe",
        classInfo: "Kelas 12 IPA",
        profileImageUrl: "",
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(12.h),
            child: Column(
              children: [
ClipRRect(
                    borderRadius:
                        BorderRadius.circular(12), // Semua sudut akan membulat
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white, // atau apapun sesuai kebutuhan
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
                CustomSearchBar(),
                SizedBox(height: 16.h),
                NewActivity(),
                // SizedBox(height: 16.h),
                ClassList()
              ],
            ),
          ),
        ),
      )
    );
  }
}