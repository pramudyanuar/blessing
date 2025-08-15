import 'package:blessing/data/core/models/paging_response.dart';
import 'package:blessing/data/session/datasource/session_remote_datasource.dart';
import 'package:blessing/data/session/models/request/create_user_quiz_session_request.dart';
import 'package:blessing/data/session/models/response/user_quiz_session_response.dart';
import 'package:flutter/foundation.dart';

class SessionRepository {
  final SessionDataSource _dataSource = SessionDataSource();

  Future<({List<UserQuizSessionResponse> sessions, PagingResponse paging})?>
      getAllSessions({
    int page = 1,
    int size = 10,
    bool? submitted,
    String? userId,
    String? quizId,
  }) async {
    try {
      final result = await _dataSource.getAllSessions(
        page: page,
        size: size,
        submitted: submitted,
        userId: userId,
        quizId: quizId,
      );
      return result;
    } catch (e) {
      debugPrint('Error in SessionRepository (getAllSessions): $e');
      return null;
    }
  }

  Future<UserQuizSessionResponse?> getSessionById(String sessionId) async {
    try {
      return await _dataSource.getSessionById(sessionId);
    } catch (e) {
      debugPrint('Error in SessionRepository (getSessionById): $e');
      return null;
    }
  }

  Future<UserQuizSessionResponse?> createSession(
      CreateUserQuizSessionRequest request) async {
    try {
      return await _dataSource.createSession(request);
    } catch (e) {
      debugPrint('Error in SessionRepository (createSession): $e');
      return null;
    }
  }

  Future<UserQuizSessionResponse?> submitSession(String sessionId,
      {bool? autoSubmitted}) async {
    try {
      return await _dataSource.submitSession(sessionId,
          autoSubmitted: autoSubmitted);
    } catch (e) {
      debugPrint('Error in SessionRepository (submitSession): $e');
      return null;
    }
  }

  Future<int?> getSessionRemainingTime(String sessionId) async {
    try {
      return await _dataSource.getSessionRemainingTime(sessionId);
    } catch (e) {
      debugPrint('Error in SessionRepository (getSessionRemainingTime): $e');
      return null;
    }
  }
}
