import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 1. Definisikan Enum untuk tipe konten
enum CourseContentType { material, quiz }

class CourseCard extends StatelessWidget {
  // 2. Perbarui parameter agar fleksibel
  final CourseContentType type; // <-- Parameter baru untuk menentukan tipe
  final String title;
  final String? description; // <-- Dibuat opsional
  final String dateText;
  final VoidCallback onTapAction;
  final String actionButtonText; // <-- Parameter baru untuk teks tombol

  // --- Parameter khusus Materi ---
  final String? fileName; // <-- Dibuat opsional
  final List<Widget>? previewImages;

  // --- Parameter khusus Kuis ---
  final int? timeLimit; // <-- Parameter baru untuk kuis

  const CourseCard({
    super.key,
    required this.type,
    required this.title,
    required this.dateText,
    required this.onTapAction,
    this.description,
    this.actionButtonText = "Lihat Detail", // Default value
    // Materi props
    this.fileName,
    this.previewImages,
    // Kuis props
    this.timeLimit,
  });

  @override
  Widget build(BuildContext context) {
    // 3. Siapkan variabel dinamis berdasarkan tipe
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
          /// Header (Dinamis)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(headerIcon, size: 18.sp, color: Colors.black87),
                  SizedBox(width: 8.w),
                  Text(
                    headerText,
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

          /// Description (Opsional)
          if (description != null && description!.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Text(
                description!,
                style: TextStyle(fontSize: 13.sp, color: Colors.black87),
              ),
            ),

          /// Konten Spesifik (File untuk Materi, Waktu untuk Kuis) & Tombol Aksi
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 4. Tampilkan widget info berdasarkan tipe
              if (isMaterial && fileName != null) _buildFileInfo(fileName!),
              if (!isMaterial && timeLimit != null) _buildQuizInfo(timeLimit!),

              // Jika tidak ada info spesifik, tampilkan widget kosong agar 'space-between' tetap bekerja
              if ((isMaterial && fileName == null) ||
                  (!isMaterial && timeLimit == null))
                const SizedBox(),

              GestureDetector(
                onTap: onTapAction,
                child: Text(
                  actionButtonText, // <-- Gunakan teks tombol dinamis
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),

          /// Preview Images (hanya untuk materi)
          if (isMaterial && previewImages != null && previewImages!.isNotEmpty)
            _buildImagePreview(),
        ],
      ),
    );
  }

  // Widget helper untuk info file materi
  Widget _buildFileInfo(String name) {
    return Row(
      children: [
        Icon(Icons.picture_as_pdf, size: 16.sp, color: Colors.red),
        SizedBox(width: 4.w),
        Text(name, style: TextStyle(fontSize: 13.sp)),
      ],
    );
  }

  // Widget helper untuk info kuis
  Widget _buildQuizInfo(int time) {
    return Row(
      children: [
        Icon(Icons.timer_outlined, size: 16.sp, color: Colors.orange),
        SizedBox(width: 4.w),
        Text("Waktu: $time menit", style: TextStyle(fontSize: 13.sp)),
      ],
    );
  }

  // Widget helper untuk preview gambar
  Widget _buildImagePreview() {
    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: SizedBox(
        height: 200.h,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8.h,
            crossAxisSpacing: 8.w,
            childAspectRatio: 1.3,
          ),
          itemCount: previewImages!.length > 4 ? 4 : previewImages!.length,
          itemBuilder: (context, index) {
            final isLastItem = index == 3 && previewImages!.length > 4;
            final image = previewImages![index];

            return Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: isLastItem
                      ? ImageFiltered(
                          imageFilter:
                              ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
                          child: image,
                        )
                      : image,
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
    );
  }
}
