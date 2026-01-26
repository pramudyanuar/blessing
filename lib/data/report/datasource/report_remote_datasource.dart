import 'package:blessing/core/services/endpoints.dart';
import 'package:blessing/core/services/http_manager.dart';
import 'package:blessing/data/report/model/request/get_report_card_request.dart';
import 'package:blessing/data/report/model/request/get_user_report_card_request.dart';
import 'package:blessing/data/report/model/request/get_quiz_report_card_request.dart';
import 'package:blessing/data/report/model/response/report_card_response.dart';
import 'package:blessing/data/report/model/response/quiz_report_card_response.dart';
import 'package:blessing/data/report/model/response/quiz_report_data.dart';
import 'package:blessing/data/report/model/response/report_card_data.dart';
import 'package:blessing/data/report/model/response/paging.dart';
import 'package:flutter/foundation.dart';

class ReportDataSource {
  final HttpManager _httpManager = HttpManager();

  /// Mengambil report card siswa dengan pagination
  Future<ReportCardResponse?> getMyReportCard({
    int page = 1,
    int size = 10,
  }) async {
    try {
      // Membuat query parameters
      final request = GetReportCardRequest(page: page, size: size);
      final queryParams = request.toQueryParameters();

      // Menambahkan query parameters ke URL jika ada
      String url = Endpoints.getMyReportCard;
      if (queryParams.isNotEmpty) {
        final queryString =
            queryParams.entries.map((e) => '${e.key}=${e.value}').join('&');
        url = '$url?$queryString';
      }

      final response = await _httpManager.restRequest(
        url: url,
        method: HttpMethods.get,
      );

      if (response['statusCode'] == 200) {
        debugPrint('getMyReportCard DataSource response: ${response['data']}');
        return ReportCardResponse.fromJson(response['data']);
      } else {
        debugPrint(
            'getMyReportCard DataSource failed: ${response['statusMessage']}');
        return null;
      }
    } catch (e) {
      debugPrint('getMyReportCard DataSource error: $e');
      return null;
    }
  }

  /// Mengambil semua report card siswa tanpa pagination (untuk keperluan export/analytics)
  Future<ReportCardResponse?> getMyCompleteReportCard() async {
    try {
      final List<ReportCardResponse> allReports = [];
      int currentPage = 1;
      int totalPages = 1;
      const int pageSize = 50;

      // Loop untuk mengambil semua data
      while (currentPage <= totalPages) {
        final result = await getMyReportCard(
          page: currentPage,
          size: pageSize,
        );

        if (result != null) {
          // Update total pages dari response pertama
          if (currentPage == 1) {
            totalPages = result.paging.totalPage;
          }

          allReports.add(result);

          // Jika data yang diterima kurang dari ukuran halaman, berarti ini halaman terakhir
          if (result.data.quizzes.length < pageSize) {
            break;
          } else {
            currentPage++;
          }
        } else {
          // Jika terjadi error, hentikan loop
          break;
        }
      }

      // Gabungkan semua data quiz dari semua halaman
      if (allReports.isNotEmpty) {
        final firstReport = allReports.first;
        final allQuizzes =
            allReports.expand((report) => report.data.quizzes).toList();

        // Buat response gabungan dengan semua quiz
        return ReportCardResponse(
          data: ReportCardData(
            userId: firstReport.data.userId,
            userName: firstReport.data.userName,
            quizzes: allQuizzes,
            summary: firstReport
                .data.summary, // Summary tetap menggunakan yang pertama
          ),
          paging: Paging(
            page: 1,
            size: allQuizzes.length,
            totalItem: allQuizzes.length,
            totalPage: 1,
          ),
        );
      }

      return null;
    } catch (e) {
      debugPrint('getMyCompleteReportCard DataSource error: $e');
      return null;
    }
  }

  /// [ADMIN] Mengambil report card user berdasarkan user ID dengan pagination
  Future<ReportCardResponse?> getUserReportCard({
    required String userId,
    int page = 1,
    int size = 10,
  }) async {
    try {
      // Membuat query parameters
      final request = GetUserReportCardRequest(
        userId: userId,
        page: page,
        size: size,
      );
      final queryParams = request.toQueryParameters();

      // Mengganti placeholder {user_id} dengan userId yang sebenarnya
      String url =
          Endpoints.getUserReportCard.replaceFirst('{user_id}', userId);

      // Menambahkan query parameters ke URL jika ada
      if (queryParams.isNotEmpty) {
        final queryString =
            queryParams.entries.map((e) => '${e.key}=${e.value}').join('&');
        url = '$url?$queryString';
      }

      final response = await _httpManager.restRequest(
        url: url,
        method: HttpMethods.get,
      );

      if (response['statusCode'] == 200) {
        debugPrint(
            'getUserReportCard DataSource response: ${response['data']}');
        return ReportCardResponse.fromJson(response['data']);
      } else {
        debugPrint(
            'getUserReportCard DataSource failed: ${response['statusMessage']}');
        return null;
      }
    } catch (e) {
      debugPrint('getUserReportCard DataSource error: $e');
      return null;
    }
  }

  /// [ADMIN] Mengambil semua report card user berdasarkan user ID tanpa pagination
  Future<ReportCardResponse?> getUserCompleteReportCard({
    required String userId,
  }) async {
    try {
      final List<ReportCardResponse> allReports = [];
      int currentPage = 1;
      int totalPages = 1;
      const int pageSize = 50;

      // Loop untuk mengambil semua data
      while (currentPage <= totalPages) {
        final result = await getUserReportCard(
          userId: userId,
          page: currentPage,
          size: pageSize,
        );

        if (result != null) {
          // Update total pages dari response pertama
          if (currentPage == 1) {
            totalPages = result.paging.totalPage;
          }

          allReports.add(result);

          // Jika data yang diterima kurang dari ukuran halaman, berarti ini halaman terakhir
          if (result.data.quizzes.length < pageSize) {
            break;
          } else {
            currentPage++;
          }
        } else {
          // Jika terjadi error, hentikan loop
          break;
        }
      }

      // Gabungkan semua data quiz dari semua halaman
      if (allReports.isNotEmpty) {
        final firstReport = allReports.first;
        final allQuizzes =
            allReports.expand((report) => report.data.quizzes).toList();

        // Buat response gabungan dengan semua quiz
        return ReportCardResponse(
          data: ReportCardData(
            userId: firstReport.data.userId,
            userName: firstReport.data.userName,
            quizzes: allQuizzes,
            summary: firstReport
                .data.summary, // Summary tetap menggunakan yang pertama
          ),
          paging: Paging(
            page: 1,
            size: allQuizzes.length,
            totalItem: allQuizzes.length,
            totalPage: 1,
          ),
        );
      }

      return null;
    } catch (e) {
      debugPrint('getUserCompleteReportCard DataSource error: $e');
      return null;
    }
  }

  /// [ADMIN] Mengambil report card berdasarkan quiz ID dengan pagination
  Future<QuizReportCardResponse?> getQuizReportCard({
    required String quizId,
    String? userId,
    String? sortByScore,
    int page = 1,
    int size = 100,
  }) async {
    try {
      // Membuat query parameters
      final request = GetQuizReportCardRequest(
        quizId: quizId,
        userId: userId,
        sortByScore: sortByScore,
        page: page,
        size: size,
      );
      final queryParams = request.toQueryParameters();

      // Menambahkan query parameters ke URL
      String url = Endpoints.getAllQuizSessions;
      if (queryParams.isNotEmpty) {
        final queryString =
            queryParams.entries.map((e) => '${e.key}=${e.value}').join('&');
        url = '$url?$queryString';
      }

      final response = await _httpManager.restRequest(
        url: url,
        method: HttpMethods.get,
      );

      if (response['statusCode'] == 200) {
        debugPrint(
            'getQuizReportCard DataSource response: ${response['data']}');
        return QuizReportCardResponse.fromJson(response['data']);
      } else {
        debugPrint(
            'getQuizReportCard DataSource failed: ${response['statusMessage']}');
        return null;
      }
    } catch (e) {
      debugPrint('getQuizReportCard DataSource error: $e');
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
      final List<QuizReportCardResponse> allReports = [];
      int currentPage = 1;
      int totalPages = 1;
      const int pageSize = 100;

      // Loop untuk mengambil semua data
      while (currentPage <= totalPages) {
        final result = await getQuizReportCard(
          quizId: quizId,
          userId: userId,
          sortByScore: sortByScore,
          page: currentPage,
          size: pageSize,
        );

        if (result != null) {
          // Update total pages dari response pertama
          if (currentPage == 1) {
            totalPages = result.paging.totalPage;
          }

          allReports.add(result);

          // Jika data yang diterima kurang dari ukuran halaman, berarti ini halaman terakhir
          if (result.data.users.length < pageSize) {
            break;
          } else {
            currentPage++;
          }
        } else {
          // Jika terjadi error, hentikan loop
          break;
        }
      }

      // Gabungkan semua data users dari semua halaman
      if (allReports.isNotEmpty) {
        final firstReport = allReports.first;
        final allUsers =
            allReports.expand((report) => report.data.users).toList();

        // Buat response gabungan dengan semua users
        return QuizReportCardResponse(
          data: QuizReportData(
            quizId: firstReport.data.quizId,
            quizName: firstReport.data.quizName,
            users: allUsers,
            statistics: firstReport
                .data.statistics, // Statistics tetap menggunakan yang pertama
          ),
          paging: Paging(
            page: 1,
            size: allUsers.length,
            totalItem: allUsers.length,
            totalPage: 1,
          ),
        );
      }

      return null;
    } catch (e) {
      debugPrint('getCompleteQuizReportCard DataSource error: $e');
      return null;
    }
  }
}
