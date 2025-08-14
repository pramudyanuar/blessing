class Endpoints {
  static const String baseUrl =
      'https://blessing-be-953847069536.asia-southeast2.run.app';

  static String _url(String path) => '$baseUrl$path';

  // User API
  static final String registerUser = _url('/api/users/register');
  static final String loginUser = _url('/api/users/login');
  static final String getCurrentUser = _url('/api/users/current');
  static final String getUserById = _url('/api/users/user/{id}');
  static final String logoutUser = _url('/api/users/logout');
  static final String updateUser = _url('/api/users');
  static final String getAllUsers = _url('/api/admin/users');
  static final String updateUserForAdmin = _url('/api/admin/users/{id}');
  static final String deleteUserForAdmin = _url('/api/admin/users/{id}');

  // Subject API
  static final String getAllSubjects = _url('/api/subjects');
  static final String createSubjectForAdmin = _url('/api/admin/subjects');
  static final String updateSubjectForAdmin =
      _url('/api/admin/subjects/{subjectId}');
  static final String deleteSubjectForAdmin =
      _url('/api/admin/subjects/{subjectId}');

  // Course API
  static final String getAllAccessibleCourses = _url('/api/courses');
  static final String getAccessibleCourseById = _url('/api/courses/{courseId}');
  static final String getAllCourses = _url('/api/admin/courses');
  static final String createCourseForAdmin = _url('/api/admin/courses');
  static final String uploadCourseDataForAdmin =
      _url('/api/admin/courses/upload');
  static final String uploadMultipleCourseDataForAdmin =
      _url('/api/admin/courses/multiple-uploads');
  static final String getCourseById = _url('/api/admin/courses/{courseId}');
  static final String updateCourseForAdmin =
      _url('/api/admin/courses/{courseId}');
  static final String deleteCourseForAdmin =
      _url('/api/admin/courses/{courseId}');
  static final String manageAccessibleCoursesForAdmin =
      _url('/api/admin/user-courses');
  static final String createUserCourseForAdmin =
      _url('/api/admin/user-courses');
  static final String deleteUserCourseForAdmin =
      _url('/api/admin/user-courses/{userCourseId}');

  // Quiz API
  static final String getAllQuizzes = _url('/api/quizzes');
  static final String getQuizById = _url('/api/quizzes/{quizId}');
  static final String createQuiz = _url('/api/admin/quizzes');
  static final String updateQuiz = _url('/api/admin/quizzes/{quizId}');
  static final String deleteQuiz = _url('/api/admin/quizzes/{quizId}');

  // Question API
  static final String getAllQuestions = _url('/api/questions');
  static final String getQuestionById = _url('/api/questions/{questionId}');
  static final String createQuestion = _url('/api/admin/questions');
  static final String uploadQuestionImageForAdmin =
      _url('/api/admin/questions/upload');
  static final String uploadMultipleQuestionImagesForAdmin =
      _url('/api/admin/questions/multiple-uploads');
  static final String updateQuestion =
      _url('/api/admin/questions/{questionId}');
  static final String deleteQuestion =
      _url('/api/admin/questions/{questionId}');

  // Option API
  static final String getAllOptionsByQuestionId =
      _url('/api/questions/{questionId}/options');
  static final String createOption =
      _url('/api/admin/questions/{questionId}/options');
  static final String updateOption =
      _url('/api/admin/question-options/{optionId}');
  static final String deleteOption =
      _url('/api/admin/question-options/{optionId}');

  // Quiz Answer API
  static final String getAllQuizAnswers = _url('/api/quiz-answers');
  static final String createQuizAnswerForAdmin =
      _url('/api/admin/quiz-answers');
  static final String updateQuizAnswerForAdmin =
      _url('/api/admin/quiz-answers/{quizAnswerId}');
  static final String deleteQuizAnswerForAdmin =
      _url('/api/admin/quiz-answers/{quizAnswerId}');

  // Session API
  static final String getAllSessions = _url('/api/sessions');
  static final String createSession = _url('/api/sessions');
  static final String getSessionById = _url('/api/sessions/{id}');
  static final String getSessionTimeById =
      _url('/api/sessions/{sessionId}/time');
  static final String submitSessionById =
      _url('/api/sessions/{sessionID}/submit');
  static final String updateSessionById = _url('/api/admin/sessions/{id}');
  static final String deleteSessionById = _url('/api/admin/sessions/{id}');

  // User Answer API
  static final String getUserAnswers = _url('/api/user-answers');
  static final String createUserAnswer = _url('/api/user-answers');
  static final String getUserAnswerById = _url('/api/user-answers/{id}');
  static final String deleteUserAnswerById = _url('/api/user-answers/{id}');

  // Report Card API
  static final String getMyReportCard = _url('/my-report-card');
  static final String getUserReportCard =
      _url('/api/admin/users/{user_id}/report-card');
  static final String getAllQuizSessions = _url('/api/admin/report-cards');
}
