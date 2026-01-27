import 'package:blessing/core/services/endpoints.dart';
import 'package:blessing/core/services/http_manager.dart';
import 'package:blessing/data/core/models/paging_response.dart';
import 'package:blessing/data/session/models/request/create_user_quiz_session_request.dart';
import 'package:blessing/data/session/models/response/user_quiz_session_response.dart';
import 'package:flutter/foundation.dart';

class SessionDataSource {
  final HttpManager _httpManager = HttpManager();

  Future<({List<UserQuizSessionResponse> sessions, PagingResponse paging})?>
      getAllSessions({
    int page = 1,
    int size = 10,
    bool? submitted,
    String? userId,
    String? quizId,
  }) async {
    try {
      String url = '${Endpoints.getAllSessions}?page=$page&size=$size';
      if (submitted != null) {
        url += '&submitted=$submitted';
      }
      if (userId != null) {
        url += '&user_id=$userId';
      }
      if (quizId != null) {
        url += '&quiz_id=$quizId';
      }

      final response = await _httpManager.restRequest(
        url: url,
        method: HttpMethods.get,
      );

      if (response['statusCode'] == 200) {
        debugPrint('getAllSessions DataSource response: ${response['data']}');

        final responseData = response['data'] as Map<String, dynamic>?;
        final sessions = (responseData?['data'] as List?)
                ?.map((e) => UserQuizSessionResponse.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [];

        final paging = PagingResponse.fromJson(
            responseData?['paging'] as Map<String, dynamic>? ?? {});

        return (sessions: sessions, paging: paging);
      } else {
        debugPrint(
            'getAllSessions DataSource failed: ${response['statusMessage']}');
        return null;
      }
    } catch (e) {
      debugPrint('getAllSessions DataSource error: $e');
      return null;
    }
  }

  Future<UserQuizSessionResponse?> getSessionById(String sessionId) async {
    try {
      final url = Endpoints.getSessionById.replaceFirst('{id}', sessionId);

      final response = await _httpManager.restRequest(
        url: url,
        method: HttpMethods.get,
      );

      if (response['statusCode'] == 200) {
        debugPrint('getSessionById DataSource response: ${response['data']}');

        final responseData = response['data'] as Map<String, dynamic>?;
        final data = responseData?['data'];
        if (data != null) {
          return UserQuizSessionResponse.fromJson(data as Map<String, dynamic>);
        }
        return null;
      } else {
        debugPrint(
            'getSessionById DataSource failed: ${response['statusMessage']}');
        return null;
      }
    } catch (e) {
      debugPrint('getSessionById DataSource error: $e');
      return null;
    }
  }

  Future<UserQuizSessionResponse?> createSession(
      CreateUserQuizSessionRequest request) async {
    try {
      final url = Endpoints.createSession;

      final response = await _httpManager.restRequest(
        url: url,
        method: HttpMethods.post,
        body: request.toJson(),
      );
      
      if (response['statusCode'] == 200 || response['statusCode'] == 201) {
        debugPrint('createSession DataSource success: ${response['data']}');
        final data = response['data']['data'];
        return UserQuizSessionResponse.fromJson(data);
      } else {
        debugPrint(
            'createSession DataSource failed: ${response['statusMessage']}');
        return null;
      }
    } catch (e) {
      debugPrint('createSession DataSource error: $e');
      return null;
    }
  }

  Future<UserQuizSessionResponse?> submitSession(String sessionId,
      {bool? autoSubmitted}) async {
    try {
      String url =
          Endpoints.submitSessionById.replaceFirst('{sessionID}', sessionId);
      if (autoSubmitted != null) {
        url += '?auto_submitted=$autoSubmitted';
      }

      final response = await _httpManager.restRequest(
        url: url,
        method: HttpMethods.post,
      );
      
      if (response['statusCode'] == 200) {
        debugPrint('submitSession DataSource success: ${response['data']}');
        final data = response['data']['data'];
        return UserQuizSessionResponse.fromJson(data);
      } else {
        debugPrint(
            'submitSession DataSource failed: ${response['statusMessage']}');
        return null;
      }
    } catch (e) {
      debugPrint('submitSession DataSource error: $e');
      return null;
    }
  }

  Future<int?> getSessionRemainingTime(String sessionId) async {
    try {
      final url =
          Endpoints.getSessionTimeById.replaceFirst('{sessionId}', sessionId);

      final response = await _httpManager.restRequest(
        url: url,
        method: HttpMethods.get,
      );

      if (response['statusCode'] == 200) {
        debugPrint(
            'getSessionRemainingTime DataSource response: ${response['data']}');
        return response['data']['data']['time_in_seconds'];
      } else {
        debugPrint(
            'getSessionRemainingTime DataSource failed: ${response['statusMessage']}');
        return null;
      }
    } catch (e) {
      debugPrint('getSessionRemainingTime DataSource error: $e');
      return null;
    }
  }
}
