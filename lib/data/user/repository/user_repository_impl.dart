
import 'package:blessing/data/core/models/paging_response.dart';
import 'package:blessing/data/user/datasource/user_remote_data_source.dart';
import 'package:blessing/data/user/models/request/login_user_request.dart';
import 'package:blessing/data/user/models/request/register_user_request.dart';
import 'package:blessing/data/user/models/request/update_user_request.dart';
import 'package:blessing/data/user/models/response/login_response.dart';
import 'package:blessing/data/user/models/response/user_response.dart';

class UserRepository {
  final UserDataSource _dataSource = UserDataSource();

  Future<LoginResponse?> login(LoginUserRequest request) {
    return _dataSource.login(request);
  }

  Future<UserResponse?> register(RegisterUserRequest request) {
    return _dataSource.register(request);
  }

  Future<UserResponse?> updateUserAdmin(String userId, UpdateUserRequest request) {
    return _dataSource.updateUserAdmin(userId, request);
  }

  Future<UserResponse?> updateUser(UpdateUserRequest request) {
    return _dataSource.updateUser(request);
  }

  Future<UserResponse?> getUserById(String userId) {
    return _dataSource.getUserById(userId);
  }

  Future<UserResponse?> getCurrentUser() {
    return _dataSource.getCurrentUser();
  }

  Future<({List<UserResponse> users, PagingResponse paging})?> getAllUsers({
    int page = 1,
    int size = 9,
  }) {
    return _dataSource.getAllUsers(page: page, size: size);
  }

  Future<List<UserResponse>> getAllUsersComplete() {
    return _dataSource.getAllUsersComplete();
  }

  Future<UserResponse?> deleteUserAdmin(String userId) {
    return _dataSource.deleteUserAdmin(userId);
  }

  Future<bool> logout() {
    return _dataSource.logout();
  }
}
