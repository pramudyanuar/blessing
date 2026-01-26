import 'dart:io';
import 'package:blessing/data/core/models/paging_response.dart';
import 'package:blessing/data/quiz/datasource/question_remote_datasource.dart';
import 'package:blessing/data/quiz/models/request/create_question_request.dart';
import 'package:blessing/data/quiz/models/response/question_response.dart';
import 'package:flutter/foundation.dart';

class QuestionRepository {
  final QuestionDataSource _dataSource = QuestionDataSource();

  Future<({List<QuestionResponse> questions, PagingResponse paging})?>
      getAllQuestions({
    int page = 1,
    int size = 10,
    String? quizId,
  }) async {
    try {
      final result = await _dataSource.getAllQuestions(
        page: page,
        size: size,
        quizId: quizId,
      );
      return result;
    } catch (e) {
      debugPrint('Error in QuestionRepository (getAllQuestions): $e');
      return null;
    }
  }

  Future<QuestionResponse?> getQuestionById(String questionId) async {
    try {
      return await _dataSource.getQuestionById(questionId);
    } catch (e) {
      debugPrint('Error in QuestionRepository (getQuestionById): $e');
      return null;
    }
  }

  Future<QuestionResponse?> createQuestion(
      CreateQuestionRequest request) async {
    try {
      return await _dataSource.createQuestion(request);
    } catch (e) {
      debugPrint('Error in QuestionRepository (createQuestion): $e');
      return null;
    }
  }

  Future<QuestionResponse?> updateQuestion(
    String questionId,
    CreateQuestionRequest request,
  ) async {
    try {
      return await _dataSource.updateQuestion(questionId, request);
    } catch (e) {
      debugPrint('Error in QuestionRepository (updateQuestion): $e');
      return null;
    }
  }

  Future<bool> deleteQuestion(String questionId) async {
    try {
      return await _dataSource.deleteQuestion(questionId);
    } catch (e) {
      debugPrint('Error in QuestionRepository (deleteQuestion): $e');
      return false;
    }
  }

  Future<String?> uploadQuestionImage(File imageFile) async {
    try {
      final imageUrl = await _dataSource.uploadImage(imageFile);
      return imageUrl;
    } catch (e) {
      debugPrint('Error in QuestionRepository (uploadQuestionImage): $e');
      return null;
    }
  }
}
