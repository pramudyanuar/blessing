import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/core/global_components/subject_appbar.dart';
import 'package:blessing/core/utils/app_routes.dart';
import 'package:blessing/modules/student/quiz/controllers/quiz_list_controller.dart';
import 'package:blessing/modules/student/quiz/widgets/quiz_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class QuizListScreen extends StatelessWidget {
  const QuizListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil argumen dari Get.arguments jika ada
    final arguments = Get.arguments as Map<String, dynamic>?;
    final title = arguments?['title'] ?? 'Matematika Minat';
    final classLevel = arguments?['classLevel'] ?? 'Kelas 10';
    final imagePath = arguments?['imagePath'] != null
        ? (() {
            final path = arguments!['imagePath'] as String;
            final lastSlash = path.lastIndexOf('/') + 1;
            final file = path.substring(lastSlash);
            final dir = path.substring(0, lastSlash);
            return dir + 'detail-' + file;
          })()
        : 'assets/images/detail-matematika-minat.webp';

    // Jangan inisialisasi controller manual jika sudah pakai bindings
    final controller = Get.find<QuizListController>();
        
    return BaseWidgetContainer(
        backgroundColor: AppColors.c5,
        appBar: SubjectAppbar(
          title: title,
          classLevel: classLevel,
          imagePath: imagePath,
        ),
        body: Obx(() => ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              itemCount: controller.quizzes.length,
              itemBuilder: (context, index) {
                final quizData = controller.quizzes[index];
                return QuizCard(
                  quizData: quizData,
                  onStartPressed: () {
                    // 2. GANTI PRINT DENGAN NAVIGASI KE HALAMAN KUIS
                    Get.toNamed(
                      AppRoutes.quizAttempt,
                      arguments: {
                        'quizTitle': quizData['title'],
                        // Anda juga bisa mengirim ID kuis jika ada
                        // 'quizId': quizData['id'],
                      },
                    );
                  },
                );
              },
            )),
      );
  }
}
