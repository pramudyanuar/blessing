import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:blessing/modules/admin/report_card/controller/admin_report_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AdminFilterSection extends StatelessWidget {
  const AdminFilterSection({super.key});

  final List<String> dateRangeOptions = const [
    'All Time',
    'Last 7 Days',
    'Last 30 Days',
    'Last 3 Months',
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminReportCardController>();

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlobalText.semiBold(
            "Filter Data",
            fontSize: 16.sp,
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GlobalText.medium(
                      "Mata Pelajaran",
                      fontSize: 14.sp,
                      color: Colors.grey[700]!,
                    ),
                    SizedBox(height: 8.h),
                    Obx(() => Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: controller.selectedSubject.value,
                              isExpanded: true,
                              onChanged: controller.onSubjectChanged,
                              items: controller.availableSubjects
                                  .map((String subject) {
                                return DropdownMenuItem<String>(
                                  value: subject,
                                  child: GlobalText.regular(
                                    subject,
                                    fontSize: 14.sp,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GlobalText.medium(
                      "Periode",
                      fontSize: 14.sp,
                      color: Colors.grey[700]!,
                    ),
                    SizedBox(height: 8.h),
                    Obx(() => Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: controller.selectedDateRange.value,
                              isExpanded: true,
                              onChanged: controller.onDateRangeChanged,
                              items: dateRangeOptions.map((String dateRange) {
                                return DropdownMenuItem<String>(
                                  value: dateRange,
                                  child: GlobalText.regular(
                                    dateRange,
                                    fontSize: 14.sp,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Applied filters indicator
          Obx(() {
            final hasFilters = controller.selectedSubject.value != 'All' ||
                controller.selectedDateRange.value != 'All Time';

            if (!hasFilters) return const SizedBox.shrink();

            return Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.c2.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.filter_list,
                    size: 16.w,
                    color: AppColors.c2,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: GlobalText.regular(
                      "Filter aktif: ${controller.selectedSubject.value != 'All' ? controller.selectedSubject.value : ''} ${controller.selectedDateRange.value != 'All Time' ? controller.selectedDateRange.value : ''}"
                          .trim(),
                      fontSize: 12.sp,
                      color: AppColors.c2,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.onSubjectChanged('All');
                      controller.onDateRangeChanged('All Time');
                    },
                    child: Icon(
                      Icons.clear,
                      size: 16.w,
                      color: AppColors.c2,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
