import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReportCardFilters extends StatelessWidget {
  final String selectedFilter;
  final String selectedSubject;
  final List<String> availableSubjects;
  final Function(String) onFilterChanged;
  final Function(String) onSubjectChanged;

  const ReportCardFilters({
    super.key,
    required this.selectedFilter,
    required this.selectedSubject,
    required this.availableSubjects,
    required this.onFilterChanged,
    required this.onSubjectChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Filter
          GlobalText.medium(
            'Filter Status',
            fontSize: 14.sp,
            color: Colors.black87,
          ),
          SizedBox(height: 8.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(
                  label: 'Semua',
                  value: 'all',
                  isSelected: selectedFilter == 'all',
                  onTap: () => onFilterChanged('all'),
                ),
                SizedBox(width: 8.w),
                _buildFilterChip(
                  label: 'Sudah Dikerjakan',
                  value: 'attempted',
                  isSelected: selectedFilter == 'attempted',
                  onTap: () => onFilterChanged('attempted'),
                ),
                SizedBox(width: 8.w),
                _buildFilterChip(
                  label: 'Belum Dikerjakan',
                  value: 'not_attempted',
                  isSelected: selectedFilter == 'not_attempted',
                  onTap: () => onFilterChanged('not_attempted'),
                ),
                SizedBox(width: 8.w),
                _buildFilterChip(
                  label: 'Selesai',
                  value: 'completed',
                  isSelected: selectedFilter == 'completed',
                  onTap: () => onFilterChanged('completed'),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // Subject Filter
          GlobalText.medium(
            'Filter Mata Pelajaran',
            fontSize: 14.sp,
            color: Colors.black87,
          ),
          SizedBox(height: 8.h),
          if (availableSubjects.isNotEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedSubject,
                  isExpanded: true,
                  hint: GlobalText.regular('Pilih Mata Pelajaran',
                      fontSize: 14.sp),
                  items: [
                    DropdownMenuItem(
                      value: 'all',
                      child: GlobalText.regular('Semua Mata Pelajaran',
                          fontSize: 14.sp),
                    ),
                    ...availableSubjects.map((subject) {
                      return DropdownMenuItem(
                        value: subject,
                        child: GlobalText.regular(subject, fontSize: 14.sp),
                      );
                    }).toList(),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      onSubjectChanged(value);
                    }
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required String value,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.c2 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? AppColors.c2 : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: GlobalText.medium(
          label,
          fontSize: 12.sp,
          color: isSelected ? Colors.white : Colors.black87,
        ),
      ),
    );
  }
}
