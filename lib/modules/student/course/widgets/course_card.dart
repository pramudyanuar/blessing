// lib/modules/student/course/widgets/course_card.dart

import 'dart:ui';
import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Enum ini digunakan di seluruh aplikasi untuk menentukan tipe konten.
enum CourseContentType { material, quiz }

class CourseCard extends StatelessWidget {
  // --- Properti Umum ---
  final CourseContentType type;
  final String title;
  final String dateText;
  final String? description;
  final VoidCallback onTapAction;

  // --- Properti Khusus Materi ---
  final String? fileName;
  final List<Widget>? previewImages;

  // --- Properti Khusus Kuis ---
  final int? timeLimit;
  final int? questionCount;
  final bool isCompleted;
  final int? score;

  /// Konstruktor tunggal yang fleksibel untuk semua jenis kartu.
  const CourseCard({
    super.key,
    required this.type,
    required this.title,
    required this.dateText,
    required this.onTapAction,
    this.description,
    // Materi
    this.fileName,
    this.previewImages,
    // Kuis
    this.timeLimit,
    this.questionCount,
    this.isCompleted = false,
    this.score,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMaterial = type == CourseContentType.material;
    final IconData headerIcon =
        isMaterial ? Icons.menu_book_outlined : Icons.quiz_outlined;
    final String headerText = isMaterial ? "Materi Pembelajaran" : "Kuis";

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bagian Header Kartu
          _buildHeader(headerIcon, headerText),
          SizedBox(height: 12.h),

          // Judul Utama
          GlobalText.bold(title, fontSize: 16.sp, textAlign: TextAlign.start),
          SizedBox(height: 8.h),

          // Konten Inti (berbeda untuk materi dan kuis)
          if (isMaterial)
            _buildMaterialContent(context)
          else
            _buildQuizContent(context),

          // Preview Gambar (hanya untuk materi)
          if (isMaterial && previewImages != null && previewImages!.isNotEmpty)
            _buildImagePreview(context),
        ],
      ),
    );
  }

  // Widget Helper untuk membangun bagian Header
  Widget _buildHeader(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 18.sp, color: Colors.black87),
            SizedBox(width: 8.w),
            GlobalText.medium(text, fontSize: 12.sp),
          ],
        ),
        Flexible(
          child: GlobalText.light(
            dateText,
            fontSize: 11.sp,
            color: Colors.grey,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // Widget Helper untuk membangun konten khusus Materi
  Widget _buildMaterialContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (description != null)
          GlobalText.regular(
            description!,
            fontSize: 13.sp,
            color: AppColors.c6,
            textAlign: TextAlign.start,
          ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (fileName != null)
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.picture_as_pdf, size: 16.sp, color: Colors.red),
                    SizedBox(width: 4.w),
                    Flexible(
                        child: GlobalText.regular(fileName!,
                            fontSize: 13.sp, overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ),
            GestureDetector(
              onTap: onTapAction,
              child: Text(
                "Lihat Detail",
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Widget Helper untuk membangun konten khusus Kuis
  Widget _buildQuizContent(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Sisi Kiri: Deskripsi Kuis (Waktu & Jumlah Soal)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (description != null) ...[
                GlobalText.regular(description!,
                    fontSize: 13.sp, color: AppColors.c6),
                SizedBox(height: 4.h)
              ],
              if (timeLimit != null)
                _buildQuizDetailRow(
                    Icons.timer_outlined, "Waktu: $timeLimit menit"),
              if (questionCount != null)
                _buildQuizDetailRow(
                    Icons.help_outline, "Soal: $questionCount soal"),
            ],
          ),
        ),
        SizedBox(width: 16.w),
        // Sisi Kanan: Menampilkan Tombol "Mulai" atau Nilai
        if (isCompleted)
          _buildScoreDisplay()
        else
          ElevatedButton(
            onPressed: onTapAction,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E5B9F),
              shape: const StadiumBorder(),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
            ),
            child:
                GlobalText.bold("Mulai", fontSize: 13.sp, color: Colors.white),
          ),
      ],
    );
  }

  // Widget kecil untuk baris detail kuis
  Widget _buildQuizDetailRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: Row(
        children: [
          Icon(icon, size: 14.sp, color: Colors.grey.shade700),
          SizedBox(width: 6.w),
          GlobalText.regular(text, fontSize: 13.sp, color: AppColors.c6),
        ],
      ),
    );
  }

  // Widget kecil untuk menampilkan nilai
  Widget _buildScoreDisplay() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        GlobalText.bold(
          score?.toString() ?? 'N/A',
          fontSize: 26.sp,
          color: AppColors.c3,
        ),
        GlobalText.regular(
          '/100',
          fontSize: 14.sp,
          color: Colors.grey.shade600,
        )
      ],
    );
  }

  // Widget Helper untuk preview gambar (opsional, bisa diisi dengan logika dari kode lama)
  Widget _buildImagePreview(BuildContext context) {
    // Logika untuk menampilkan GridView gambar bisa ditambahkan di sini jika diperlukan.
    return const SizedBox.shrink();
  }
}
