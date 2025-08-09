import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:blessing/core/global_components/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminQuizResultScreen extends StatelessWidget {
  const AdminQuizResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseWidgetContainer(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        centerTitle: false,
        title: GlobalText.semiBold("Hasil Kuis", fontSize: 16.sp),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            // Quiz Info Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  GlobalText.bold("Kuis 8", fontSize: 18.sp),
                  SizedBox(height: 4.h),
                  GlobalText.medium("Matematika",
                      fontSize: 14.sp, color: Colors.grey),
                  SizedBox(height: 2.h),
                  GlobalText.medium("15 November 2024",
                      fontSize: 12.sp, color: Colors.grey),
                  SizedBox(height: 20.h),

                  // Statistics Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          GlobalText.bold("24",
                              fontSize: 24.sp, color: Colors.black),
                          GlobalText.medium("Peserta",
                              fontSize: 12.sp, color: Colors.grey),
                        ],
                      ),
                      Column(
                        children: [
                          GlobalText.bold("87.5",
                              fontSize: 24.sp, color: Colors.green),
                          GlobalText.medium("Rata-rata",
                              fontSize: 12.sp, color: Colors.grey),
                        ],
                      ),
                      Column(
                        children: [
                          GlobalText.bold("100",
                              fontSize: 24.sp, color: Colors.blue),
                          GlobalText.medium("Tertinggi",
                              fontSize: 12.sp, color: Colors.grey),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            CustomSearchBar(
              hintText: "Cari nama siswa...",

            ),

            SizedBox(height: 16.h),

            // Student Results List
            Expanded(
              child: ListView(
                children: [
                  _buildStudentCard("Aulia Rahmis", "1st Peringkat Tertinggi",
                      98, const Color(0xFFFFA726)),
                  SizedBox(height: 8.h),
                  _buildStudentCard("Dudi Santoso", "2nd Peringkat Kedua", 95,
                      const Color(0xFF9E9E9E)),
                  SizedBox(height: 8.h),
                  _buildStudentCard("Citra Dewi", "3rd Peringkat Ketiga", 92,
                      const Color(0xFFFF8A65)),
                  SizedBox(height: 8.h),
                  _buildStudentCard(
                      "Dani Pratama", "", 88, const Color(0xFFE0E0E0)),
                  SizedBox(height: 8.h),
                  _buildStudentCard(
                      "Eka Sari", "", 85, const Color(0xFFE0E0E0)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentCard(
      String name, String achievement, int score, Color cardColor) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 20.r,
            backgroundColor: Colors.grey.shade300,
            child: Icon(Icons.person, color: Colors.grey.shade600, size: 20.sp),
          ),
          SizedBox(width: 12.w),

          // Student Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GlobalText.semiBold(name, fontSize: 14.sp, color: Colors.white),
                if (achievement.isNotEmpty)
                  GlobalText.medium(achievement,
                      fontSize: 12.sp, color: Colors.white70),
              ],
            ),
          ),

          // Score
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GlobalText.bold(score.toString(),
                  fontSize: 16.sp, color: Colors.white),
              GlobalText.medium("/100", fontSize: 12.sp, color: Colors.white70),
            ],
          ),
        ],
      ),
    );
  }
}
