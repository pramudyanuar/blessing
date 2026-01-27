import 'package:blessing/core/services/endpoints.dart';
import 'package:blessing/core/services/http_manager.dart';
import 'package:blessing/data/session/models/request/create_user_answer_request.dart';
import 'package:blessing/data/session/models/response/user_answer_response.dart';
import 'package:flutter/foundation.dart';

class AnswerDataSource {
  final HttpManager _httpManager = HttpManager();

  Future<UserAnswerResponse?> createUserAnswer(
      CreateUserAnswerRequest request) async {
    try {
      final url = Endpoints.createUserAnswer;
      final response = await _httpManager.restRequest(
        url: url,
        method: HttpMethods.post,
        body: request.toJson(),
      );

      if (response['statusCode'] == 200 || response['statusCode'] == 201) {
        debugPrint('createUserAnswer DataSource success: ${response['data']}');
        final responseData = response['data'] as Map<String, dynamic>?;
        final data = responseData?['data'];
        if (data != null) {
          return UserAnswerResponse.fromJson(data as Map<String, dynamic>);
        }
        return null;
      } else {
        debugPrint(
            'createUserAnswer DataSource failed: ${response['statusMessage']}');
        return null;
      }
    } catch (e) {
      debugPrint('createUserAnswer DataSource error: $e');
      return null;
    }
  }

  Future<UserAnswerResponse?> updateUserAnswer(
      CreateUserAnswerRequest request) async {
    try {
      final url = Endpoints.createUserAnswer;
      final response = await _httpManager.restRequest(
        url: url,
        method: HttpMethods.post,
        body: request.toJson(),
      );

      if (response['statusCode'] == 200 || response['statusCode'] == 201) {
        debugPrint('updateUserAnswer DataSource success: ${response['data']}');
        final responseData = response['data'] as Map<String, dynamic>?;
        final data = responseData?['data'];
        if (data != null) {
          return UserAnswerResponse.fromJson(data as Map<String, dynamic>);
        }
        return null;
      } else {
        debugPrint(
            'updateUserAnswer DataSource failed: ${response['statusMessage']}');
        return null;
      }
    } catch (e) {
      debugPrint('updateUserAnswer DataSource error: $e');
      return null;
    }
  }
}
