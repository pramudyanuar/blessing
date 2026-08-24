// lib/modules/student/quiz_attempt/controller/quiz_attempt_controller.dart

import 'dart:async';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:blessing/core/global_components/custom_snackbar.dart';
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

  // Security & Performance Additions
  final RxInt outOfFocusCount = 0.obs;
  bool _showWarningDialogPending = false;
  final RxMap<String, Map<String, dynamic>> pendingSyncAnswers = <String, Map<String, dynamic>>{}.obs;
  bool _isSyncing = false;

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

    // Block screenshots during exam
    try {
      NoScreenshot.instance.screenshotOff();
    } catch (e) {
      debugPrint("Failed to block screenshots: $e");
    }

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
    // Re-enable screenshots
    try {
      NoScreenshot.instance.screenshotOn();
    } catch (e) {
      debugPrint("Failed to re-enable screenshots: $e");
    }

    // Remove observer saat controller ditutup
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    pageController.dispose();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    final isQuizRunning = !isLoading.value &&
        errorMessage.value.isEmpty &&
        remainingSeconds.value > 0;

    if (!isQuizRunning) return;

    // Cek jika user menekan home button atau switch app
    if (state == AppLifecycleState.paused) {
      debugPrint('Quiz: App moved to background (home button atau switch app)');
      outOfFocusCount.value++;
      _showWarningDialogPending = true;

      // Jika melanggar >= 3 kali, auto submit langsung
      if (outOfFocusCount.value >= 3) {
        submitQuiz(autoSubmitted: true);
      }
    } else if (state == AppLifecycleState.resumed) {
      debugPrint('Quiz: App resumed');
      if (_showWarningDialogPending && outOfFocusCount.value < 3) {
        _showWarningDialogPending = false;
        Get.dialog(
          AlertDialog(
            title: const Text(
              "Peringatan Kecurangan!",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            content: Text(
              "Anda terdeteksi keluar dari aplikasi ujian.\n\n"
              "Jumlah pelanggaran: ${outOfFocusCount.value} / 3.\n\n"
              "Jika Anda keluar aplikasi sebanyak 3 kali, ujian akan otomatis dikirim secara permanen.",
              style: TextStyle(fontSize: 14.sp),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text(
                  "Saya Mengerti",
                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          barrierDismissible: false,
        );
      }
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
        CustomSnackbar.show(
          title: "Info",
          message: "Anda sudah pernah mengerjakan kuis ini.",
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
        // Quiz sudah dikerjakan - set flag dan kembali ke halaman sebelumnya
        isQuizAlreadyAttempted.value = true;
        Get.back();
        CustomSnackbar.show(
          title: "Info",
          message: "Anda sudah pernah mengerjakan kuis ini.",
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
  /// Jika session tidak valid, fallback ke start quiz baru
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
        debugPrint("Resume failed: Session $resumeSessionId tidak ditemukan. Fallback ke start baru.");
        await initiateQuiz();
        return;
      }

      sessionId = sessionResponse.id;

      // 2. Get remaining time
      final remainingTime =
          await _sessionRepository.getSessionRemainingTime(sessionId!);
      if (remainingTime == null || remainingTime <= 0) {
        debugPrint("Resume failed: Session sudah expired (remaining: $remainingTime). Fallback ke start baru.");
        // Session sudah expired, mulai quiz baru
        await initiateQuiz();
        return;
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
      final errorString = e.toString().toLowerCase();
      
      if (errorString.contains('conflict') || errorString.contains('409')) {
        // Quiz sudah dikerjakan (conflict) - set flag dan kembali
        isQuizAlreadyAttempted.value = true;
        Get.back();
        CustomSnackbar.show(
          title: "Info",
          message: "Anda sudah pernah mengerjakan kuis ini.",
        );
      } else {
        debugPrint("Error during quiz resume: $e. Fallback ke start baru.");
        // Jika ada error lain atau session tidak valid, coba start baru
        try {
          isLoading.value = true;
          await initiateQuiz();
        } catch (initError) {
          final initErrorString = initError.toString().toLowerCase();
          if (initErrorString.contains('conflict') || initErrorString.contains('409')) {
            isQuizAlreadyAttempted.value = true;
            Get.back();
            CustomSnackbar.show(
              title: "Info",
              message: "Anda sudah pernah mengerjakan kuis ini.",
            );
          } else {
            errorMessage.value = "Gagal memulai kuis: ${initError.toString()}";
          }
          debugPrint("Error during fallback initiate: $initError");
        }
      }
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

  /// Dipanggil saat pengguna memilih jawaban. Menggunakan background queue agar robust saat koneksi putus.
  Future<void> selectAnswer(int questionIndex, int answerIndex) async {
    final question = questions[questionIndex];
    final options = optionsByQuestion[question.id];

    if (options == null || sessionId == null) {
      CustomSnackbar.show(title: "Error", message: "Sesi atau opsi tidak valid.", isError: true);
      return;
    }

    final selectedOption = options[answerIndex];
    final String? previousAnswerId = userAnswers[question.id];

    if (previousAnswerId == selectedOption.id) return; // Tidak ada perubahan

    final bool isUpdating = previousAnswerId != null;
    userAnswers[question.id] = selectedOption.id; // Update UI langsung agar instan

    // Tambahkan jawaban ke queue sinkronisasi
    pendingSyncAnswers[question.id] = {
      'optionId': selectedOption.id,
      'isUpdating': isUpdating,
      'previousOptionId': previousAnswerId,
    };

    // Jalankan sinkronisasi background
    _syncPendingAnswers();
  }

  /// Sinkronisasi background untuk jawaban-jawaban yang tertunda
  Future<void> _syncPendingAnswers() async {
    if (_isSyncing || pendingSyncAnswers.isEmpty) return;
    _isSyncing = true;

    try {
      while (pendingSyncAnswers.isNotEmpty) {
        final String questionId = pendingSyncAnswers.keys.first;
        final Map<String, dynamic>? pendingData = pendingSyncAnswers[questionId];
        if (pendingData == null) {
          pendingSyncAnswers.remove(questionId);
          continue;
        }

        final String optionId = pendingData['optionId'] as String;
        final bool isUpdating = pendingData['isUpdating'] as bool;

        try {
          final request = CreateUserAnswerRequest(
            sessionId: sessionId!,
            questionId: questionId,
            optionId: optionId,
          );

          dynamic response;
          if (isUpdating) {
            response = await _answerRepository.updateUserAnswer(request);
          } else {
            response = await _answerRepository.createUserAnswer(request);
          }

          if (response != null) {
            // Berhasil disinkronkan, hapus dari queue
            pendingSyncAnswers.remove(questionId);
            debugPrint("Jawaban berhasil disinkronkan ke server untuk soal: $questionId");
          } else {
            throw Exception("Response server null");
          }
        } catch (e) {
          debugPrint("Gagal mensinkronkan jawaban untuk soal $questionId: $e");
          // Tampilkan snackbar peringatan sekali saja agar user tahu koneksi lambat
          CustomSnackbar.show(
            title: "Koneksi Lambat",
            message: "Jawaban tersimpan lokal. Akan dikirim otomatis jika jaringan stabil.",
            isError: true,
            icon: Icons.wifi_off,
          );
          // Hentikan proses sinkronisasi, antrean tetap berada di pendingSyncAnswers
          break;
        }
      }
    } finally {
      _isSyncing = false;
    }
  }

  bool get isLastQuestion =>
      questions.isNotEmpty && currentQuestionIndex.value == questions.length - 1;

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
      CustomSnackbar.show(
        title: "Error",
        message: "Sesi tidak valid, tidak dapat mengirim jawaban.",
        isError: true,
      );
      return;
    }

    // Selesaikan sisa sinkronisasi jawaban yang tertunda jika ada
    if (pendingSyncAnswers.isNotEmpty) {
      debugPrint("Mencoba melakukan sinkronisasi sisa jawaban sebelum submit...");
      await _syncPendingAnswers();
    }

    // Jika masih ada sisa jawaban yang gagal tersinkronkan dan ini bukan autosubmit
    if (pendingSyncAnswers.isNotEmpty && !autoSubmitted) {
      Get.back(); // Tutup dialog loading
      Get.dialog(
        GlobalConfirmationDialog(
          message: "Beberapa jawaban Anda belum tersimpan ke server karena gangguan koneksi. Tetap kirim ujian?",
          onYes: () async {
            Get.back(); // Tutup dialog konfirmasi
            await _submitSessionFinal(autoSubmitted);
          },
          onNo: () {
            Get.back(); // Tutup dialog
            startTimer(); // Mulai kembali timer
          },
          yesText: "Tetap Kirim",
          noText: "Hubungkan Ulang",
        ),
        barrierDismissible: false,
      );
      return;
    }

    await _submitSessionFinal(autoSubmitted);
  }

  Future<void> _submitSessionFinal(bool autoSubmitted) async {
    // Pastikan dialog loading aktif
    if (Get.isDialogOpen == false) {
      Get.dialog(const Center(child: CircularProgressIndicator()),
          barrierDismissible: false);
    }

    // Panggil API untuk menandai sesi telah selesai
    final result = await _sessionRepository.submitSession(sessionId!,
        autoSubmitted: autoSubmitted);

    if (Get.isDialogOpen == true) {
      Get.back(); // Tutup dialog loading
    }

    if (result != null) {
      // Navigate ke quiz result screen untuk menampilkan skor dan pilihan see discussion/all attempts
      Get.toNamed(AppRoutes.quizResult, arguments: {
        'quizname': result.quiz?.quizName ?? 'Kuis',
        'result': result.score ?? 0,
        'quizId': quizId,
        'sessionId': sessionId,
      });
      CustomSnackbar.show(title: "Sukses", message: "Kuis berhasil diselesaikan!");
    } else {
      CustomSnackbar.show(title: "Gagal", message: "Gagal mengirimkan kuis. Coba lagi.", isError: true);
      startTimer(); // Mulai ulang timer jika submit gagal
    }
  }

  /// Build review items dari user answers dan options
  /// Membangun review items dari jawaban user dan soal-soal
  /// 
  /// Mencocokkan setiap pertanyaan dengan jawaban user yang dipilih.
  /// Note: correctAnswer dan isCorrect akan diterima dari backend 
  /// saat session di-submit atau di-fetch kembali.
}
