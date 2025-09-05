import 'package:blessing/core/services/endpoints.dart';
import 'package:blessing/core/services/http_manager.dart';
import 'package:blessing/data/core/models/paging_response.dart';
// Assuming you have these response models created based on the JSON structure
import 'package:blessing/data/report/model/response/all_report_cards_response.dart';
import 'package:blessing/data/report/model/response/user_report_card_response.dart';
import 'package:flutter/foundation.dart';

class ReportCardDataSource {
  final HttpManager _httpManager = HttpManager();

  /// Fetches the report card for the currently authenticated user.
  Future<({UserReportCardResponse reportCard, PagingResponse paging})?>
      getMyReportCard({
    int page = 1,
    int size = 10,
  }) async {
    try {
      final finalUrl = '${Endpoints.getMyReportCard}?page=$page&size=$size';

      final response = await _httpManager.restRequest(
        url: finalUrl,
        method: HttpMethods.get,
      );

      if (response['statusCode'] == 200) {
        debugPrint('getMyReportCard DataSource response: ${response['data']}');

        final reportCard =
            UserReportCardResponse.fromJson(response['data']['data']);
        final paging = PagingResponse.fromJson(response['data']['paging']);

        return (reportCard: reportCard, paging: paging);
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

  /// Fetches the report card for a specific user by their ID (Admin).
  Future<({UserReportCardResponse reportCard, PagingResponse paging})?>
      getUserReportCard(
    String userId, {
    int page = 1,
    int size = 10,
  }) async {
    try {
      final url = Endpoints.getUserReportCard.replaceFirst('{user_id}', userId);
      final finalUrl = '$url?page=$page&size=$size';

      final response = await _httpManager.restRequest(
        url: finalUrl,
        method: HttpMethods.get,
      );

      if (response['statusCode'] == 200) {
        debugPrint(
            'getUserReportCard DataSource response: ${response['data']}');

        final reportCard =
            UserReportCardResponse.fromJson(response['data']['data']);
        final paging = PagingResponse.fromJson(response['data']['paging']);

        return (reportCard: reportCard, paging: paging);
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

  /// Fetches all quiz sessions/report cards with optional filters (Admin).
  Future<({AllReportCardsResponse data, PagingResponse paging})?>
      getAllReportCards({
    String? quizId,
    String? userId,
    String? sortByScore, // 'asc' or 'desc'
    int page = 1,
    int size = 10,
  }) async {
    try {
      var url = '${Endpoints.getAllQuizSessions}?page=$page&size=$size';

      if (quizId != null && quizId.isNotEmpty) {
        url += '&quiz_id=$quizId';
      }
      if (userId != null && userId.isNotEmpty) {
        url += '&user_id=$userId';
      }
      if (sortByScore != null && sortByScore.isNotEmpty) {
        url += '&sort_by_score=$sortByScore';
      }

      final response = await _httpManager.restRequest(
        url: url,
        method: HttpMethods.get,
      );

      if (response['statusCode'] == 200) {
        debugPrint(
            'getAllReportCards DataSource response: ${response['data']}');

        final data = AllReportCardsResponse.fromJson(response['data']['data']);
        final paging = PagingResponse.fromJson(response['data']['paging']);

        return (data: data, paging: paging);
      } else {
        debugPrint(
            'getAllReportCards DataSource failed: ${response['statusMessage']}');
        return null;
      }
    } catch (e) {
      debugPrint('getAllReportCards DataSource error: $e');
      return null;
    }
  }
}
