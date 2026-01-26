// lib/data/quiz/datasource/quiz_answer_remote_datasource.dart

import 'package:blessing/core/services/endpoints.dart';
import 'package:blessing/core/services/http_manager.dart';
import 'package:blessing/data/core/models/paging_response.dart';
import 'package:blessing/data/quiz/models/request/create_quiz_answer_request.dart';
import 'package:blessing/data/quiz/models/response/quiz_answer_response.dart';
import 'package:flutter/foundation.dart';

class QuizAnswerDataSource {
  final HttpManager _httpManager = HttpManager();

  Future<({List<QuizAnswerResponse> answers, PagingResponse paging})?>
      getAllQuizAnswers({
    int page = 1,
    int size = 10,
    String? quizId,
  }) async {
    try {
      String url = Endpoints.getAllQuizAnswers;
      final Map<String, dynamic> queryParameters = {
        'page': page.toString(),
        'size': size.toString(),
      };
      if (quizId != null) {
        queryParameters['quiz_id'] = quizId;
      }

      final response = await _httpManager.restRequest(
        url: url,
        method: HttpMethods.get,
        queryParameters: queryParameters,
      );

      if (response['statusCode'] == 200) {
        debugPrint(
            'getAllQuizAnswers DataSource response: ${response['data']}');

        final answers = (response['data']['data'] as List)
            .map((e) => QuizAnswerResponse.fromJson(e))
            .toList();

        final paging = PagingResponse.fromJson(response['data']['paging']);

        return (answers: answers, paging: paging);
      } else {
        debugPrint(
            'getAllQuizAnswers DataSource failed: ${response['statusMessage']}');
        return null;
      }
    } catch (e) {
      debugPrint('getAllQuizAnswers DataSource error: $e');
      return null;
    }
  }

  Future<QuizAnswerResponse?> getQuizAnswerById(String quizAnswerId) async {
    try {
      final url = Endpoints.getUserAnswerById
          .replaceFirst('{quizAnswerId}', quizAnswerId);

      final response = await _httpManager.restRequest(
        url: url,
        method: HttpMethods.get,
      );

      if (response['statusCode'] == 200) {
        debugPrint('getQuizAnswerById DataSource success: ${response['data']}');
        return QuizAnswerResponse.fromJson(response['data']['data']);
      } else {
        debugPrint(
            'getQuizAnswerById DataSource failed: ${response['statusMessage']}');
        return null;
      }
    } catch (e) {
      debugPrint('getQuizAnswerById DataSource error: $e');
      return null;
    }
  }


  Future<bool> createQuizAnswer(CreateQuizAnswerRequest request) async {
    try {
      final url = Endpoints.createQuizAnswerForAdmin;

      final response = await _httpManager.restRequest(
        url: url,
        method: HttpMethods.post,
        body: request.toJson(),
      );

      if (response['statusCode'] == 200 || response['statusCode'] == 201) {
        debugPrint('createQuizAnswer DataSource success: ${response['data']}');
        return true;
      } else {
        debugPrint(
            'createQuizAnswer DataSource failed: ${response['statusMessage']}');
        return false;
      }
    } catch (e) {
      debugPrint('createQuizAnswer DataSource error: $e');
      return false;
    }
  }

  Future<bool> updateQuizAnswer(
      String quizAnswerId, CreateQuizAnswerRequest request) async {
    try {
      final url = Endpoints.updateQuizAnswerForAdmin
          .replaceFirst('{quizAnswerId}', quizAnswerId);

      final response = await _httpManager.restRequest(
        url: url,
        method: HttpMethods.put,
        body: request.toJson(),
      );

      if (response['statusCode'] == 200) {
        debugPrint('updateQuizAnswer DataSource success: ${response['data']}');
        return true;
      } else {
        debugPrint(
            'updateQuizAnswer DataSource failed: ${response['statusMessage']}');
        return false;
      }
    } catch (e) {
      debugPrint('updateQuizAnswer DataSource error: $e');
      return false;
    }
  }

  Future<bool> deleteQuizAnswer(String quizAnswerId) async {
    try {
      final url = Endpoints.deleteQuizAnswerForAdmin
          .replaceFirst('{quizAnswerId}', quizAnswerId);

      final response = await _httpManager.restRequest(
        url: url,
        method: HttpMethods.delete,
      );

      if (response['statusCode'] == 200) {
        debugPrint('deleteQuizAnswer DataSource success');
        return true;
      } else {
        debugPrint(
            'deleteQuizAnswer DataSource failed: ${response['statusMessage']}');
        return false;
      }
    } catch (e) {
      debugPrint('deleteQuizAnswer DataSource error: $e');
      return false;
    }
  }
}
