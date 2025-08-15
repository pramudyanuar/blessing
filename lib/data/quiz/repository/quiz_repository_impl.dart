import 'package:blessing/data/core/models/paging_response.dart';
import 'package:blessing/data/quiz/datasource/quiz_remote_datasource.dart';
import 'package:blessing/data/quiz/models/request/create_quiz_request.dart';
import 'package:blessing/data/quiz/models/response/quiz_response.dart';
import 'package:flutter/foundation.dart';

class QuizRepository {
  final QuizDataSource _dataSource = QuizDataSource();

  Future<({List<QuizResponse> quizzes, PagingResponse paging})?> getAllQuizzes({
    int page = 1,
    int size = 10,
  }) async {
    try {
      final result = await _dataSource.getAllQuizzes(
        page: page,
        size: size,
      );
      return result;
    } catch (e) {
      debugPrint('Error in QuizRepository (getAllQuizzes): $e');
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
      return await _dataSource.searchQuizzesByCourseId(
        courseId: courseId,
        page: page,
        size: size,
      );
    } catch (e) {
      debugPrint('Error in QuizRepository (searchQuizzesByCourseId): $e');
      return null;
    }
  }


  Future<QuizResponse?> getQuizById(String quizId) async {
    try {
      return await _dataSource.getQuizById(quizId);
    } catch (e) {
      debugPrint('Error in QuizRepository (getQuizById): $e');
      return null;
    }
  }

  Future<bool> createQuiz(CreateQuizRequest request) async {
    try {
      return await _dataSource.createQuiz(request);
    } catch (e) {
      debugPrint('Error in QuizRepository (createQuiz): $e');
      return false;
    }
  }

  Future<bool> updateQuiz(String quizId, CreateQuizRequest request) async {
    try {
      return await _dataSource.updateQuiz(quizId, request);
    } catch (e) {
      debugPrint('Error in QuizRepository (updateQuiz): $e');
      return false;
    }
  }

  Future<bool> deleteQuiz(String quizId) async {
    try {
      return await _dataSource.deleteQuiz(quizId);
    } catch (e) {
      debugPrint('Error in QuizRepository (deleteQuiz): $e');
      return false;
    }
  }
}
