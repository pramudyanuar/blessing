import 'package:blessing/core/middlewares/role_middleware.dart';
import 'package:blessing/core/utils/app_routes.dart';
import 'package:blessing/modules/admin/course/admin_assign_user_screen.dart';
import 'package:blessing/modules/admin/course/admin_course_detail_screen.dart';
import 'package:blessing/modules/admin/course/admin_detail_quiz_screen.dart';
import 'package:blessing/modules/admin/course/admin_manage_access_course_screen.dart';
import 'package:blessing/modules/admin/course/bindings/admin_assign_user_bindings.dart';
import 'package:blessing/modules/admin/course/bindings/admin_course_detail_bindings.dart';
import 'package:blessing/modules/admin/course/bindings/admin_detail_quiz_bindings.dart';
import 'package:blessing/modules/admin/course/bindings/admin_manage_access_course_bindings.dart' show AdminManageAccessCourseBindings;
import 'package:blessing/modules/admin/course/bindings/admin_manage_course_list_binding.dart';
import 'package:blessing/modules/admin/course/bindings/admin_upload_course_bindings.dart';
import 'package:blessing/modules/admin/course/bindings/create_quiz_bindings.dart';
import 'package:blessing/modules/admin/course/create_quiz_screen.dart';
import 'package:blessing/modules/admin/course/quiz_result_screen.dart';
import 'package:blessing/modules/admin/course/upload_course_screen.dart';
import 'package:blessing/modules/admin/homepage/admin_create_subject_screen.dart';
import 'package:blessing/modules/admin/homepage/bindings/admin_create_subject_binding.dart';
import 'package:blessing/modules/admin/homepage/bindings/admin_homepage_binding.dart';
import 'package:blessing/modules/admin/homepage/admin_homepage_screen.dart';
import 'package:blessing/modules/admin/main/bindings/main_admin_binding.dart';
import 'package:blessing/modules/admin/main/main_admin.dart';
import 'package:blessing/modules/admin/manage_student/add_student_screen.dart';
import 'package:blessing/modules/admin/manage_student/bindings/add_student_bindings.dart';
import 'package:blessing/modules/admin/manage_student/bindings/admin_manage_student_binding.dart';
import 'package:blessing/modules/admin/manage_student/admin_manage_student_screen.dart';
import 'package:blessing/modules/admin/manage_student/bindings/detail_student_bindings.dart';
import 'package:blessing/modules/admin/manage_student/detail_student_screen.dart';
import 'package:blessing/modules/admin/subject/admin_manage_subject_main_screen.dart';
import 'package:blessing/modules/admin/subject/bindings/subject_bindings.dart';
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
import 'package:blessing/modules/student/main/bindings/main_student_bindings.dart';
import 'package:blessing/modules/student/profile/bindings/profile_binding.dart';
import 'package:blessing/modules/student/quiz_attempt/bindings/quiz_attempt_binding.dart';
import 'package:blessing/modules/student/quiz_attempt/quiz_attempt_screen.dart';
import 'package:blessing/modules/student/quiz_attempt/quiz_result_screen.dart';
import 'package:blessing/modules/student/subject/bindings/subject_bindings.dart';
import 'package:blessing/modules/student/subject/subject_main_screen.dart';
import 'package:blessing/modules/student/main/main_student_screen.dart';
import 'package:blessing/modules/student/profile/profile_screen.dart';
import 'package:get/get.dart';

class AppPages {
  static final List<GetPage> routes = [
    /// Common
    GetPage(
      name: AppRoutes.initial,
      page: () => SplashScreen(),
      binding: SplashBinding()
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => OnboardingScreen(),
      binding: OnboardingBinding()
    ),
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
      page: () => MainAdminScreen(),
      middlewares: [RoleMiddleware(requiredRole: 'admin')],
      bindings: [
        MainAdminBinding(),
        AdminHomepageBinding(),
        AdminManageStudentBinding(),
      ]
    ),
    GetPage(
      name: AppRoutes.adminHomepage,
      page: () => AdminHomepageScreen(),
      middlewares: [RoleMiddleware(requiredRole: 'admin')],
      binding: AdminHomepageBinding(),
    ),
    GetPage(
      name: AppRoutes.manageStudent,
      page: () => AdminManageStudentScreen(),
      middlewares: [RoleMiddleware(requiredRole: 'admin')],
      binding: AdminManageStudentBinding(),
    ),
    GetPage(
      name: AppRoutes.manageSubject,
      page: () => AdminManageSubjectMainScreen(),
      bindings: [
        AdminManageSubjectBinding(),
        AdminManageCourseListBinding(),
      ],
      middlewares: [RoleMiddleware(requiredRole: 'admin')],
    ),
    GetPage(
      name: AppRoutes.detailStudent,
      page: () => DetailStudentScreen(),
      binding: DetailStudentBinding(),
      middlewares: [RoleMiddleware(requiredRole: 'admin')],
    ),
    GetPage(
      name: AppRoutes.addStudent,
      page: () => AddStudentScreen(),
      binding: AddStudentBindings(),
      middlewares: [RoleMiddleware(requiredRole: 'admin')],
    ),
    GetPage(
      name: AppRoutes.adminCreateCourse,
      page: () => const UploadCourseScreen(),
      binding: AdminUploadCourseBindings(),
      middlewares: [RoleMiddleware(requiredRole: 'admin')],
    ),
    GetPage(
      name: AppRoutes.adminCreateQuiz,
      page: () => CreateQuizScreen(), // Placeholder for quiz creation
      binding: CreateQuizBindings(),
      middlewares: [RoleMiddleware(requiredRole: 'admin')],
    ),
    GetPage(
      name: AppRoutes.adminCreateSubject,
      page: () => AdminCreateSubjectScreen(),
      binding: AdminCreateSubjectBinding(),
      middlewares: [RoleMiddleware(requiredRole: 'admin')],
    ),
    GetPage(
      name: AppRoutes.adminQuizResult,
      page: () => AdminQuizResultScreen(),
      middlewares: [RoleMiddleware(requiredRole: 'admin')],
    ),
    GetPage(
      name: AppRoutes.adminCourseDetail,
      page: () => AdminCourseDetailScreen(),
      binding: AdminCourseDetailBindings(),
      middlewares: [RoleMiddleware(requiredRole: 'admin')],
    ),
    GetPage(
      name: AppRoutes.adminManageCourseAccess,
      page: () => AdminManageAccessCourseScreen(),
      binding: AdminManageAccessCourseBindings(),
      middlewares: [RoleMiddleware(requiredRole: 'admin')],
    ),
    GetPage(
      name: AppRoutes.adminAssignUser,
      page: () => const AdminAssignUserScreen(),
      binding: AdminAssignUserBindings(),
      middlewares: [RoleMiddleware(requiredRole: 'admin')],
    ),
    GetPage(
      name: AppRoutes.adminDetailQuiz,
      page: () => const AdminDetailQuizScreen(),
      binding: AdminDetailQuizBindings(),
      middlewares: [RoleMiddleware(requiredRole: 'admin')],
    ),

    /// Student-only
    GetPage(
      name: AppRoutes.studentMenu,
      page: () => MainStudent(),
      binding: MainStudentBindings(),
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
        SubjectBinding(),
        CourseListBinding(),
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
    GetPage(
      name: AppRoutes.quizResult,
      page: () => const QuizResultScreen(),
      middlewares: [RoleMiddleware(requiredRole: 'student')],
    ),
  ];
}
