import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/core/utils/app_routes.dart';
import 'package:blessing/modules/admin/homepage/controller/admin_homepage_controller.dart';
import 'package:blessing/modules/admin/homepage/widgets/subject_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AdminHomepageScreen extends StatelessWidget {
  const AdminHomepageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminHomepageController>();

    return BaseWidgetContainer(
      backgroundColor: AppColors.c5,
      appBar: AppBar(
        title: _buildKelasFilter(controller),
        backgroundColor: Colors.white,
        elevation: 1.0,
      ),
      body: Obx(
        () => ListView.separated(
          padding: EdgeInsets.all(16.w),
          itemCount: controller.displayedSubjects.length,
          separatorBuilder: (context, index) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final subject = controller.displayedSubjects[index];
            return SubjectCard(
              title: subject['title'],
              icon: subject['icon'],
              // -> 2. UBAH AKSI ONTAP DI SINI
              onTap: () {
                Get.toNamed(AppRoutes.manageSubject);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.c2,
        onPressed: () {
          // Aksi untuk menambahkan subjek baru
          Get.toNamed(AppRoutes.adminCreateSubject);
        },
        child: const Icon(Icons.add, color: AppColors.c1,),
      ),
    );
  }

  Widget _buildKelasFilter(AdminHomepageController controller) {
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
                    color:
                        isSelected ? AppColors.c2 : Colors.transparent,
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
}
