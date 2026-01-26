import 'package:blessing/data/report/datasource/report_remote_datasource.dart';
import 'package:blessing/data/report/model/response/report_card_response.dart';
import 'package:blessing/data/report/model/response/quiz_report_card_response.dart';
import 'package:blessing/data/report/model/response/quiz_report_data.dart';
import 'package:blessing/data/report/model/response/report_card_data.dart';
import 'package:blessing/data/report/model/response/paging.dart';
import 'package:flutter/foundation.dart';

class ReportRepository {
  final ReportDataSource _dataSource = ReportDataSource();

  /// Mengambil report card siswa dengan pagination
  Future<ReportCardResponse?> getMyReportCard({
    int page = 1,
    int size = 10,
  }) async {
    try {
      final result = await _dataSource.getMyReportCard(
        page: page,
        size: size,
      );
      return result;
    } catch (e) {
      debugPrint('Error in ReportRepository (getMyReportCard): $e');
      return null;
    }
  }

  /// Mengambil semua report card siswa tanpa pagination
  Future<ReportCardResponse?> getMyCompleteReportCard() async {
    try {
      final result = await _dataSource.getMyCompleteReportCard();
      return result;
    } catch (e) {
      debugPrint('Error in ReportRepository (getMyCompleteReportCard): $e');
      return null;
    }
  }

  /// Mengambil quiz yang sudah dikerjakan saja
  Future<ReportCardResponse?> getMyAttemptedQuizzes({
    int page = 1,
    int size = 10,
  }) async {
    try {
      final result = await _dataSource.getMyReportCard(
        page: page,
        size: size,
      );

      if (result != null) {
        // Filter hanya quiz yang sudah dikerjakan
        final attemptedQuizzes =
            result.data.quizzes.where((quiz) => quiz.isAttempted).toList();

        // Buat response baru dengan quiz yang sudah dikerjakan saja
        return ReportCardResponse(
          data: ReportCardData(
            userId: result.data.userId,
            userName: result.data.userName,
            quizzes: attemptedQuizzes,
            summary: result.data.summary,
          ),
          paging: Paging(
            page: result.paging.page,
            size: attemptedQuizzes.length,
            totalItem: result.data.summary.attemptedQuizzes,
            totalPage: result.paging.totalPage,
          ),
        );
      }

      return null;
    } catch (e) {
      debugPrint('Error in ReportRepository (getMyAttemptedQuizzes): $e');
      return null;
    }
  }

  /// Mengambil quiz yang belum dikerjakan saja
  Future<ReportCardResponse?> getMyNotAttemptedQuizzes({
    int page = 1,
    int size = 10,
  }) async {
    try {
      final result = await _dataSource.getMyReportCard(
        page: page,
        size: size,
      );

      if (result != null) {
        // Filter hanya quiz yang belum dikerjakan
        final notAttemptedQuizzes =
            result.data.quizzes.where((quiz) => !quiz.isAttempted).toList();

        // Buat response baru dengan quiz yang belum dikerjakan saja
        return ReportCardResponse(
          data: ReportCardData(
            userId: result.data.userId,
            userName: result.data.userName,
            quizzes: notAttemptedQuizzes,
            summary: result.data.summary,
          ),
          paging: Paging(
            page: result.paging.page,
            size: notAttemptedQuizzes.length,
            totalItem:
                result.paging.totalItem - result.data.summary.attemptedQuizzes,
            totalPage: result.paging.totalPage,
          ),
        );
      }

      return null;
    } catch (e) {
      debugPrint('Error in ReportRepository (getMyNotAttemptedQuizzes): $e');
      return null;
    }
  }

  // ============ ADMIN METHODS ============

  /// [ADMIN] Mengambil report card user berdasarkan user ID dengan pagination
  Future<ReportCardResponse?> getUserReportCard({
    required String userId,
    int page = 1,
    int size = 10,
  }) async {
    try {
      final result = await _dataSource.getUserReportCard(
        userId: userId,
        page: page,
        size: size,
      );
      return result;
    } catch (e) {
      debugPrint('Error in ReportRepository (getUserReportCard): $e');
      return null;
    }
  }

  /// [ADMIN] Mengambil semua report card user berdasarkan user ID tanpa pagination
  Future<ReportCardResponse?> getUserCompleteReportCard({
    required String userId,
  }) async {
    try {
      final result = await _dataSource.getUserCompleteReportCard(
        userId: userId,
      );
      return result;
    } catch (e) {
      debugPrint('Error in ReportRepository (getUserCompleteReportCard): $e');
      return null;
    }
  }

  /// [ADMIN] Mengambil quiz yang sudah dikerjakan saja berdasarkan user ID
  Future<ReportCardResponse?> getUserAttemptedQuizzes({
    required String userId,
    int page = 1,
    int size = 10,
  }) async {
    try {
      final result = await _dataSource.getUserReportCard(
        userId: userId,
        page: page,
        size: size,
      );

      if (result != null) {
        // Filter hanya quiz yang sudah dikerjakan
        final attemptedQuizzes =
            result.data.quizzes.where((quiz) => quiz.isAttempted).toList();

        // Buat response baru dengan quiz yang sudah dikerjakan saja
        return ReportCardResponse(
          data: ReportCardData(
            userId: result.data.userId,
            userName: result.data.userName,
            quizzes: attemptedQuizzes,
            summary: result.data.summary,
          ),
          paging: Paging(
            page: result.paging.page,
            size: attemptedQuizzes.length,
            totalItem: result.data.summary.attemptedQuizzes,
            totalPage: result.paging.totalPage,
          ),
        );
      }

      return null;
    } catch (e) {
      debugPrint('Error in ReportRepository (getUserAttemptedQuizzes): $e');
      return null;
    }
  }

  /// [ADMIN] Mengambil quiz yang belum dikerjakan saja berdasarkan user ID
  Future<ReportCardResponse?> getUserNotAttemptedQuizzes({
    required String userId,
    int page = 1,
    int size = 10,
  }) async {
    try {
      final result = await _dataSource.getUserReportCard(
        userId: userId,
        page: page,
        size: size,
      );

      if (result != null) {
        // Filter hanya quiz yang belum dikerjakan
        final notAttemptedQuizzes =
            result.data.quizzes.where((quiz) => !quiz.isAttempted).toList();

        // Buat response baru dengan quiz yang belum dikerjakan saja
        return ReportCardResponse(
          data: ReportCardData(
            userId: result.data.userId,
            userName: result.data.userName,
            quizzes: notAttemptedQuizzes,
            summary: result.data.summary,
          ),
          paging: Paging(
            page: result.paging.page,
            size: notAttemptedQuizzes.length,
            totalItem:
                result.paging.totalItem - result.data.summary.attemptedQuizzes,
            totalPage: result.paging.totalPage,
          ),
        );
      }

      return null;
    } catch (e) {
      debugPrint('Error in ReportRepository (getUserNotAttemptedQuizzes): $e');
      return null;
    }
  }

  // ============ QUIZ REPORT METHODS ============

  /// [ADMIN] Mengambil report card berdasarkan quiz ID dengan pagination
  Future<QuizReportCardResponse?> getQuizReportCard({
    required String quizId,
    String? userId,
    String? sortByScore,
    int page = 1,
    int size = 100,
  }) async {
    try {
      final result = await _dataSource.getQuizReportCard(
        quizId: quizId,
        userId: userId,
        sortByScore: sortByScore,
        page: page,
        size: size,
      );
      return result;
    } catch (e) {
      debugPrint('Error in ReportRepository (getQuizReportCard): $e');
      return null;
    }
  }

  /// [ADMIN] Mengambil semua data report card berdasarkan quiz ID tanpa pagination
  Future<QuizReportCardResponse?> getCompleteQuizReportCard({
    required String quizId,
    String? userId,
    String? sortByScore,
  }) async {
    try {
      final result = await _dataSource.getCompleteQuizReportCard(
        quizId: quizId,
        userId: userId,
        sortByScore: sortByScore,
      );
      return result;
    } catch (e) {
      debugPrint('Error in ReportRepository (getCompleteQuizReportCard): $e');
      return null;
    }
  }

  /// [ADMIN] Mengambil users yang sudah mengerjakan quiz berdasarkan quiz ID
  Future<QuizReportCardResponse?> getQuizAttemptedUsers({
    required String quizId,
    String? sortByScore,
    int page = 1,
    int size = 100,
  }) async {
    try {
      final result = await _dataSource.getQuizReportCard(
        quizId: quizId,
        sortByScore: sortByScore,
        page: page,
        size: size,
      );

      if (result != null) {
        // Filter hanya users yang sudah mengerjakan
        final attemptedUsers =
            result.data.users.where((user) => user.isAttempted).toList();

        // Buat response baru dengan users yang sudah mengerjakan saja
        return QuizReportCardResponse(
          data: QuizReportData(
            quizId: result.data.quizId,
            quizName: result.data.quizName,
            users: attemptedUsers,
            statistics: result.data.statistics,
          ),
          paging: Paging(
            page: result.paging.page,
            size: attemptedUsers.length,
            totalItem: result.data.statistics.studentsAttempted,
            totalPage: result.paging.totalPage,
          ),
        );
      }

      return null;
    } catch (e) {
      debugPrint('Error in ReportRepository (getQuizAttemptedUsers): $e');
      return null;
    }
  }

  /// [ADMIN] Mengambil users yang belum mengerjakan quiz berdasarkan quiz ID
  Future<QuizReportCardResponse?> getQuizNotAttemptedUsers({
    required String quizId,
    int page = 1,
    int size = 100,
  }) async {
    try {
      final result = await _dataSource.getQuizReportCard(
        quizId: quizId,
        page: page,
        size: size,
      );

      if (result != null) {
        // Filter hanya users yang belum mengerjakan
        final notAttemptedUsers =
            result.data.users.where((user) => !user.isAttempted).toList();

        // Buat response baru dengan users yang belum mengerjakan saja
        return QuizReportCardResponse(
          data: QuizReportData(
            quizId: result.data.quizId,
            quizName: result.data.quizName,
            users: notAttemptedUsers,
            statistics: result.data.statistics,
          ),
          paging: Paging(
            page: result.paging.page,
            size: notAttemptedUsers.length,
            totalItem: result.data.statistics.totalStudentsWithAccess -
                result.data.statistics.studentsAttempted,
            totalPage: result.paging.totalPage,
          ),
        );
      }

      return null;
    } catch (e) {
      debugPrint('Error in ReportRepository (getQuizNotAttemptedUsers): $e');
      return null;
    }
  }
}
