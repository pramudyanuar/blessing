import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:blessing/core/utils/system_ui_util.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String title;

  const VideoPlayerScreen({
    super.key,
    required this.videoUrl,
    this.title = 'Video Player',
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();

    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);

    _controller = YoutubePlayerController(
      initialVideoId: videoId!,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: true,
        captionLanguage: 'id',
        forceHD: false,
        useHybridComposition: true,
        controlsVisibleAtStart: true,
        disableDragSeek: false,
        hideControls: false,
      ),
    );

    // Allow all orientations for video playback
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _controller.addListener(() {
      if (_controller.value.isFullScreen != _isFullScreen) {
        setState(() {
          _isFullScreen = _controller.value.isFullScreen;
        });

        // Set system UI berdasarkan status fullscreen
        if (_isFullScreen) {
          SystemUIUtil.setVideoFullscreenUI();
        } else {
          SystemUIUtil.setVideoNormalUI();
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    // Reset system UI menggunakan utility
    SystemUIUtil.resetSystemUI();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Reset system UI menggunakan utility
        SystemUIUtil.resetSystemUI();
        return true;
      },
      child: YoutubePlayerBuilder(
        onExitFullScreen: () {
          // Don't change orientation when exiting fullscreen
          // Let user stay in current orientation
        },
        player: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.red,
          onReady: () {
            print('Player is ready.');
          },
          onEnded: (data) {
            // Auto exit fullscreen when video ends
            if (_isFullScreen) {
              _controller.toggleFullScreenMode();
            }
          },
        ),
        builder: (context, player) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: _isFullScreen
                ? null
                : AppBar(
                    backgroundColor: Colors.black,
                    title: Text(
                      widget.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                      ),
                    ),
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        // Reset system UI menggunakan utility
                        SystemUIUtil.resetSystemUI();
                        Get.back();
                      },
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.fullscreen, color: Colors.white),
                        onPressed: () {
                          _controller.toggleFullScreenMode();
                        },
                      ),
                    ],
                  ),
            body: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: player,
              ),
            ),
          );
        },
      ),
    );
  }
}
