import 'dart:io';

import 'package:blessing/core/services/endpoints.dart';
import 'package:blessing/core/services/http_manager.dart';
import 'package:blessing/data/core/models/paging_response.dart';
import 'package:blessing/data/quiz/models/request/create_question_request.dart';
import 'package:blessing/data/quiz/models/response/question_response.dart';
import 'package:flutter/foundation.dart';

class QuestionDataSource {
  final HttpManager _httpManager = HttpManager();

  Future<({List<QuestionResponse> questions, PagingResponse paging})?>
      getAllQuestions({
    int page = 1,
    int size = 10,
    String? quizId,
  }) async {
    try {
      String url = '${Endpoints.getAllQuestions}?page=$page&size=$size';
      if (quizId != null) {
        url += '&quiz_id=$quizId';
      }

      final response = await _httpManager.restRequest(
        url: url,
        method: HttpMethods.get,
      );

      if (response['statusCode'] == 200) {
        debugPrint('getAllQuestions DataSource response: ${response['data']}');

        final questions = (response['data']['data'] as List)
            .map((e) => QuestionResponse.fromJson(e))
            .toList();

        final paging = PagingResponse.fromJson(response['data']['paging']);

        return (questions: questions, paging: paging);
      } else {
        debugPrint(
            'getAllQuestions DataSource failed: ${response['statusMessage']}');
        return null;
      }
    } catch (e) {
      debugPrint('getAllQuestions DataSource error: $e');
      return null;
    }
  }

  Future<String?> uploadImage(File imageFile) async {
    try {
      final url = Endpoints.uploadQuestionImageForAdmin;
      final response = await _httpManager.uploadFileRequest(
        url: url,
        file: imageFile,
        // Sesuaikan 'fileFieldKey' jika backend mengharapkan nama field yang berbeda, misal 'image'
        fileFieldKey: 'file',
      );

      if (response['statusCode'] == 200 && response['data'] != null) {
        // Berdasarkan JSON response Anda: { "data": { "url": "..." } }
        final imageUrl = response['data']['data']['url'];
        debugPrint('Image uploaded successfully: $imageUrl');
        return imageUrl;
      } else {
        debugPrint(
            'Image upload failed: ${response['statusCode']} - ${response['statusMessage']}');
        return null;
      }
    } catch (e) {
      debugPrint('Image upload error: $e');
      return null;
    }
  }

  Future<QuestionResponse?> getQuestionById(String questionId) async {
    try {
      final url =
          Endpoints.getQuestionById.replaceFirst('{questionId}', questionId);

      final response = await _httpManager.restRequest(
        url: url,
        method: HttpMethods.get,
      );

      if (response['statusCode'] == 200) {
        debugPrint(
            'getQuestionById DataSource response: ${response['data']}');

        final data = response['data']['data'];
        return QuestionResponse.fromJson(data);
      } else {
        debugPrint(
            'getQuestionById DataSource failed: ${response['statusMessage']}');
        return null;
      }
    } catch (e) {
      debugPrint('getQuestionById DataSource error: $e');
      return null;
    }
  }

  Future<bool> createQuestion(CreateQuestionRequest request) async {
    try {
      final url = Endpoints.createQuestion;

      final response = await _httpManager.restRequest(
        url: url,
        method: HttpMethods.post,
        body: request.toJson(),
      );

      if (response['statusCode'] == 200 || response['statusCode'] == 201) {
        debugPrint('createQuestion DataSource success: ${response['data']}');
        return true;
      } else {
        debugPrint(
            'createQuestion DataSource failed: ${response['statusMessage']}');
        return false;
      }
    } catch (e) {
      debugPrint('createQuestion DataSource error: $e');
      return false;
    }
  }

  Future<bool> updateQuestion(
      String questionId, CreateQuestionRequest request) async {
    try {
      final url =
          Endpoints.updateQuestion.replaceFirst('{questionId}', questionId);

      final response = await _httpManager.restRequest(
        url: url,
        method: HttpMethods.put,
        body: request.toJson(),
      );

      if (response['statusCode'] == 200) {
        debugPrint('updateQuestion DataSource success: ${response['data']}');
        return true;
      } else {
        debugPrint(
            'updateQuestion DataSource failed: ${response['statusMessage']}');
        return false;
      }
    } catch (e) {
      debugPrint('updateQuestion DataSource error: $e');
      return false;
    }
  }

  Future<bool> deleteQuestion(String questionId) async {
    try {
      final url =
          Endpoints.deleteQuestion.replaceFirst('{questionId}', questionId);

      final response = await _httpManager.restRequest(
        url: url,
        method: HttpMethods.delete,
      );

      if (response['statusCode'] == 200) {
        debugPrint('deleteQuestion DataSource success');
        return true;
      } else {
        debugPrint(
            'deleteQuestion DataSource failed: ${response['statusMessage']}');
        return false;
      }
    } catch (e) {
      debugPrint('deleteQuestion DataSource error: $e');
      return false;
    }
  }
}