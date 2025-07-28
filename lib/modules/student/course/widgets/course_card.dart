import 'dart:ui';
import 'package:blessing/core/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CourseCard extends StatelessWidget {
  final String title;
  final String description;
  final String fileName;
  final String dateText;
  final List<Widget>? previewImages;
  final VoidCallback onTapDetail;

  const CourseCard({
    super.key,
    required this.title,
    required this.description,
    required this.fileName,
    required this.dateText,
    required this.onTapDetail,
    this.previewImages,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8.r,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.menu_book_outlined,
                      size: 18.sp, color: Colors.black87),
                  SizedBox(width: 8.w),
                  Text(
                    "Materi Pembelajaran",
                    style:
                        TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Text(
                dateText,
                style: TextStyle(fontSize: 11.sp, color: Colors.grey),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          /// Title
          Text(
            title,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6.h),

          /// Description
          Text(
            description,
            style: TextStyle(fontSize: 13.sp, color: Colors.black87),
          ),
          SizedBox(height: 10.h),

          /// File name & Detail
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.picture_as_pdf, size: 16.sp, color: Colors.red),
                  SizedBox(width: 4.w),
                  Text(fileName, style: TextStyle(fontSize: 13.sp)),
                ],
              ),
              GestureDetector(
                onTap: onTapDetail,
                child: Text(
                  "Lihat Detail",
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.c2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),

          /// Preview Images
/// Preview Images
          if (previewImages != null && previewImages!.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: SizedBox(
                height:
                    200.h, // <-- kontrol tinggi tampilan grid agar gambar besar
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8.h,
                    crossAxisSpacing: 8.w,
                    childAspectRatio: 1.3, // bisa adjust biar pas proporsinya
                  ),
                  itemCount:
                      previewImages!.length > 4 ? 4 : previewImages!.length,
                  itemBuilder: (context, index) {
                    final isLastItem = index == 3 && previewImages!.length > 4;
                    final image = previewImages![index];

                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: SizedBox.expand(
                            child: isLastItem
                                ? ImageFiltered(
                                    imageFilter: ImageFilter.blur(
                                        sigmaX: 2.5, sigmaY: 2.5),
                                    child: image,
                                  )
                                : image,
                          ),
                        ),
                        if (isLastItem)
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              color: Colors.black38,
                            ),
                            child: Center(
                              child: Text(
                                "See More",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),

        ],
      ),
    );
  }
}
