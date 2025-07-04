import 'package:blessing/core/middlewares/role_middleware.dart';
import 'package:blessing/core/utils/app_routes.dart';
import 'package:blessing/modules/admin/main_admin.dart';
import 'package:blessing/modules/auth/login/bindings/login_binding.dart';
import 'package:blessing/modules/auth/login/login_screen.dart';
import 'package:blessing/modules/error/access_denied_screen.dart';
import 'package:blessing/modules/error/not_found_screen.dart';
import 'package:blessing/modules/onboarding/bindings/onboarding_binding.dart';
import 'package:blessing/modules/onboarding/onboarding_screen.dart';
import 'package:blessing/modules/splash/bindings/splash_binding.dart';
import 'package:blessing/modules/splash/splash_screen.dart';
import 'package:blessing/modules/student/course/bindings/course_list_binding.dart';
import 'package:blessing/modules/student/course_detail/bindings/course_detail_binding.dart';
import 'package:blessing/modules/student/course_detail/course_detail_screen.dart';
import 'package:blessing/modules/student/profile/bindings/profile_binding.dart';
import 'package:blessing/modules/student/quiz_attempt/bindings/quiz_attempt_binding.dart';
import 'package:blessing/modules/student/quiz/bindings/quiz_list_binding.dart';
import 'package:blessing/modules/student/quiz_attempt/quiz_attempt_screen.dart';
import 'package:blessing/modules/student/subject/subject_main_screen.dart';
import 'package:blessing/modules/student/main/main_student.dart';
import 'package:blessing/modules/student/profile/profile_screen.dart';
import 'package:get/get.dart';

class AppPages {
  static final List<GetPage> routes = [
    /// Common
    GetPage(
        name: AppRoutes.initial,
        page: () => SplashScreen(),
        binding: SplashBinding()),
    GetPage(
        name: AppRoutes.onboarding,
        page: () => OnboardingScreen(),
        binding: OnboardingBinding()),
    /// Authentication
    GetPage(
      name: AppRoutes.login,
      page: () => LoginScreen(),
      binding: LoginBinding()
    ),

    /// Error
    GetPage(
      name: AppRoutes.notFound,
      page: () => const NotFoundScreen(),
    ),

    GetPage(
      name: AppRoutes.accessDenied,
      page: () => const AccessDeniedScreen(),
    ),

    /// Admin-only
    GetPage(
      name: AppRoutes.adminMenu,
      page: () => MainAdmin(),
      middlewares: [RoleMiddleware(requiredRole: 'admin')],
    ),

    /// Student-only
    GetPage(
      name: AppRoutes.studentMenu,
      page: () => MainStudent(),
      middlewares: [RoleMiddleware(requiredRole: 'student')],
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileScreen(),
      binding: ProfileBinding(),
      middlewares: [RoleMiddleware(requiredRole: 'student')],
    ),
    GetPage(
      name: AppRoutes.courseMain,
      page: () => SubjectMainScreen(),
      bindings: [
        CourseListBinding(),
        QuizListBinding(),
      ],
      middlewares: [
        RoleMiddleware(requiredRole: 'student'),
      ],
    ),
    GetPage(
      name: AppRoutes.quizAttempt,
      page: () => const QuizAttemptScreen(),
      binding: QuizAttemptBinding(),
      middlewares: [RoleMiddleware(requiredRole: 'student')],
    ),
    GetPage(
      name: AppRoutes.courseDetail,
      page: () => const CourseDetailScreen(),
      binding: CourseDetailBinding(),
      middlewares: [RoleMiddleware(requiredRole: 'student')],
    ),
  ];
}
