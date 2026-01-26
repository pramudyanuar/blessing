import 'package:blessing/core/services/endpoints.dart';
import 'package:blessing/core/services/http_manager.dart';
import 'package:blessing/data/core/models/paging_response.dart';
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

  Future<UserResponse?> getUserById(String userId) async {
    try {
      final response = await _httpManager.restRequest(
        url: Endpoints.getUserById.replaceFirst('{id}', userId),
        method: HttpMethods.get,
      );

      if (response['statusCode'] == 200) {
        debugPrint('getUserById DataSource response: ${response['data']}');
        return UserResponse.fromJson(response['data']);
      } else {
        debugPrint(
            'getUserById DataSource failed: ${response['statusMessage']}');
        return null;
      }
    } catch (e) {
      debugPrint('getUserById DataSource error: $e');
      return null;
    }
  }

  Future<UserResponse?> updateUserAdmin(
      String userId, UpdateUserRequest data) async {
    try {
      final url = Endpoints.updateUserForAdmin.replaceFirst('{id}', userId);

      final response = await _httpManager.restRequest(
        url: url,
        method: HttpMethods.put,
        body: data.toJson(),
      );

      if (response['statusCode'] == 200) {
        debugPrint('updateUserAdmin DataSource response: ${response['data']}');
        return UserResponse.fromJson(response['data']);
      } else {
        debugPrint(
            'updateUserAdmin DataSource failed: ${response['statusMessage']}');
        return null;
      }
    } catch (e) {
      debugPrint('updateUserAdmin DataSource error: $e');
      return null;
    }
  }

  Future<UserResponse?> updateUser(UpdateUserRequest data) async {
    try {
      final response = await _httpManager.restRequest(
        url: Endpoints.updateUser, // ini /api/users
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

  Future<({List<UserResponse> users, PagingResponse paging})?> getAllUsers({
    int page = 1,
    int size = 9,
  }) async {
    try {
      final response = await _httpManager.restRequest(
        url: '${Endpoints.getAllUsers}?page=$page&size=$size',
        method: HttpMethods.get,
      );

      if (response['statusCode'] == 200) {
        debugPrint('getAllUsers DataSource response: ${response['data']}');

        final users = (response['data']['data'] as List)
            .map((e) => UserResponse.fromJson(e))
            .toList();

        final paging = PagingResponse.fromJson(response['data']['paging']);

        return (users: users, paging: paging);
      } else {
        debugPrint(
            'getAllUsers DataSource failed: ${response['statusMessage']}');
        return null;
      }
    } catch (e) {
      debugPrint('getAllUsers DataSource error: $e');
      return null;
    }
  }


  Future<List<UserResponse>> getAllUsersComplete() async {
    List<UserResponse> allUsers = [];
    int page = 1;
    const int size = 100; // maksimal size

    while (true) {
      final result = await getAllUsers(page: page, size: size);
      if (result == null) break;

      allUsers.addAll(result.users);

      // Kalau data yang diterima kurang dari size berarti sudah akhir halaman
      if (result.users.length < size) {
        break;
      } else {
        page++;
      }
    }

    return allUsers;
  }


  Future<UserResponse?> deleteUserAdmin(String userId) async {
    try {
      final url = Endpoints.deleteUserForAdmin.replaceFirst('{id}', userId);

      final response = await _httpManager.restRequest(
        url: url,
        method: HttpMethods.delete,
      );

      if (response['statusCode'] == 200) {
        debugPrint('deleteUserAdmin DataSource success: ${response['data']}');
        return UserResponse.fromJson(response['data']);
      } else {
        debugPrint(
            'deleteUserAdmin DataSource failed: ${response['statusMessage']}');
        return null;
      }
    } catch (e) {
      debugPrint('deleteUserAdmin DataSource error: $e');
      return null;
    }
  }

  Future<bool> logout() async {
    try {
      final response = await _httpManager.restRequest(
        url: Endpoints.logoutUser,
        method: HttpMethods.post,
      );

      if (response['statusCode'] == 200) {
        debugPrint('logout DataSource response: ${response['data']}');

        final rawValue = response['data']?['data'];
        final result =
            rawValue == true || rawValue.toString().toLowerCase() == 'true';

        debugPrint('Logout successful: $result');
        return result;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint('logout DataSource error: $e');
      return false;
    }
  }

}
