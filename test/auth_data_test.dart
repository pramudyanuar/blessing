
import 'package:blessing/data/user/datasource/user_remote_data_source.dart';
import 'package:blessing/data/user/models/request/login_user_request.dart';
import 'package:blessing/data/user/models/request/register_user_request.dart';
import 'package:blessing/data/user/models/request/update_user_request.dart';
import 'package:blessing/data/user/models/response/login_response.dart';
import 'package:blessing/data/user/models/response/user_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late UserDataSource userDataSource;

  setUp(() {
    userDataSource = UserDataSource();
  });

  test('Login berhasil dengan kredensial yang benar', () async {
    final loginRequest = LoginUserRequest(
      email: 'user1@user.com',
      password: 'test123',
    );

    final LoginResponse? response = await userDataSource.login(loginRequest);

    expect(response, isNotNull);
    expect(response?.token, isNotEmpty);
  });

  test('Register berhasil dengan data yang valid', () async {
    // Gunakan email yang unik untuk setiap test run untuk menghindari konflik
    final uniqueEmail =
        'testuser${DateTime.now().millisecondsSinceEpoch}@example.com';
    final registerRequest = RegisterUserRequest(
      email: uniqueEmail,
      password: 'password123',
      username: 'username',
      gradeLevel: '10',
    );

    final UserResponse? response =
        await userDataSource.register(registerRequest);

    expect(response, isNotNull);
    expect(response?.id, isNotEmpty);
    expect(response?.email, equals(uniqueEmail));
    expect(response?.username, equals('username'));
  });

  test('Get current user berhasil saat token valid', () async {
    // Asumsi: Anda sudah login sebelumnya dan memiliki token yang valid
    // dalam HttpManager yang digunakan oleh UserDataSource.
    final UserResponse? response = await userDataSource.getCurrentUser();

    expect(response, isNotNull);
    expect(response?.id, isNotEmpty);
    expect(response?.email, contains('@'));
    expect(response?.username, isNotEmpty);
    expect(response?.role, isNotNull);
  });

  test('Update user berhasil', () async {
    // Asumsi: Anda memiliki user ID yang valid untuk diupdate.
    // Anda mungkin perlu mendapatkan ini dari response login/register/getCurrentUser.
    const String testUserID =
        'user-id-to-update'; // Ganti dengan ID user yang valid

    final updateUserRequest = UpdateUserRequest(
      username: 'newtestusername',
      gradeLevel: '11',
    );

    final UserResponse? response =
        await userDataSource.updateUser(testUserID, updateUserRequest);

    expect(response, isNotNull);
    expect(response?.id, equals(testUserID));
    expect(response?.username, equals('newtestusername'));
    expect(response?.gradeLevel, equals(11));
  });
}
