import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/core/global_components/search_bar.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:blessing/core/utils/app_routes.dart';
import 'package:blessing/modules/admin/manage_student/controller/admin_manage_student_controller.dart';
import 'package:blessing/modules/admin/manage_student/widgets/user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AdminManageStudentScreen extends StatelessWidget {
  const AdminManageStudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminManageStudentController>();

    return BaseWidgetContainer(
      backgroundColor: AppColors.c5,
      appBar: AppBar(
        title: _buildKelasFilter(controller),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          Expanded(
            child: Obx(
              () => controller.isLoading.value
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.c2),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        await controller.fetchStudents();
                      },
                      child: controller.filteredStudents.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.people_outline,
                                    size: 64.sp,
                                    color: Colors.grey.shade400,
                                  ),
                                  SizedBox(height: 16.h),
                                  GlobalText.medium(
                                    "Tidak ada siswa di kelas ini",
                                    fontSize: 16.sp,
                                    color: Colors.grey.shade600,
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: controller.filteredStudents.length,
                              itemBuilder: (context, index) {
                                final student =
                                    controller.filteredStudents[index];
                                return UserCard(
                                  userName: student['nama']!,
                                  userClass: student['kelas']!,
                                  onTap: () {
                                    Get.toNamed(
                                      AppRoutes.detailStudent,
                                      arguments: {
                                        'id': student['id'],
                                        'onStudentDeleted': () =>
                                            controller.fetchStudents(),
                                      },
                                    );
                                  },
                                  // onOptionsTap: () =>
                                      // print("Options for ${student['nama']}"),
                                );
                              },
                            ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKelasFilter(AdminManageStudentController controller) {
    // ... (Tidak ada perubahan di method ini)
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: controller.kelasList.map((kelas) {
            final bool isSelected = controller.selectedKelas.value == kelas;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0.w),
              child: GestureDetector(
                onTap: () {
                  controller.selectKelas(kelas);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(
                    vertical: 5.h,
                    horizontal: 15.w,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.c2 : Colors.transparent,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    'Kelas $kelas',
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    final controller = Get.find<AdminManageStudentController>();

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
      child: Row(
        children: [
          Expanded(
            child: CustomSearchBar(
              height: 33.h,
              width: 358.w,
              hintText: "Cari Siswa",
              onChanged: (value) {
                controller.setSearchQuery(value);
              },
            ),
          ),
          SizedBox(width: 8.w),
          IconButton(
            style: IconButton.styleFrom(
                backgroundColor: AppColors.c2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r))),
            icon: const Icon(Icons.person_add_alt_1, color: Colors.white),
            onPressed: () {
              Get.toNamed(AppRoutes.addStudent, arguments: {
                'onStudentAdded': () => controller.fetchStudents(),
              });
            },
          ),
        ],
      ),
    );
  }
}
