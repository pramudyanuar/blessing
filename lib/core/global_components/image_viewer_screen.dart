import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:get/get.dart';

class ImageViewerScreen extends StatefulWidget {
  final String imageUrl;
  final String? heroTag;
  final List<String>? imageUrls; // For gallery mode
  final int? initialIndex; // Starting index for gallery

  const ImageViewerScreen({
    super.key,
    required this.imageUrl,
    this.heroTag,
    this.imageUrls,
    this.initialIndex,
  });

  @override
  State<ImageViewerScreen> createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<ImageViewerScreen> {
  bool _isAppBarVisible = true;
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex ?? 0;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _toggleAppBarVisibility() {
    setState(() {
      _isAppBarVisible = !_isAppBarVisible;
    });
  }

  bool get _isGalleryMode =>
      widget.imageUrls != null && widget.imageUrls!.length > 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: _isAppBarVisible
          ? AppBar(
              backgroundColor: Colors.black.withValues(alpha: 0.7),
              foregroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Get.back(),
              ),
              title: _isGalleryMode
                  ? Text(
                      '${_currentIndex + 1} / ${widget.imageUrls!.length}',
                      style: const TextStyle(fontSize: 16),
                    )
                  : null,
            )
          : null,
      body: GestureDetector(
        onTap: _toggleAppBarVisibility,
        child: _isGalleryMode ? _buildGalleryView() : _buildSingleImageView(),
      ),
    );
  }

  Widget _buildSingleImageView() {
    return PhotoView(
      imageProvider: NetworkImage(widget.imageUrl),
      backgroundDecoration: const BoxDecoration(color: Colors.black),
      minScale: PhotoViewComputedScale.contained * 0.5,
      maxScale: PhotoViewComputedScale.covered * 3.0,
      initialScale: PhotoViewComputedScale.contained,
      heroAttributes: widget.heroTag != null
          ? PhotoViewHeroAttributes(tag: widget.heroTag!)
          : null,
      enableRotation: true,
      loadingBuilder: (context, event) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.broken_image,
                color: Colors.white,
                size: 80,
              ),
              SizedBox(height: 16),
              Text(
                'Gagal memuat gambar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Tap untuk kembali',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGalleryView() {
    return PhotoViewGallery.builder(
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (BuildContext context, int index) {
        final imageUrl = widget.imageUrls![index];
        return PhotoViewGalleryPageOptions(
          imageProvider: NetworkImage(imageUrl),
          initialScale: PhotoViewComputedScale.contained,
          minScale: PhotoViewComputedScale.contained * 0.5,
          maxScale: PhotoViewComputedScale.covered * 3.0,
          heroAttributes: PhotoViewHeroAttributes(
            tag: 'gallery_image_$index',
          ),
        );
      },
      itemCount: widget.imageUrls!.length,
      backgroundDecoration: const BoxDecoration(color: Colors.black),
      pageController: _pageController,
      onPageChanged: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      loadingBuilder: (context, event) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        );
      },
    );
  }
}
