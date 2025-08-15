import 'package:blessing/data/session/datasource/answer_remote_datasource.dart';
import 'package:blessing/data/session/models/request/create_user_answer_request.dart';
import 'package:blessing/data/session/models/response/user_answer_response.dart';
import 'package:flutter/foundation.dart';

class AnswerRepository {
  final AnswerDataSource _dataSource = AnswerDataSource();

  Future<UserAnswerResponse?> createUserAnswer(
      CreateUserAnswerRequest request) async {
    try {
      return await _dataSource.createUserAnswer(request);
    } catch (e) {
      debugPrint('Error in AnswerRepository (createUserAnswer): $e');
      return null;
    }
  }
}
