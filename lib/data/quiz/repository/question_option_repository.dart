import 'package:blessing/data/core/models/paging_response.dart';
import 'package:blessing/data/quiz/datasource/question_option_datasource.dart';
import 'package:blessing/data/quiz/models/request/create_question_option_request.dart';
import 'package:blessing/data/quiz/models/response/question_option_response.dart';
import 'package:flutter/foundation.dart';

class QuestionOptionRepository {
  final QuestionOptionDataSource _dataSource = QuestionOptionDataSource();

  Future<({List<QuestionOptionResponse> options, PagingResponse paging})?>
      getAllOptionsByQuestionId(
    String questionId, {
    int page = 1,
    int size = 10,
  }) async {
    try {
      final result = await _dataSource.getAllOptionsByQuestionId(
        questionId,
        page: page,
        size: size,
      );
      return result;
    } catch (e) {
      debugPrint(
          'Error in QuestionOptionRepository (getAllOptionsByQuestionId): $e');
      return null;
    }
  }

  Future<bool> createOption(
      String questionId, CreateQuestionOptionRequest request) async {
    try {
      return await _dataSource.createOption(questionId, request);
    } catch (e) {
      debugPrint('Error in QuestionOptionRepository (createOption): $e');
      return false;
    }
  }

  Future<bool> updateOption(
      String optionId, CreateQuestionOptionRequest request) async {
    try {
      return await _dataSource.updateOption(optionId, request);
    } catch (e) {
      debugPrint('Error in QuestionOptionRepository (updateOption): $e');
      return false;
    }
  }

  Future<bool> deleteOption(String optionId) async {
    try {
      return await _dataSource.deleteOption(optionId);
    } catch (e) {
      debugPrint('Error in QuestionOptionRepository (deleteOption): $e');
      return false;
    }
  }
}
