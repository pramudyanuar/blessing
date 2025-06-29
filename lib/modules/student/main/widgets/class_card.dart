import 'package:blessing/core/constants/images.dart';
import 'package:blessing/core/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ClassCard extends StatelessWidget {
  final String imageUrl;
  final String subjectName;
  final String subtitle;
  final String classLevel;

  const ClassCard({
    super.key,
    required this.imageUrl,
    required this.subjectName,
    // Kita bisa berikan nilai default jika datanya seragam
    this.subtitle = 'SMA 1 Jakarta - A',
    this.classLevel = 'Kelas 10',
  });

  @override
  Widget build(BuildContext context) {
    // 1. Dibungkus dengan GestureDetector agar bisa di-tap
    return GestureDetector(
      onTap: () {
        // 2. Aksi saat di-tap: navigasi ke halaman daftar materi
        Get.toNamed(
          AppRoutes.courseMain,
          arguments: {
            // 3. Kirim data spesifik dari kartu ini
            'title': subjectName,
            'subtitle': subtitle,
            'classLevel': classLevel,
            'imagePath': imageUrl,
          },
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        width: 1.sw,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imageUrl),
            fit: BoxFit.contain,
          ),
        ),
        child: AspectRatio(
          aspectRatio: 677 / 189,
          child: Container(),
        ),
      ),
    );
  }

  // --- Varian Khusus ---
  // Factory constructor sekarang juga menyertakan data yang relevan
  factory ClassCard.matematikaMinat() => const ClassCard(
        imageUrl: Images.matematikaMinat,
        subjectName: 'Matematika Minat',
        classLevel: 'Kelas 12', // Contoh data spesifik
      );
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
}
