import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/core/global_components/global_confirmation_dialog.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:blessing/core/global_components/image_viewer_screen.dart';
import 'package:blessing/core/global_components/video_player_screen.dart';
import 'package:blessing/core/utils/app_routes.dart';
import 'package:blessing/modules/admin/course/controllers/admin_course_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminCourseDetailScreen extends StatelessWidget {
  const AdminCourseDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminCourseDetailController>();

    return BaseWidgetContainer(
      appBar: AppBar(
        title: GlobalText.semiBold("Detail Materi",
            fontSize: 18.sp, color: AppColors.c2),
        backgroundColor: AppColors.c1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.c2),
          onPressed: () {
            if (controller.isEditing.value) {
              controller.isEditing.value = false;
            } else {
              Get.back();
            }
          },
        ),
        shadowColor: Colors.black.withOpacity(0.4),
        surfaceTintColor: Colors.white,
        elevation: 0.5,
        actions: [
          Obx(() {
            if (controller.isEditing.value) {
              return IconButton(
                icon: const Icon(Icons.check, color: AppColors.c2),
                onPressed: controller.saveEdits,
              );
            } else {
              return PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: AppColors.c2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.r),
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, color: AppColors.c2),
                        const SizedBox(width: 8),
                        const Text('Edit Materi'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'akses',
                    child: Row(
                      children: [
                        Icon(Icons.accessibility, color: AppColors.c2),
                        const SizedBox(width: 8),
                        const Text('Akses Materi'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, color: AppColors.c7),
                        SizedBox(width: 8),
                        Text('Hapus Materi',
                            style: TextStyle(color: AppColors.c7)),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'edit') {
                    controller.startEditing();
                  } else if (value == 'akses') {
                    Get.toNamed(
                      AppRoutes.adminManageCourseAccess,
                      arguments: {
                        'courseId': controller.course.value!.id,
                        'gradeLevel': controller.course.value!.gradeLevel,
                      },
                    );
                  } else if (value == 'delete') {
                    Get.dialog(
                      GlobalConfirmationDialog(
                        message:
                            'Apakah Anda yakin ingin menghapus materi ini?',
                        onNo: () => Get.back(),
                        onYes: () {
                          controller.deleteCourse();
                        },
                      ),
                    );
                  }
                },
              );
            }
          }),
        ],
      ),
      backgroundColor: AppColors.c1,
      body: Obx(() {
        final index = controller.selectedIndex.value;
        if (index == 0) {
          if (controller.isLoading.value && controller.course.value == null) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.c2));
          }
          if (controller.course.value == null) {
            return Center(
                child: GlobalText.regular('Data tidak ditemukan',
                    color: AppColors.c2));
          }
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: controller.isEditing.value
                ? _buildEditMode(controller)
                : _buildViewMode(controller),
          );
        } else {
          if (controller.isQuizLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.c2),
            );
          }
          return _buildQuizSection(controller);
        }
      }),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: controller.selectedIndex.value,
            onTap: (i) => controller.selectedIndex.value = i,
            selectedItemColor: AppColors.c2,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.menu_book_outlined),
                label: 'Materi',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.quiz_outlined),
                label: 'Kuis',
              ),
            ],
          )),
    );
  }

  Widget _buildViewMode(AdminCourseDetailController controller) {
    final course = controller.course.value!;
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: AppColors.c1,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
              side: BorderSide(color: AppColors.c2, width: 0.5.w),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlobalText.bold(course.courseName ?? 'Tanpa Judul',
                      fontSize: 22.sp, color: AppColors.c2),
                  SizedBox(height: 12.h),
                  _buildInfoRow(
                      icon: Icons.class_outlined,
                      text: 'Kelas: ${course.gradeLevel}'),
                  SizedBox(height: 8.h),
                  _buildInfoRow(
                      icon: Icons.book_outlined,
                      text:
                          'Mata Pelajaran: ${course.subject?.subjectName ?? 'N/A'}'),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.h),
          GlobalText.semiBold("Isi Materi",
              fontSize: 18.sp, color: AppColors.c2),
          SizedBox(height: 12.h),
          _buildContentView(course.content!),
        ],
      ),
    );
  }

  Widget _buildQuizSection(AdminCourseDetailController controller) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Get.toNamed(AppRoutes.adminCreateQuiz,
                  arguments: {'courseId': controller.courseId});
            },
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(Icons.add, size: 20.sp, color: AppColors.c2),
                  SizedBox(width: 4.w),
                  GlobalText.medium("Tambah Kuis", color: AppColors.c2),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),
          if (controller.quizzes.isEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r)),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.quiz_outlined, size: 40.sp, color: Colors.grey),
                    SizedBox(height: 8.h),
                    GlobalText.regular("Belum ada kuis untuk materi ini.",
                        color: Colors.grey),
                  ],
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.quizzes.length,
              itemBuilder: (context, index) {
                final quiz = controller.quizzes[index];
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.only(bottom: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.quiz, color: AppColors.c2),
                    title: GlobalText.medium(
                      quiz.quizName ?? 'Kuis Tanpa Judul',
                      textAlign: TextAlign.start,
                    ),
                    subtitle: quiz.timeLimit != null
                        ? GlobalText.regular(
                            'Durasi: ${quiz.timeLimit} menit',
                            color: Colors.grey,
                            fontSize: 12.sp,
                            textAlign: TextAlign.start,
                          )
                        : null,
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Arahkan ke detail kuis
                      Get.toNamed(
                        AppRoutes.adminDetailQuiz,
                        arguments: {
                          'quizId': quiz.id,
                          'titleQuiz': quiz.quizName
                        },
                      );
                    },
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildEditMode(AdminCourseDetailController controller) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          TextField(
            controller: controller.courseNameController,
            onChanged: (v) => controller.editedCourseName.value = v,
            decoration: const InputDecoration(labelText: 'Judul Materi'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, color: AppColors.c2),
        SizedBox(width: 8.w),
        Flexible(
          child: GlobalText.regular(text, color: AppColors.c2, fontSize: 12.sp),
        ),
      ],
    );
  }

  /// Widget untuk membangun tampilan konten dari List
  Widget _buildContentView(List<dynamic> contentItems) {
    return Column(
      children: List.generate(
        _getProcessedContentLength(contentItems),
        (index) {
          final processedItem = _getProcessedContentItem(contentItems, index);

          if (processedItem['type'] == 'image_gallery') {
            final List<dynamic> images = processedItem['images'];
            return _buildImageGallery(images);
          } else {
            final type = processedItem['type'];
            final data = processedItem['data'];
            final originalIndex = processedItem['originalIndex'] ?? index;

            // Render widget berdasarkan tipe konten
            switch (type) {
              case 'text':
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: SizedBox(
                    width: double.infinity,
                    child: GlobalText.regular(
                      data.toString(),
                      textAlign: TextAlign.justify,
                      fontSize: 12.sp,
                      color: AppColors.c2,
                      lineHeight: 1.5,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                );
              case 'image':
                return _buildSingleImage(data.toString(), originalIndex);
              case 'link':
                return _buildLinkContent(data.toString(), originalIndex);
              default:
                return const SizedBox.shrink();
            }
          }
        },
      ),
    );
  }

  /// Menghitung jumlah item setelah diproses (menggabungkan gambar berturut-turut)
  int _getProcessedContentLength(List<dynamic> contentItems) {
    int count = 0;
    int i = 0;

    while (i < contentItems.length) {
      if (contentItems[i].type == 'image') {
        // Hitung berapa banyak gambar berturut-turut
        int imageCount = 0;
        int j = i;
        while (j < contentItems.length && contentItems[j].type == 'image') {
          imageCount++;
          j++;
        }

        if (imageCount > 1) {
          // Jika ada lebih dari 1 gambar berturut-turut, jadikan satu gallery
          count++;
          i = j;
        } else {
          // Jika hanya 1 gambar, tetap sebagai item terpisah
          count++;
          i++;
        }
      } else {
        count++;
        i++;
      }
    }

    return count;
  }

  /// Mendapatkan item konten yang sudah diproses berdasarkan index
  Map<String, dynamic> _getProcessedContentItem(
      List<dynamic> contentItems, int processedIndex) {
    int currentProcessedIndex = 0;
    int i = 0;

    while (i < contentItems.length) {
      if (contentItems[i].type == 'image') {
        // Hitung berapa banyak gambar berturut-turut
        List<Map<String, dynamic>> consecutiveImages = [];
        int j = i;
        while (j < contentItems.length && contentItems[j].type == 'image') {
          consecutiveImages.add({
            'data': contentItems[j].data,
            'originalIndex': j,
          });
          j++;
        }

        if (currentProcessedIndex == processedIndex) {
          if (consecutiveImages.length > 1) {
            // Return gallery
            return {
              'type': 'image_gallery',
              'images': consecutiveImages,
            };
          } else {
            // Return single image
            return {
              'type': 'image',
              'data': consecutiveImages[0]['data'],
              'originalIndex': consecutiveImages[0]['originalIndex'],
            };
          }
        }

        currentProcessedIndex++;
        i = j;
      } else {
        if (currentProcessedIndex == processedIndex) {
          return {
            'type': contentItems[i].type,
            'data': contentItems[i].data,
            'originalIndex': i,
          };
        }
        currentProcessedIndex++;
        i++;
      }
    }

    return {'type': 'unknown', 'data': ''};
  }

  /// Widget untuk menampilkan gallery gambar
  Widget _buildImageGallery(List<dynamic> images) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header untuk gallery
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              children: [
                Icon(
                  Icons.photo_library,
                  size: 16.sp,
                  color: Colors.grey[600],
                ),
                SizedBox(width: 4.w),
                Text(
                  '${images.length} Gambar',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Grid gambar
          _buildImageGrid(images),
        ],
      ),
    );
  }

  /// Widget untuk grid gambar
  Widget _buildImageGrid(List<dynamic> images) {
    if (images.length == 2) {
      return Row(
        children: [
          Expanded(child: _buildGridImageItem(images[0], 0)),
          SizedBox(width: 8.w),
          Expanded(child: _buildGridImageItem(images[1], 1)),
        ],
      );
    } else if (images.length == 3) {
      return Column(
        children: [
          _buildGridImageItem(images[0], 0),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(child: _buildGridImageItem(images[1], 1)),
              SizedBox(width: 8.w),
              Expanded(child: _buildGridImageItem(images[2], 2)),
            ],
          ),
        ],
      );
    } else if (images.length >= 4) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildGridImageItem(images[0], 0)),
              SizedBox(width: 8.w),
              Expanded(child: _buildGridImageItem(images[1], 1)),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(child: _buildGridImageItem(images[2], 2)),
              SizedBox(width: 8.w),
              Expanded(
                child: images.length > 4
                    ? _buildMoreImagesItem(images, 3)
                    : _buildGridImageItem(images[3], 3),
              ),
            ],
          ),
        ],
      );
    } else {
      // Fallback untuk 1 gambar (seharusnya tidak sampai sini)
      return _buildGridImageItem(images[0], 0);
    }
  }

  /// Widget untuk item gambar dalam grid
  Widget _buildGridImageItem(dynamic imageData, int index) {
    final imageUrl = imageData['data'].toString();
    final originalIndex = imageData['originalIndex'];

    return GestureDetector(
      onTap: () {
        Get.to(
          () => ImageViewerScreen(
            imageUrl: imageUrl,
            heroTag: 'admin_course_image_$originalIndex',
          ),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 300),
        );
      },
      child: Hero(
        tag: 'admin_course_image_$originalIndex',
        child: Container(
          height: 120.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    );
                  },
                ),
                // Zoom icon overlay
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Icon(
                      Icons.zoom_in,
                      color: Colors.white,
                      size: 16.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Widget untuk item "more images" (+X more)
  Widget _buildMoreImagesItem(List<dynamic> images, int startIndex) {
    final remainingCount = images.length - startIndex;
    final imageUrl = images[startIndex]['data'].toString();
    final originalIndex = images[startIndex]['originalIndex'];

    return GestureDetector(
      onTap: () {
        Get.to(
          () => ImageViewerScreen(
            imageUrl: imageUrl,
            heroTag: 'admin_course_image_$originalIndex',
          ),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 300),
        );
      },
      child: Hero(
        tag: 'admin_course_image_$originalIndex',
        child: Container(
          height: 120.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    );
                  },
                ),
                // Dark overlay with count
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                        Text(
                          '+$remainingCount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Widget untuk menampilkan gambar tunggal
  Widget _buildSingleImage(String imageUrl, int originalIndex) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: GestureDetector(
        onTap: () {
          Get.to(
            () => ImageViewerScreen(
              imageUrl: imageUrl,
              heroTag: 'admin_course_image_$originalIndex',
            ),
            transition: Transition.fadeIn,
            duration: const Duration(milliseconds: 300),
          );
        },
        child: Hero(
          tag: 'admin_course_image_$originalIndex',
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 200.h,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.broken_image,
                                size: 50, color: Colors.grey),
                            SizedBox(height: 8),
                            Text(
                              'Gagal memuat gambar',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Icon zoom di pojok kanan atas
              Positioned(
                top: 8.h,
                right: 8.w,
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Icon(
                    Icons.zoom_in,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget untuk menampilkan link/video content
  Widget _buildLinkContent(String link, int originalIndex) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: _buildVideoWidget(link),
    );
  }

  /// Widget untuk menampilkan video player atau link
  Widget _buildVideoWidget(String url) {
    // Check if it's a YouTube URL
    if (_isYouTubeUrl(url)) {
      return _buildYouTubePlayer(url);
    } else {
      // For other links, show a clickable card
      return _buildLinkCard(url);
    }
  }

  /// Check if URL is a YouTube URL
  bool _isYouTubeUrl(String url) {
    return url.contains('youtube.com') || url.contains('youtu.be');
  }

  /// Build YouTube player widget
  Widget _buildYouTubePlayer(String url) {
    final videoId = YoutubePlayer.convertUrlToId(url);

    if (videoId == null) {
      return _buildLinkCard(
          url); // Fallback to link card if video ID can't be extracted
    }

    return GestureDetector(
      onTap: () {
        Get.to(
          () => VideoPlayerScreen(
            videoUrl: url,
            title: 'Video Materi',
          ),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 300),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Stack(
            children: [
              // Video thumbnail
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // YouTube thumbnail
                      Image.network(
                        'https://img.youtube.com/vi/$videoId/maxresdefault.jpg',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: Icon(
                              Icons.video_library,
                              size: 60.sp,
                              color: Colors.grey[600],
                            ),
                          );
                        },
                      ),
                      // Play button overlay
                      Container(
                        width: 70.w,
                        height: 70.w,
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 40.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Video duration badge
              Positioned(
                bottom: 8.h,
                right: 8.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    'YouTube',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build clickable link card for non-YouTube links
  Widget _buildLinkCard(String url) {
    return GestureDetector(
      onTap: () => _launchUrl(url),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        margin: EdgeInsets.only(bottom: 8.h),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.blue.shade200),
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.link,
                color: Colors.blue.shade600,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Link External',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    url.length > 50 ? '${url.substring(0, 50)}...' : url,
                    style: TextStyle(
                      color: Colors.blue.shade600,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.open_in_new,
              color: Colors.blue.shade600,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  /// Launch URL in browser
  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Error',
          'Tidak dapat membuka link',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Link tidak valid',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
