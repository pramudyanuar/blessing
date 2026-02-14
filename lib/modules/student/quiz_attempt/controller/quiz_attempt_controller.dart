// lib/modules/student/quiz_attempt/controller/quiz_attempt_controller.dart

import 'dart:async';
import 'package:blessing/core/global_components/global_confirmation_dialog.dart';
import 'package:blessing/core/utils/app_routes.dart';
import 'package:blessing/data/quiz/models/response/question_option_response.dart';
import 'package:blessing/data/quiz/models/response/question_response.dart';
import 'package:blessing/data/quiz/repository/question_option_repository.dart';
import 'package:blessing/data/quiz/repository/question_repository_impl.dart';
import 'package:blessing/data/session/models/request/create_user_answer_request.dart';
import 'package:blessing/data/session/models/request/create_user_quiz_session_request.dart';
import 'package:blessing/data/session/repository/answer_repository_impl.dart';
import 'package:blessing/data/session/repository/session_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuizAttemptController extends GetxController with WidgetsBindingObserver {
  // --- Dependencies ---
  final SessionRepository _sessionRepository = SessionRepository();
  final QuestionRepository _questionRepository = QuestionRepository();
  final QuestionOptionRepository _optionRepository = QuestionOptionRepository();
  final AnswerRepository _answerRepository = AnswerRepository();

  // --- State & Data ---
  late final String quizId;
  String? sessionId;

  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  final RxInt totalDuration = 0.obs;
  final RxInt remainingSeconds = 0.obs;
  final RxBool isQuizAlreadyAttempted = false.obs;

  Timer? _timer;

  final RxInt currentQuestionIndex = 0.obs;
  late final PageController pageController;

  // Menyimpan jawaban terpilih (Key: questionId, Value: selectedOptionId)
  final RxMap<String, String?> userAnswers = <String, String?>{}.obs;

  // Daftar pertanyaan dan opsi dari API
  final RxList<QuestionResponse> questions = <QuestionResponse>[].obs;
  final RxMap<String, List<QuestionOptionResponse>> optionsByQuestion =
      <String, List<QuestionOptionResponse>>{}.obs;

  // Resume session
  bool isResume = false;
  String? resumeSessionId;

  // --- Lifecycle & Initialization ---
  @override
  void onInit() {
    super.onInit();
    // Register observer untuk lifecycle changes
    WidgetsBinding.instance.addObserver(this);
    pageController = PageController();

    // Handle arguments - bisa String (quizId) atau Map (for resume)
    if (Get.arguments is String) {
      quizId = Get.arguments;
      initiateQuiz();
    } else if (Get.arguments is Map) {
      final args = Get.arguments as Map<String, dynamic>;
      quizId = args['quizId'] ?? '';
      resumeSessionId = args['sessionId'];
      isResume = args['isResume'] ?? false;

      if (isResume && resumeSessionId != null) {
        resumeQuiz();
      } else {
        initiateQuiz();
      }
    } else {
      isLoading.value = false;
      errorMessage.value = "ID Kuis tidak valid atau tidak ditemukan.";
      debugPrint("Error: Quiz ID not provided in arguments.");
    }
  }

  @override
  void onClose() {
    // Remove observer saat controller ditutup
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    pageController.dispose();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    // Cek jika user menekan home button atau switch app
    if (state == AppLifecycleState.paused) {
      debugPrint('Quiz: App moved to background (home button atau switch app)');
      
      // Jangan auto-submit saat paused, biarkan user lanjutin asalkan waktu masih ada
      // Auto-submit hanya akan terjadi saat time habis (di _handleTimeUp)
    } else if (state == AppLifecycleState.resumed) {
      debugPrint('Quiz: App resumed');
    }
  }

  Future<bool> onWillPop() async {
    // 1. Izinkan keluar jika kuis belum dimulai, gagal dimuat, atau sudah selesai.
    final isQuizRunning = !isLoading.value &&
        errorMessage.value.isEmpty &&
        remainingSeconds.value > 0;

    if (!isQuizRunning) {
      return true; // Izinkan navigasi kembali
    }

    // 2. Jika kuis sedang berjalan, tampilkan dialog konfirmasi.
    final shouldExit = await Get.dialog<bool>(
      GlobalConfirmationDialog(
        message: 'Anda yakin ingin keluar dari kuis ini? Semua jawaban akan hilang.',
        onYes: () {
          Get.back(result: true); // Tutup dialog dengan result true
          submitQuiz(autoSubmitted: true);
        },
        onNo: () {
          Get.back(result: false); // Tutup dialog dengan result false
        },
      )
    ) ?? false;

    // 3. Kembalikan hasil dari dialog (true = exit, false = stay)
    return shouldExit;
  }

  /// Memulai sesi kuis, mengambil data soal, dan memulai timer.
  // --- Lifecycle & Initialization ---
  Future<void> initiateQuiz() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      isQuizAlreadyAttempted.value = false; // Reset state

      // 1. Buat sesi kuis baru
      final request = CreateUserQuizSessionRequest(quizId: quizId);
      final sessionResponse = await _sessionRepository.createSession(request);

      if (sessionResponse == null) {
        Get.back();
        Get.snackbar(
          "Info",
          "Anda sudah pernah mengerjakan kuis ini.",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        throw Exception("Gagal memulai sesi kuis. Respons dari server kosong.");
      }
      sessionId = sessionResponse.id;

      // 2. Ambil sisa waktu sesi
      final remainingTime =
          await _sessionRepository.getSessionRemainingTime(sessionId!);
      if (remainingTime == null) {
        throw Exception("Gagal mendapatkan durasi kuis.");
      }
      totalDuration.value = remainingTime;

      // 3. Ambil soal dan opsi
      await _fetchQuestionsAndOptions();

      // 4. Mulai timer
      startTimer();
    } catch (e) {
      final errorString = e.toString().toLowerCase();

      if (errorString.contains('conflict') || errorString.contains('409')) {
        // <<< BAGIAN INI DIUBAH >>>
        Get.back(); // langsung kembali ke halaman sebelumnya
        Get.snackbar(
          "Info",
          "Anda sudah pernah mengerjakan kuis ini.",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      } else {
        errorMessage.value = "Terjadi kesalahan: ${e.toString()}";
      }
      debugPrint("Error during quiz initiation: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Lanjutkan kuis yang sudah ada (resume session)
  Future<void> resumeQuiz() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      isQuizAlreadyAttempted.value = false;

      if (resumeSessionId == null) {
        throw Exception("Session ID tidak valid untuk resume.");
      }

      // 1. Fetch existing session untuk get remaining time
      final sessionResponse =
          await _sessionRepository.getSessionById(resumeSessionId!);
      if (sessionResponse == null) {
        throw Exception("Gagal memuat data sesi yang disimpan.");
      }

      sessionId = sessionResponse.id;

      // 2. Get remaining time
      final remainingTime =
          await _sessionRepository.getSessionRemainingTime(sessionId!);
      if (remainingTime == null || remainingTime <= 0) {
        throw Exception("Waktu untuk kuis ini sudah habis.");
      }
      totalDuration.value = remainingTime;

      // 3. Fetch questions and options
      await _fetchQuestionsAndOptions();

      // 4. Fetch existing answers dari session
      await _loadExistingAnswers();

      // 5. Start timer dengan remaining time
      startTimer();

      debugPrint("Quiz resumed successfully. Session ID: $sessionId");
    } catch (e) {
      errorMessage.value = "Gagal melanjutkan kuis: ${e.toString()}";
      debugPrint("Error during quiz resume: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Load jawaban yang sudah disimpan sebelumnya
  Future<void> _loadExistingAnswers() async {
    try {
      // const String answersUrl = '/api/answers?session_id=$sessionId';
      // final response = await _httpManager.restRequest(url: answersUrl);
      // if (response['statusCode'] == 200) {
      //   final answers = response['data']['data'] as List;
      //   for (var answer in answers) {
      //     userAnswers[answer['question_id']] = answer['selected_option_id'];
      //   }
      // }

      debugPrint("Existing answers loaded for session: $sessionId");
    } catch (e) {
      debugPrint("Error loading existing answers: $e");
      // Don't throw - continue with empty answers
    }
  }

  /// Mengambil data pertanyaan dan opsi jawaban dari API.
  Future<void> _fetchQuestionsAndOptions() async {
    final questionResult = await _questionRepository.getAllQuestions(
      quizId: quizId,
      page: 1,
      size: 100, // Asumsi mengambil semua soal sekaligus
    );

    if (questionResult != null && questionResult.questions.isNotEmpty) {
      questions.assignAll(questionResult.questions);
      for (var question in questions) {
        final optionResult =
            await _optionRepository.getAllOptionsByQuestionId(question.id);
        if (optionResult != null) {
          optionsByQuestion[question.id] = optionResult.options;
        }
      }
    } else {
      throw Exception("Tidak dapat memuat pertanyaan untuk kuis ini.");
    }
  }

  // --- Timer Logic ---
  void startTimer() {
    remainingSeconds.value = totalDuration.value;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        timer.cancel();
        _handleTimeUp();
      }
    });
  }

  String get timerText {
    final minutes = (remainingSeconds.value ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingSeconds.value % 60).toString().padLeft(2, '0');
    return "00:$minutes:$seconds";
  }

  // --- Quiz Logic ---

  /// Dipanggil saat pengguna memilih jawaban. Langsung mengirim jawaban ke server.
  Future<void> selectAnswer(int questionIndex, int answerIndex) async {
    final question = questions[questionIndex];
    final options = optionsByQuestion[question.id];

    if (options == null || sessionId == null) {
      Get.snackbar("Error", "Sesi atau opsi tidak valid.");
      return;
    }

    final selectedOption = options[answerIndex];
    final String? previousAnswerId = userAnswers[question.id];

    if (previousAnswerId == selectedOption.id) return; // Tidak ada perubahan

    final bool isUpdating = previousAnswerId != null;
    userAnswers[question.id] = selectedOption.id; // Update UI dulu

    try {
      if (isUpdating) {
        final request = CreateUserAnswerRequest(
            sessionId: sessionId!,
            questionId: question.id,
            optionId: selectedOption.id);
        final response = await _answerRepository.updateUserAnswer(request);
        if (response == null) throw Exception("Gagal memperbarui jawaban");
        debugPrint("Jawaban berhasil diperbarui untuk soal: ${question.id}");
      } else {
        final request = CreateUserAnswerRequest(
            sessionId: sessionId!,
            questionId: question.id,
            optionId: selectedOption.id);
        final response = await _answerRepository.createUserAnswer(request);
        if (response == null) throw Exception("Gagal menyimpan jawaban");
        debugPrint("Jawaban berhasil disimpan untuk soal: ${question.id}");
      }
    } catch (e) {
      userAnswers[question.id] = previousAnswerId; // Rollback jika gagal
      Get.snackbar(
          "Gagal", "Gagal menyimpan jawaban. Periksa koneksi internet Anda.",
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          colorText: Colors.white);
      debugPrint("Error saat menyimpan jawaban: $e");
    }
  }

  void nextPage() {
    if (currentQuestionIndex.value < questions.length - 1) {
      pageController.nextPage(
          duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
    }
  }

  void previousPage() {
    if (currentQuestionIndex.value > 0) {
      pageController.previousPage(
          duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
    }
  }

  void jumpToQuestion(int index) {
    pageController.jumpToPage(index);
    Get.back();
  }

  void confirmAndSubmitQuiz() {
    final totalQuestions = questions.length;
    final answeredQuestions = userAnswers.length;
    final unansweredQuestions = totalQuestions - answeredQuestions;

    String message = "Apakah Anda yakin ingin menyelesaikan kuis ini?";

    if (unansweredQuestions > 0) {
      message +=
          "\n\nAnda masih memiliki $unansweredQuestions soal yang belum dijawab.";
    }

    Get.dialog(
      GlobalConfirmationDialog(
        message: message,
        onYes: () {
          Get.back(); // Tutup dialog konfirmasi
          submitQuiz(); // Panggil fungsi submit yang sudah ada
        },
        onNo: () {
          Get.back(); // Tutup dialog, tidak melakukan apa-apa
        },
        yesText: "Ya, Kirim",
        noText: "Batal",
      ),
    );
  }

  // --- Submission Logic ---
  void _handleTimeUp() {
    Get.dialog(
      GlobalConfirmationDialog(
        message:
            "Waktu pengerjaan kuis telah berakhir. Jawaban Anda akan dikirim secara otomatis.",
        onYes: () {
          Get.back();
          submitQuiz(autoSubmitted: true);
        },
        onNo: () {
          // Opsi 'No' tidak relevan, tetap submit
          Get.back();
          submitQuiz(autoSubmitted: true);
        },
      ),
      barrierDismissible: false,
    );
  }

  /// Mengirimkan sesi kuis ke server untuk finalisasi.
  Future<void> submitQuiz({bool autoSubmitted = false}) async {
    _timer?.cancel();
    Get.dialog(const Center(child: CircularProgressIndicator()),
        barrierDismissible: false);

    if (sessionId == null) {
      Get.back();
      Get.snackbar("Error", "Sesi tidak valid, tidak dapat mengirim jawaban.");
      return;
    }

    // Panggil API untuk menandai sesi telah selesai
    final result = await _sessionRepository.submitSession(sessionId!,
        autoSubmitted: autoSubmitted);

    Get.back(); // Tutup dialog loading

    if (result != null) {
      // Kumpulkan data untuk review
      final reviewItems = _buildReviewItems();

      // Navigate ke review screen dengan data lengkap
      Get.toNamed(AppRoutes.quizReview, arguments: {
        'sessionId': sessionId,
        'quizName': result.quiz?.quizName ?? 'Kuis',
        'score': result.score ?? 0,
        'reviewItems': reviewItems,
      });
      Get.snackbar("Sukses", "Kuis berhasil diselesaikan!");
    } else {
      Get.snackbar("Gagal", "Gagal mengirimkan kuis. Coba lagi.");
      startTimer(); // Mulai ulang timer jika submit gagal
    }
  }

  /// Build review items dari user answers dan options
  List<Map<String, dynamic>> _buildReviewItems() {
    final List<Map<String, dynamic>> items = [];

    for (final question in questions) {
      final userAnswerId = userAnswers[question.id];
      final options = optionsByQuestion[question.id] ?? [];

      // Cari jawaban user
      QuestionOptionResponse? userAnswer;
      if (userAnswerId != null) {
        userAnswer = options.firstWhereOrNull((opt) => opt.id == userAnswerId);
      }

      // Untuk sekarang, kita belum punya cara untuk tahu jawaban benar dari API
      // Ini perlu di-extend kemudian dengan API yang mengembalikan correct answer
      final isCorrect = false; // Placeholder
      final correctAnswer = null; // Placeholder

      items.add({
        'question': question,
        'userAnswer': userAnswer,
        'correctAnswer': correctAnswer,
        'isCorrect': isCorrect,
      });
    }

    return items;
  }
}
