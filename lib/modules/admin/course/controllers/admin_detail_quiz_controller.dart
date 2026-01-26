import 'package:blessing/data/quiz/models/response/question_response.dart';
import 'package:blessing/data/quiz/models/response/question_option_response.dart';
import 'package:blessing/data/quiz/repository/question_option_repository.dart';
import 'package:blessing/data/quiz/repository/question_repository_impl.dart';
import 'package:blessing/data/quiz/repository/quiz_repository_impl.dart';
import 'package:get/get.dart';

class AdminDetailQuizController extends GetxController {
  final QuestionRepository _questionRepository = QuestionRepository();
  final QuestionOptionRepository _optionRepository = QuestionOptionRepository();
  final QuizRepository _quizRepository = QuizRepository();
  // final ReportCardRepository _reportCardRepository = ReportCardRepository();

  var questions = <QuestionResponse>[].obs;
  var optionsByQuestion = <String, List<QuestionOptionResponse>>{}.obs;
  // var reportData = <AllReportCardsResponse>[].obs;
  var isLoadingQuestions = false.obs;
  var isLoadingOptions = false.obs;
  var isLoadingReport = false.obs;
  var isDeleting = false.obs;

  late final String titleQuiz;
  late final String quizId;
  Function? onQuizDeleted; // Callback untuk refresh data quiz

  @override
  void onInit() {
    super.onInit();
    quizId = Get.arguments['quizId'];
    titleQuiz = Get.arguments['titleQuiz'];
    onQuizDeleted =
        Get.arguments['onQuizDeleted']; // Ambil callback dari arguments
    fetchQuestionsByQuizId();
    // fetchReport(quizId);
  }

  Future<void> fetchQuestionsByQuizId() async {
    try {
      isLoadingQuestions.value = true;
      final result = await _questionRepository.getAllQuestions(
        quizId: quizId,
        page: 1,
        size: 10,
      );
      if (result != null) {
        questions.assignAll(result.questions);
        await fetchOptionsForQuestions();
      }
    } finally {
      isLoadingQuestions.value = false;
    }
  }

  // Future<void> fetchReport(String qId) async {
  //   try {
  //     isLoadingReport.value = true;

  //     final result = await _reportCardRepository.getAllReportCards(quizId: qId, size: 100);
  //     if (result != null) {
  //       reportData.value = result.data.data;
  //     }
  //   } finally {
  //     isLoadingReport.value = false;
  //   }
  // }

  Future<void> fetchOptionsForQuestions() async {
    try {
      isLoadingOptions.value = true;
      for (var q in questions) {
        final result = await _optionRepository.getAllOptionsByQuestionId(q.id);
        if (result != null) {
          optionsByQuestion[q.id] = result.options;
        }
      }
    } finally {
      isLoadingOptions.value = false;
    }
  }

  Future<void> deleteQuiz() async {
    try {
      isDeleting.value = true;
      final success = await _quizRepository.deleteQuiz(quizId);
      if (success) {
        Get.back(); // keluar dari detail quiz
        Get.snackbar("Berhasil", "Kuis berhasil dihapus");
        // Panggil callback untuk refresh data quiz di halaman sebelumnya
        if (onQuizDeleted != null) {
          onQuizDeleted!();
        }
      } else {
        Get.snackbar("Gagal", "Tidak bisa menghapus kuis");
      }
    } finally {
      isDeleting.value = false;
    }
  }
}
