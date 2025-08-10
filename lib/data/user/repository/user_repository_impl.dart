
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

  Future<UserResponse?> updateUser(String userId, UpdateUserRequest request) {
    return _dataSource.updateUser(userId, request);
  }

  Future<UserResponse?> getCurrentUser() {
    return _dataSource.getCurrentUser();
  }

  Future<bool> logout() {
    return _dataSource.logout();
  }
}
