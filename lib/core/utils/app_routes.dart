abstract class AppRoutes {
  // Common Routes
  static const initial = '/';
  static const onboarding = '/onboarding';

  // Authentication Routes
  static const login = '/login';

  // Error Routes
  static const notFound = '/not-found';
  static const accessDenied = '/access-denied';

  // Admin Routes
  static const adminMenu = '/admin-menu';
  static const manageStudent = '/manage-student';
  static const detailStudent = '/detail-student';
  static const addStudent = '/add-student';
  static const adminHomepage = '/homepage';
  static const manageSubject = '/manage-subject';
  static const adminCreateCourse = '/admin-create-course';
  static const adminCreateQuiz = '/admin-create-quiz';
  static const adminCreateSubject = '/admin-create-subject';
  static const adminQuizResult = '/admin-quiz-result';
  static const adminCourseDetail = '/admin-course-detail';
  static const adminManageCourseAccess = '/admin-manage-course-access';

  // Student Routes
  static const studentMenu = '/student-menu';
  static const profile = '/profile';
  static const editProfile = '/edit-profile';
  static const courseMain = '/course-main';
  static const courseDetail = '/course-detail';
  static const quizList = '/quiz-list';
  static const quizAttempt = '/quiz-attempt';
  static const quizResult = '/quiz-result';
}
