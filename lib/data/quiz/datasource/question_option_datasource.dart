import 'package:blessing/core/services/endpoints.dart';
import 'package:blessing/core/services/http_manager.dart';
import 'package:blessing/data/core/models/paging_response.dart';
import 'package:blessing/data/quiz/models/request/create_question_option_request.dart';
import 'package:blessing/data/quiz/models/response/question_option_response.dart';
import 'package:flutter/foundation.dart';

class QuestionOptionDataSource {
  final HttpManager _httpManager = HttpManager();

  Future<({List<QuestionOptionResponse> options, PagingResponse paging})?>
      getAllOptionsByQuestionId(
    String questionId, {
    int page = 1,
    int size = 10,
  }) async {
    try {
      final url = Endpoints.getAllOptionsByQuestionId
          .replaceFirst('{questionId}', questionId);
      final finalUrl = '$url?page=$page&size=$size';

      final response = await _httpManager.restRequest(
        url: finalUrl,
        method: HttpMethods.get,
      );

      if (response['statusCode'] == 200) {
        debugPrint(
            'getAllOptionsByQuestionId DataSource response: ${response['data']}');

        final options = (response['data']['data'] as List)
            .map((e) => QuestionOptionResponse.fromJson(e))
            .toList();

        final paging = PagingResponse.fromJson(response['data']['paging']);

        return (options: options, paging: paging);
      } else {
        debugPrint(
            'getAllOptionsByQuestionId DataSource failed: ${response['statusMessage']}');
        return null;
      }
    } catch (e) {
      debugPrint('getAllOptionsByQuestionId DataSource error: $e');
      return null;
    }
  }

  Future<bool> createOption(
      String questionId, CreateQuestionOptionRequest request) async {
    try {
      final url =
          Endpoints.createOption.replaceFirst('{questionId}', questionId);

      final response = await _httpManager.restRequest(
        url: url,
        method: HttpMethods.post,
        body: request.toJson(),
      );

      if (response['statusCode'] == 200 || response['statusCode'] == 201) {
        debugPrint('createOption DataSource success: ${response['data']}');
        return true;
      } else {
        debugPrint(
            'createOption DataSource failed: ${response['statusMessage']}');
        return false;
      }
    } catch (e) {
      debugPrint('createOption DataSource error: $e');
      return false;
    }
  }

  Future<bool> updateOption(
      String optionId, CreateQuestionOptionRequest request) async {
    try {
      final url = Endpoints.updateOption.replaceFirst('{optionId}', optionId);

      final response = await _httpManager.restRequest(
        url: url,
        method: HttpMethods.put,
        body: request.toJson(),
      );

      if (response['statusCode'] == 200) {
        debugPrint('updateOption DataSource success: ${response['data']}');
        return true;
      } else {
        debugPrint(
            'updateOption DataSource failed: ${response['statusMessage']}');
        return false;
      }
    } catch (e) {
      debugPrint('updateOption DataSource error: $e');
      return false;
    }
  }

  Future<bool> deleteOption(String optionId) async {
    try {
      final url = Endpoints.deleteOption.replaceFirst('{optionId}', optionId);

      final response = await _httpManager.restRequest(
        url: url,
        method: HttpMethods.delete,
      );

      if (response['statusCode'] == 200) {
        debugPrint('deleteOption DataSource success');
        return true;
      } else {
        debugPrint(
            'deleteOption DataSource failed: ${response['statusMessage']}');
        return false;
      }
    } catch (e) {
      debugPrint('deleteOption DataSource error: $e');
      return false;
    }
  }
}
