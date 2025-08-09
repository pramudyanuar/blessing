import 'package:blessing/core/services/endpoints.dart';
import 'package:blessing/core/services/http_manager.dart';
import 'package:blessing/data/user/models/request/login_user_request.dart';
import 'package:blessing/data/user/models/request/register_user_request.dart';
import 'package:blessing/data/user/models/request/update_user_request.dart';
import 'package:blessing/data/user/models/response/login_response.dart';
import 'package:blessing/data/user/models/response/user_response.dart';
import 'package:flutter/foundation.dart';

class UserDataSource {
  final HttpManager _httpManager = HttpManager();

  Future<LoginResponse?> login(LoginUserRequest data) async {
    try {
      final response = await _httpManager.restRequest(
        url: Endpoints.loginUser,
        method: HttpMethods.post,
        body: data.toJson(),
      );

      if (response['statusCode'] == 200) {
        debugPrint('login DataSource response: ${response['data']}');
        return LoginResponse.fromJson(response['data']);
      } else {
        debugPrint('login DataSource failed: ${response['statusMessage']}');
        return null;
      }
    } catch (e) {
      debugPrint('login DataSource error: $e');
      return null;
    }
  }

  Future<UserResponse?> register(RegisterUserRequest data) async {
    try {
      final response = await _httpManager.restRequest(
        url: Endpoints.registerUser,
        method: HttpMethods.post,
        body: data.toJson(),
      );

      if (response['statusCode'] == 200) {
        debugPrint('Register successful: ${response['data']}');
        return UserResponse.fromJson(response['data']);
      } else {
        final errorMessage =
            response['message'] ?? 'An unexpected error occurred';
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Register error: $e');
      rethrow;
    }
  }

  Future<UserResponse?> updateUser(
      String userId, UpdateUserRequest data) async {
    try {
      final response = await _httpManager.restRequest(
        url: "${Endpoints.updateUser}/$userId",
        method: HttpMethods.put,
        body: data.toJson(),
      );

      if (response['statusCode'] == 200) {
        debugPrint('updateUser DataSource response: ${response['data']}');
        return UserResponse.fromJson(response['data']);
      } else {
        debugPrint(
            'updateUser DataSource failed: ${response['statusMessage']}');
        return null;
      }
    } catch (e) {
      debugPrint('updateUser DataSource error: $e');
      return null;
    }
  }

  Future<UserResponse?> getCurrentUser() async {
    try {
      final response = await _httpManager.restRequest(
        url: Endpoints.getCurrentUser,
        method: HttpMethods.get,
      );

      if (response['statusCode'] == 200) {
        debugPrint('getCurrentUser DataSource response: ${response['data']}');
        return UserResponse.fromJson(response['data']);
      } else {
        debugPrint(
            'getCurrentUser DataSource failed: ${response['statusMessage']}');
        return null;
      }
    } catch (e) {
      debugPrint('getCurrentUser DataSource error: $e');
      return null;
    }
  }
}
