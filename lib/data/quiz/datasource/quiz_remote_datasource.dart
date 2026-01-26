import 'package:blessing/core/services/endpoints.dart';
import 'package:blessing/core/services/http_manager.dart';
import 'package:blessing/data/core/models/paging_response.dart';
import 'package:blessing/data/quiz/models/request/create_quiz_request.dart';
import 'package:blessing/data/quiz/models/response/quiz_response.dart';
import 'package:flutter/foundation.dart';

class QuizDataSource {
  final HttpManager _httpManager = HttpManager();

  Future<({List<QuizResponse> quizzes, PagingResponse paging})?> getAllQuizzes({
    int page = 1,
    int size = 10,
  }) async {
    try {
      final url = '${Endpoints.getAllQuizzes}?page=$page&size=$size';

      final response = await _httpManager.restRequest(
        url: url,
        method: HttpMethods.get,
      );

      if (response['statusCode'] == 200) {
        debugPrint('getAllQuizzes DataSource response: ${response['data']}');

        final quizzes = (response['data']['data'] as List)
            .map((e) => QuizResponse.fromJson(e))
            .toList();

        final paging = PagingResponse.fromJson(response['data']['paging']);

        return (quizzes: quizzes, paging: paging);
      } else {
        debugPrint(
            'getAllQuizzes DataSource failed: ${response['statusMessage']}');
        return null;
      }
    } catch (e) {
      debugPrint('getAllQuizzes DataSource error: $e');
      return null;
    }
  }

  Future<QuizResponse?> getQuizById(String quizId) async {
    try {
      final url = Endpoints.getQuizById.replaceFirst('{quizId}', quizId);

      final response = await _httpManager.restRequest(
        url: url,
        method: HttpMethods.get,
      );

      if (response['statusCode'] == 200) {
        debugPrint('getQuizById DataSource response: ${response['data']}');

        final data = response['data']['data'];
        return QuizResponse.fromJson(data);
      } else {
        debugPrint(
            'getQuizById DataSource failed: ${response['statusMessage']}');
        return null;
      }
    } catch (e) {
      debugPrint('getQuizById DataSource error: $e');
      return null;
    }
  }

  Future<({List<QuizResponse> quizzes, PagingResponse paging})?>
      searchQuizzesByCourseId({
    required String courseId,
    int page = 1,
    int size = 10,
  }) async {
    try {
      final url =
          '${Endpoints.getAllQuizzes}?page=$page&size=$size&course_id=$courseId';

      final response = await _httpManager.restRequest(
        url: url,
        method: HttpMethods.get,
      );

      if (response['statusCode'] == 200) {
        debugPrint(
            'searchQuizzesByCourseId DataSource response: ${response['data']}');

        final quizzes = (response['data']['data'] as List)
            .map((e) => QuizResponse.fromJson(e))
            .toList();

        final paging = PagingResponse.fromJson(response['data']['paging']);

        return (quizzes: quizzes, paging: paging);
      } else {
        debugPrint(
            'searchQuizzesByCourseId failed: ${response['statusMessage']}');
        return null;
      }
    } catch (e) {
      debugPrint('searchQuizzesByCourseId error: $e');
      return null;
    }
  }


  Future<QuizResponse?> createQuiz(CreateQuizRequest request) async {
    try {
      final url = Endpoints.createQuiz;

      final response = await _httpManager.restRequest(
        url: url,
        method: HttpMethods.post,
        body: request.toJson(),
      );

      if (response['statusCode'] == 200 || response['statusCode'] == 201) {
        debugPrint('createQuiz DataSource success: ${response['data']}');

        final data = response['data']['data'];
        return QuizResponse.fromJson(data);
      } else {
        debugPrint(
            'createQuiz DataSource failed: ${response['statusMessage']}');
        return null;
      }
    } catch (e) {
      debugPrint('createQuiz DataSource error: $e');
      return null;
    }
  }


  Future<bool> updateQuiz(String quizId, CreateQuizRequest request) async {
    try {
      final url = Endpoints.updateQuiz.replaceFirst('{quizId}', quizId);

      final response = await _httpManager.restRequest(
        url: url,
        method: HttpMethods.put,
        body: request.toJson(),
      );

      if (response['statusCode'] == 200) {
        debugPrint('updateQuiz DataSource success: ${response['data']}');
        return true;
      } else {
        debugPrint(
            'updateQuiz DataSource failed: ${response['statusMessage']}');
        return false;
      }
    } catch (e) {
      debugPrint('updateQuiz DataSource error: $e');
      return false;
    }
  }

  Future<bool> deleteQuiz(String quizId) async {
    try {
      final url = Endpoints.deleteQuiz.replaceFirst('{quizId}', quizId);

      final response = await _httpManager.restRequest(
        url: url,
        method: HttpMethods.delete,
      );

      if (response['statusCode'] == 200) {
        debugPrint('deleteQuiz DataSource success');
        return true;
      } else {
        debugPrint(
            'deleteQuiz DataSource failed: ${response['statusMessage']}');
        return false;
      }
    } catch (e) {
      debugPrint('deleteQuiz DataSource error: $e');
      return false;
    }
  }
}
