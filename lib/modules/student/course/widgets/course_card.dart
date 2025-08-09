// lib/modules/student/course/widgets/course_card.dart

import 'dart:ui';
import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum CardType { material, quiz }

class CourseCard extends StatelessWidget {
  // Properti umum & materi
  final CardType cardType;
  final String title;
  final String dateText;
  final String? description;
  final String? fileName;
  final List<Widget>? previewImages;
  final VoidCallback? onTapDetail;

  // Properti kuis
  final List<String>? quizDetails;
  final bool isCompleted;
  final int? score;
  final VoidCallback? onStart;

  const CourseCard.material({
    super.key,
    required this.title,
    required this.dateText,
    required this.description,
    this.fileName,
    this.onTapDetail,
    this.previewImages,
  })  : cardType = CardType.material,
        quizDetails = null,
        isCompleted = false,
        score = null,
        onStart = null;

  const CourseCard.quiz({
    super.key,
    required this.title,
    required this.dateText,
    required this.quizDetails,
    this.isCompleted = false,
    this.score,
    this.onStart,
  })  : cardType = CardType.quiz,
        description = null,
        fileName = null,
        previewImages = null,
        onTapDetail = null;

  @override
  Widget build(BuildContext context) {
    final String headerText =
        cardType == CardType.quiz ? "Quiz" : "Materi Pembelajaran";
    final IconData headerIcon = cardType == CardType.quiz
        ? Icons.quiz_outlined
        : Icons.menu_book_outlined;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8.r,
            offset: const Offset(0, 4),
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
                  Icon(headerIcon, size: 18.sp, color: Colors.black87),
                  SizedBox(width: 8.w),
                  GlobalText.medium(
                    headerText,
                    fontSize: 12.sp,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              GlobalText.light(
                dateText,
                fontSize: 8.sp,
                color: Colors.grey,
                textAlign: TextAlign.end,
              ),
            ],
          ),
          SizedBox(height: 12.h),

          /// Body Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              GlobalText.bold(
                title,
                fontSize: 16.sp,
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 8.h),

              /// Conditional Content (Quiz vs Material)
              if (cardType == CardType.quiz)
                _buildQuizContent()
              else
                _buildMaterialContent(),
            ],
          ),

          /// Preview Images for Material Card
          if (cardType == CardType.material &&
              previewImages != null &&
              previewImages!.isNotEmpty)
            _buildPreviewImages(),
        ],
      ),
    );
  }

  Widget _buildQuizContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Sisi Kiri: Detail Kuis
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: (quizDetails ?? [])
                .map((detail) => Padding(
                      padding: EdgeInsets.only(top: 2.h),
                      child: GlobalText.regular(
                        detail,
                        fontSize: 13.sp,
                        color: AppColors.c6,
                      ),
                    ))
                .toList(),
          ),
        ),
        SizedBox(width: 16.w),
        // Sisi Kanan: Tombol atau Nilai
        if (isCompleted)
          // Tampilan Nilai
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              GlobalText.bold(
                score.toString(),
                fontSize: 26.sp,
                color: AppColors.c3,
              ),
              GlobalText.regular(
                '/100',
                fontSize: 14.sp,
                color: Colors.grey.shade600,
              )
            ],
          )
        else
          // Tampilan Tombol "Mulai"
          ElevatedButton(
            onPressed: onStart,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E5B9F),
              shape: const StadiumBorder(),
              elevation: 2,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
            ),
            child: GlobalText.bold(
              "Mulai",
              fontSize: 13.sp,
              color: Colors.white,
            ),
          ),
      ],
    );
  }

  Widget _buildMaterialContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlobalText.regular(
          description ?? '',
          fontSize: 13.sp,
          color: AppColors.c6,
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (fileName != null)
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.picture_as_pdf, size: 16.sp, color: Colors.red),
                    SizedBox(width: 4.w),
                    GlobalText.regular(
                      fileName!,
                      fontSize: 14.sp,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            if (onTapDetail != null &&
                (previewImages == null || previewImages!.isEmpty))
              GlobalText.clickable(
                "Lihat Detail",
                onTap: onTapDetail!,
                fontWeight: FontWeight.w700,
                fontSize: 13.sp,
                color: AppColors.c3,
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildPreviewImages() {
    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: SizedBox(
        height: 185.h,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 4.h,
            crossAxisSpacing: 4.w,
            childAspectRatio: 1.7,
          ),
          itemCount: previewImages!.length > 4 ? 4 : previewImages!.length,
          itemBuilder: (context, index) {
            final image = previewImages![index];
            final totalImages = previewImages!.length;
            final bool showOverlayOnFourth = index == 3 && totalImages >= 4;
            return GestureDetector(
              onTap: onTapDetail,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: SizedBox.expand(
                      child: (showOverlayOnFourth && totalImages > 4)
                          ? ImageFiltered(
                              imageFilter:
                                  ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
                              child: image,
                            )
                          : image,
                    ),
                  ),
                  if (showOverlayOnFourth)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: totalImages > 4
                            ? Colors.black38
                            : Colors.transparent,
                      ),
                      child: Center(
                        child: GlobalText.bold(
                          "Lihat Detail",
                          fontSize: 14.sp,
                          color: totalImages == 4 ? AppColors.c2 : Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
