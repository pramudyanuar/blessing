// lib/data/quiz/repository/quiz_answer_repository_impl.dart

import 'package:blessing/data/core/models/paging_response.dart';
import 'package:blessing/data/quiz/datasource/quiz_answer_remote_datasource.dart';
import 'package:blessing/data/quiz/models/request/create_quiz_answer_request.dart';
import 'package:blessing/data/quiz/models/response/quiz_answer_response.dart';
import 'package:flutter/foundation.dart';

class QuizAnswerRepository {
  final QuizAnswerDataSource _dataSource = QuizAnswerDataSource();

  Future<({List<QuizAnswerResponse> answers, PagingResponse paging})?>
      getAllQuizAnswers({
    int page = 1,
    int size = 10,
    String? quizId,
  }) async {
    try {
      final result = await _dataSource.getAllQuizAnswers(
        page: page,
        size: size,
        quizId: quizId,
      );
      return result;
    } catch (e) {
      debugPrint('Error in QuizAnswerRepository (getAllQuizAnswers): $e');
      return null;
    }
  }

  Future<bool> createQuizAnswer(CreateQuizAnswerRequest request) async {
    try {
      return await _dataSource.createQuizAnswer(request);
    } catch (e) {
      debugPrint('Error in QuizAnswerRepository (createQuizAnswer): $e');
      return false;
    }
  }

  Future<bool> updateQuizAnswer(
      String quizAnswerId, CreateQuizAnswerRequest request) async {
    try {
      return await _dataSource.updateQuizAnswer(quizAnswerId, request);
    } catch (e) {
      debugPrint('Error in QuizAnswerRepository (updateQuizAnswer): $e');
      return false;
    }
  }

  Future<bool> deleteQuizAnswer(String quizAnswerId) async {
    try {
      return await _dataSource.deleteQuizAnswer(quizAnswerId);
    } catch (e) {
      debugPrint('Error in QuizAnswerRepository (deleteQuizAnswer): $e');
      return false;
    }
  }
}
