import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:blessing/core/global_components/image_viewer_screen.dart';
import 'package:blessing/core/global_components/video_player_screen.dart';
import 'package:blessing/modules/student/course_detail/controllers/course_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseDetailScreen extends StatelessWidget {
  const CourseDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dapatkan instance controller yang sudah di-initialize
    final controller = Get.find<CourseDetailController>();

    return BaseWidgetContainer(
      appBar: AppBar(
        backgroundColor: AppColors.c2,
        foregroundColor: Colors.white,
        // Judul AppBar akan reaktif terhadap nama course
        title: Obx(() => GlobalText.regular(
              controller.course.value?.courseName ?? 'Detail Materi',
              color: Colors.white,
            )),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Get.back(),
        ),
      ),
      // Body akan reaktif terhadap state dari controller
      body: Obx(() {
        // 1. Tampilkan loading indicator jika sedang memuat
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // 2. Tampilkan pesan error jika ada
        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Text(
                controller.errorMessage.value,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          );
        }

        // 3. Tampilkan pesan jika konten kosong
        if (controller.contentItems.isEmpty) {
          return const Center(child: Text("Materi ini tidak memiliki konten."));
        }

        // 4. Jika data berhasil dimuat, tampilkan konten menggunakan ListView
        return _buildContentView(controller);
      }),
    );
  }

  /// Widget untuk membangun tampilan konten dari List
  Widget _buildContentView(CourseDetailController controller) {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: _getProcessedContentLength(controller.contentItems),
      itemBuilder: (context, index) {
        final processedItem =
            _getProcessedContentItem(controller.contentItems, index);

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
                child: GlobalText.regular(
                  data.toString(),
                  textAlign: TextAlign.start,
                  fontSize: 12.sp,
                  lineHeight: 1.5,
                  overflow: TextOverflow.visible,
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
    );
  }

  /// Menghitung jumlah item setelah diproses (menggabungkan gambar berturut-turut)
  int _getProcessedContentLength(List<Map<String, dynamic>> contentItems) {
    int count = 0;
    int i = 0;

    while (i < contentItems.length) {
      if (contentItems[i]['type'] == 'image') {
        // Hitung berapa banyak gambar berturut-turut
        int imageCount = 0;
        int j = i;
        while (j < contentItems.length && contentItems[j]['type'] == 'image') {
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
      List<Map<String, dynamic>> contentItems, int processedIndex) {
    int currentProcessedIndex = 0;
    int i = 0;

    while (i < contentItems.length) {
      if (contentItems[i]['type'] == 'image') {
        // Hitung berapa banyak gambar berturut-turut
        List<Map<String, dynamic>> consecutiveImages = [];
        int j = i;
        while (j < contentItems.length && contentItems[j]['type'] == 'image') {
          consecutiveImages.add({
            'data': contentItems[j]['data'],
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
            'type': contentItems[i]['type'],
            'data': contentItems[i]['data'],
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
            heroTag: 'course_image_$originalIndex',
          ),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 300),
        );
      },
      child: Hero(
        tag: 'course_image_$originalIndex',
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
            heroTag: 'course_image_$originalIndex',
          ),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 300),
        );
      },
      child: Hero(
        tag: 'course_image_$originalIndex',
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
              heroTag: 'course_image_$originalIndex',
            ),
            transition: Transition.fadeIn,
            duration: const Duration(milliseconds: 300),
          );
        },
        child: Hero(
          tag: 'course_image_$originalIndex',
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
