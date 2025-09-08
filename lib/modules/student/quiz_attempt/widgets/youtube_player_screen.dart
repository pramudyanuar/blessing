// import 'package:blessing/modules/student/quiz_attempt/quiz_result_screen.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:youtube_player_iframe/youtube_player_iframe.dart';
// import 'package:blessing/core/global_components/base_widget_container.dart';
// import 'package:blessing/core/global_components/global_text.dart';
// import 'package:blessing/core/utils/system_ui_util.dart';

// class YoutubePlayerScreen extends StatelessWidget {
//   const YoutubePlayerScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     const videoId = QuizResultScreen.videoId;
//     final controller = YoutubePlayerController.fromVideoId(
//       videoId: videoId,
//       autoPlay: true,
//       params: const YoutubePlayerParams(
//         showFullscreenButton: true,
//         strictRelatedVideos: true,
//         playsInline: true,
//         enableCaption: true,
//       ),
//     )..setFullScreenListener((isFullscreen) {
//         if (isFullscreen) {
//           // Masuk fullscreen → paksa landscape
//           SystemChrome.setPreferredOrientations([
//             DeviceOrientation.landscapeLeft,
//             DeviceOrientation.landscapeRight,
//           ]);
//         } else {
//           // Keluar fullscreen → kembalikan ke portrait
//           SystemChrome.setPreferredOrientations([
//             DeviceOrientation.portraitUp,
//           ]);
//           // Reset system UI menggunakan utility
//           SystemUIUtil.resetSystemUI();
//         }
//       });

//     return BaseWidgetContainer(
//       appBar: AppBar(
//         centerTitle: false,
//         title: GlobalText.semiBold("Pembahasan Kuis", fontSize: 16.sp),
//         backgroundColor: Colors.white,
//         elevation: 0.5,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
//           onPressed: () {
//             // Reset system UI menggunakan utility
//             SystemUIUtil.resetSystemUI();
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: YoutubePlayerScaffold(
//         controller: controller,
//         builder: (context, player) {
//           return SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 AspectRatio(aspectRatio: 16 / 9, child: player),
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: GlobalText.bold("Pembahasan Lengkap", fontSize: 18.sp),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 16.w),
//                   child: GlobalText.regular(
//                     maxLines: 5,
//                     textAlign: TextAlign.justify,
//                     "Tonton video ini untuk memahami pembahasan lengkap dari setiap soal yang ada di kuis. "
//                     "Pastikan kamu menonton sampai selesai agar tidak melewatkan tips penting.",
//                     fontSize: 14.sp,
//                   ),
//                 ),
//                 SizedBox(height: 20.h),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       GlobalText.semiBold("Poin Penting:", fontSize: 16.sp),
//                       SizedBox(height: 8.h),
//                       bulletPoint("Penjelasan konsep dasar setiap soal."),
//                       bulletPoint("Strategi menjawab lebih cepat."),
//                       bulletPoint("Kesalahan umum yang harus dihindari."),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 30.h),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget bulletPoint(String text) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 6.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text("• "),
//           Expanded(child: Text(text)),
//         ],
//       ),
//     );
//   }
// }
