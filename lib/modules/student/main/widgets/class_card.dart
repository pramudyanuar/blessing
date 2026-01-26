import 'package:blessing/core/constants/images.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:blessing/core/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ClassCard extends StatelessWidget {
  final String imageUrl;
  final String subjectName;
  final String subtitle;
  final String classLevel;
  final String? subjectId;

  const ClassCard({
    super.key,
    this.subjectId, 
    required this.imageUrl,
    required this.subjectName,
    this.subtitle = 'SMA Blessing',
    this.classLevel = 'Kelas 10',
  });

  static String getImageForSubject(String? subjectName) {
    switch (subjectName?.toLowerCase()) {
      case 'matematika minat':
        return Images.matematikaMinat;
      case 'matematika wajib':
        return Images.matematikaWajib;
      case 'kimia':
        return Images.kimia;
      case 'akuntansi':
        return Images.akuntansi;
      case 'fisika':
        return Images.fisika;
      case 'biologi':
        return Images.biologi;
      case 'ekonomi':
        return Images.ekonomi;
      default:
        // Gambar default jika nama tidak cocok
        return Images.adminMainSubject;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDefaultImage = imageUrl == Images.adminMainSubject;

    return GestureDetector(
    onTap: () {
        final String finalImagePath = isDefaultImage
            ? imageUrl
            : imageUrl.replaceFirst(
                'assets/images/',
                'assets/images/detail-',
              );

        Get.toNamed(
          AppRoutes.courseMain,
          arguments: {
            'subjectId': subjectId,
            'title': subjectName,
            'subtitle': subtitle,
            'classLevel': classLevel,
            'imagePath': finalImagePath,
          },
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        width: 1.sw,
        child: AspectRatio(
          aspectRatio: 677 / 189,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imageUrl),
                fit: BoxFit
                    .cover,
                colorFilter: isDefaultImage
                    ? ColorFilter.mode(
                        Colors.black.withOpacity(0.4),
                        BlendMode.darken,
                      )
                    : null,
              ),
              borderRadius: BorderRadius.circular(
                  12), 
            ),
              child: isDefaultImage
                ? Align(
                    // Ganti Center dengan Align
                    alignment:
                        Alignment.centerLeft, // Atur alignment ke kiri-tengah
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GlobalText.semiBold(
                        subjectName,
                        color: Colors.white,
                        textAlign: TextAlign.left,
                        fontSize: 18.sp,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }

  factory ClassCard.matematikaMinat() => const ClassCard(
      imageUrl: Images.matematikaMinat,
      subjectName: 'Matematika Minat',
      classLevel: 'Kelas 12');
  factory ClassCard.matematikaWajib() => const ClassCard(
        imageUrl: Images.matematikaWajib,
        subjectName: 'Matematika Wajib',
      );
  factory ClassCard.kimia() => const ClassCard(
        imageUrl: Images.kimia,
        subjectName: 'Kimia',
      );
  factory ClassCard.akuntansi() => const ClassCard(
        imageUrl: Images.akuntansi,
        subjectName: 'Akuntansi',
      );
  factory ClassCard.fisika() => const ClassCard(
        imageUrl: Images.fisika,
        subjectName: 'Fisika',
      );
  factory ClassCard.biologi() => const ClassCard(
        imageUrl: Images.biologi,
        subjectName: 'Biologi',
      );
  factory ClassCard.ekonomi() => const ClassCard(
        imageUrl: Images.ekonomi,
        subjectName: 'Ekonomi',
      );
  factory ClassCard.not_found() => const ClassCard(
        imageUrl: Images.adminMainSubject,
        subjectName: 'Mata Pelajaran',
      );
}
